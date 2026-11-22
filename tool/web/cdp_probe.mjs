#!/usr/bin/env node
// Headless browser probe for the Flutter web build.
//
// Launches Edge/Chrome with the DevTools protocol, loads a URL, captures
// console errors, failed network requests, a small DOM report and a screenshot.
// This is real browser execution, not a Flutter widget test.
//
// Usage:
//   node tool/web/cdp_probe.mjs <url> <out.png> [waitMs] [width] [height]

import { spawn } from 'node:child_process';
import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';

const [, , url, outPng = 'probe.png', waitArg = '15000', widthArg = '390', heightArg = '844'] = process.argv;
if (!url) {
  console.error('usage: node cdp_probe.mjs <url> <out.png> [waitMs] [width] [height]');
  process.exit(2);
}
const waitMs = Number(waitArg);
const width = Number(widthArg);
const height = Number(heightArg);
const port = 9500 + Math.floor(Math.random() * 400);
const profile = path.join(os.tmpdir(), `fish-cdp-${Date.now()}`);
const edge =
  process.env.BROWSER_PATH ||
  'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe';

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
const extraArgs = process.env.PROBE_IGNORE_CERT
  ? ['--ignore-certificate-errors']
  : [];

const browser = spawn(
  edge,
  [
    '--headless=new',
    '--disable-gpu',
    '--no-first-run',
    '--no-default-browser-check',
    '--disable-extensions',
    ...extraArgs,
    `--remote-debugging-port=${port}`,
    `--user-data-dir=${profile}`,
    `--window-size=${width},${height}`,
    'about:blank',
  ],
  { stdio: 'ignore' },
);

async function endpoint(pathname) {
  const response = await fetch(`http://127.0.0.1:${port}${pathname}`);
  if (!response.ok) throw new Error(`${pathname}: HTTP ${response.status}`);
  return response.json();
}

let target = null;
for (let attempt = 0; attempt < 60; attempt++) {
  try {
    const list = await endpoint('/json/list');
    target = list.find((entry) => entry.type === 'page');
    if (target) break;
  } catch {
    // Browser still starting.
  }
  await sleep(250);
}
if (!target) {
  browser.kill();
  console.error('Could not connect to the browser DevTools endpoint.');
  process.exit(3);
}

const socket = new WebSocket(target.webSocketDebuggerUrl);
await new Promise((resolve, reject) => {
  socket.addEventListener('open', resolve, { once: true });
  socket.addEventListener('error', reject, { once: true });
});

let nextId = 0;
const pending = new Map();
const consoleLines = [];
const exceptions = [];
const failedRequests = [];
const responses = [];

socket.addEventListener('message', (event) => {
  let message;
  try {
    message = JSON.parse(event.data);
  } catch {
    return;
  }
  if (message.id && pending.has(message.id)) {
    const { resolve, reject } = pending.get(message.id);
    pending.delete(message.id);
    if (message.error) reject(new Error(message.error.message));
    else resolve(message.result);
    return;
  }
  switch (message.method) {
    case 'Runtime.consoleAPICalled':
      consoleLines.push({
        type: message.params.type,
        text: message.params.args
          .map((arg) => arg.value ?? arg.description ?? arg.type)
          .join(' '),
      });
      break;
    case 'Runtime.exceptionThrown': {
      const details = message.params.exceptionDetails;
      exceptions.push({
        text: details.text,
        description: details.exception?.description ?? '',
      });
      break;
    }
    case 'Log.entryAdded':
      consoleLines.push({
        type: `log:${message.params.entry.level}`,
        text: message.params.entry.text,
      });
      break;
    case 'Network.loadingFailed':
      if (!message.params.canceled) {
        failedRequests.push({
          url: message.params.requestId,
          error: message.params.errorText,
          type: message.params.type,
        });
      }
      break;
    case 'Network.responseReceived':
      responses.push({
        status: message.params.response.status,
        url: message.params.response.url,
      });
      break;
  }
});

function send(method, params = {}) {
  const id = ++nextId;
  return new Promise((resolve, reject) => {
    pending.set(id, { resolve, reject });
    socket.send(JSON.stringify({ id, method, params }));
  });
}

try {
  await send('Runtime.enable');
  await send('Log.enable');
  await send('Page.enable');
  await send('Network.enable');
  await send('Emulation.setDeviceMetricsOverride', {
    width,
    height,
    deviceScaleFactor: 2,
    mobile: true,
  });
  await send('Page.navigate', { url });
  // Wait for the Flutter engine to paint its first frame (the splash removes
  // itself on `flutter-first-frame`). Cold loads of CanvasKit can take a while.
  const readyExpression = `!!document.querySelector('flt-glass-pane') &&
    !document.getElementById('fish-splash')`;
  const started = Date.now();
  let ready = false;
  while (Date.now() - started < waitMs) {
    const probe = await send('Runtime.evaluate', {
      expression: readyExpression,
      returnByValue: true,
    });
    if (probe.result?.value === true) {
      ready = true;
      break;
    }
    await sleep(500);
  }
  if (!ready) console.error(`Flutter did not finish loading within ${waitMs} ms`);
  await sleep(800);

  // Optional interaction steps, supplied as JSON in PROBE_STEPS:
  //   [{"wait":500},{"click":[195,660]},{"type":"text"},{"eval":"..."},
  //    {"screenshot":"C:/path.png"}]
  const stepResults = [];
  let steps = [];
  try {
    steps = JSON.parse(process.env.PROBE_STEPS || '[]');
  } catch {
    stepResults.push({ error: 'PROBE_STEPS is not valid JSON' });
  }
  for (const [index, step] of steps.entries()) {
    if (step.wait) await sleep(Number(step.wait));
    if (step.click) {
      const [x, y] = step.click;
      await send('Input.dispatchMouseEvent', {
        type: 'mousePressed',
        x,
        y,
        button: 'left',
        clickCount: 1,
      });
      await send('Input.dispatchMouseEvent', {
        type: 'mouseReleased',
        x,
        y,
        button: 'left',
        clickCount: 1,
      });
      stepResults.push({ index, clicked: [x, y] });
    }
    if (typeof step.type === 'string') {
      await send('Input.insertText', { text: step.type });
      stepResults.push({ index, typed: step.type });
    }
    if (step.eval) {
      const outcome = await send('Runtime.evaluate', {
        expression: step.eval,
        returnByValue: true,
        awaitPromise: true,
      });
      stepResults.push({
        index,
        eval: outcome.result?.value ?? outcome.result?.description ?? null,
      });
    }
    if (step.screenshot) {
      const shot = await send('Page.captureScreenshot', { format: 'png' });
      await fs.writeFile(step.screenshot, Buffer.from(shot.data, 'base64'));
      stepResults.push({ index, screenshot: step.screenshot });
    }
    if (step.download) {
      await fs.mkdir(step.download, { recursive: true });
      try {
        await send('Browser.setDownloadBehavior', {
          behavior: 'allow',
          downloadPath: step.download,
        });
      } catch {
        await send('Page.setDownloadBehavior', {
          behavior: 'allow',
          downloadPath: step.download,
        });
      }
      stepResults.push({ index, download: step.download });
    }
    if (step.navigate) {
      await send('Page.navigate', { url: step.navigate });
      stepResults.push({ index, navigate: step.navigate });
    }
    if (step.reload) {
      await send('Page.reload', { ignoreCache: Boolean(step.hardReload) });
      stepResults.push({ index, reload: true, hardReload: Boolean(step.hardReload) });
    }
    if (step.offline !== undefined) {
      await send('Network.emulateNetworkConditions', {
        offline: Boolean(step.offline),
        latency: 0,
        downloadThroughput: step.offline ? 0 : -1,
        uploadThroughput: -1,
      });
      stepResults.push({ index, offline: Boolean(step.offline) });
    }
    if (step.clearCache) {
      await send('Network.clearBrowserCache');
      stepResults.push({ index, clearCache: true });
    }
    if (step.disableCache !== undefined) {
      await send('Network.setCacheDisabled', {
        cacheDisabled: Boolean(step.disableCache),
      });
      stepResults.push({ index, disableCache: Boolean(step.disableCache) });
    }
  }

  const expression = `JSON.stringify({
    title: document.title,
    splashPresent: !!document.getElementById('fish-splash'),
    flutterTags: Array.from(document.querySelectorAll('*'))
      .map((node) => node.tagName.toLowerCase())
      .filter((tag) => tag.startsWith('flt') || tag === 'canvas')
      .slice(0, 12),
    bodyText: (document.body.innerText || '').slice(0, 400),
    manifest: document.querySelector('link[rel=manifest]')?.getAttribute('href') ?? null
  })`;
  const evaluated = await send('Runtime.evaluate', {
    expression,
    returnByValue: true,
  });
  const screenshot = await send('Page.captureScreenshot', { format: 'png' });
  await fs.writeFile(outPng, Buffer.from(screenshot.data, 'base64'));

  const result = {
    url,
    width,
    height,
    waitMs,
    ready,
    loadMs: Date.now() - started,
    page: JSON.parse(evaluated.result.value),
    steps: stepResults,
    consoleLines,
    exceptions,
    failedRequests,
    httpErrors: responses.filter((entry) => entry.status >= 400),
    screenshot: outPng,
  };
  console.log(JSON.stringify(result, null, 2));
  if (exceptions.length > 0 || failedRequests.length > 0) process.exitCode = 1;
} finally {
  socket.close();
  browser.kill();
}
