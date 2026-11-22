(function dartProgram(){function copyProperties(a,b){var s=Object.keys(a)
for(var r=0;r<s.length;r++){var q=s[r]
b[q]=a[q]}}function mixinPropertiesHard(a,b){var s=Object.keys(a)
for(var r=0;r<s.length;r++){var q=s[r]
if(!b.hasOwnProperty(q)){b[q]=a[q]}}}function mixinPropertiesEasy(a,b){Object.assign(b,a)}var z=function(){var s=function(){}
s.prototype={p:{}}
var r=new s()
if(!(Object.getPrototypeOf(r)&&Object.getPrototypeOf(r).p===s.prototype.p))return false
try{if(typeof navigator!="undefined"&&typeof navigator.userAgent=="string"&&navigator.userAgent.indexOf("Chrome/")>=0)return true
if(typeof version=="function"&&version.length==0){var q=version()
if(/^\d+\.\d+\.\d+\.\d+$/.test(q))return true}}catch(p){}return false}()
function inherit(a,b){a.prototype.constructor=a
a.prototype["$i"+a.name]=a
if(b!=null){if(z){Object.setPrototypeOf(a.prototype,b.prototype)
return}var s=Object.create(b.prototype)
copyProperties(a.prototype,s)
a.prototype=s}}function inheritMany(a,b){for(var s=0;s<b.length;s++){inherit(b[s],a)}}function mixinEasy(a,b){mixinPropertiesEasy(b.prototype,a.prototype)
a.prototype.constructor=a}function mixinHard(a,b){mixinPropertiesHard(b.prototype,a.prototype)
a.prototype.constructor=a}function lazy(a,b,c,d){var s=a
a[b]=s
a[c]=function(){if(a[b]===s){a[b]=d()}a[c]=function(){return this[b]}
return a[b]}}function lazyFinal(a,b,c,d){var s=a
a[b]=s
a[c]=function(){if(a[b]===s){var r=d()
if(a[b]!==s){A.vX(b)}a[b]=r}var q=a[b]
a[c]=function(){return q}
return q}}function makeConstList(a,b){if(b!=null)A.i(a,b)
a.$flags=7
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var s=0;s<a.length;++s){convertToFastObject(a[s])}}var y=0
function instanceTearOffGetter(a,b){var s=null
return a?function(c){if(s===null)s=A.n7(b)
return new s(c,this)}:function(){if(s===null)s=A.n7(b)
return new s(this,null)}}function staticTearOffGetter(a){var s=null
return function(){if(s===null)s=A.n7(a).prototype
return s}}var x=0
function tearOffParameters(a,b,c,d,e,f,g,h,i,j){if(typeof h=="number"){h+=x}return{co:a,iS:b,iI:c,rC:d,dV:e,cs:f,fs:g,fT:h,aI:i||0,nDA:j}}function installStaticTearOff(a,b,c,d,e,f,g,h){var s=tearOffParameters(a,true,false,c,d,e,f,g,h,false)
var r=staticTearOffGetter(s)
a[b]=r}function installInstanceTearOff(a,b,c,d,e,f,g,h,i,j){c=!!c
var s=tearOffParameters(a,false,c,d,e,f,g,h,i,!!j)
var r=instanceTearOffGetter(c,s)
a[b]=r}function setOrUpdateInterceptorsByTag(a){var s=v.interceptorsByTag
if(!s){v.interceptorsByTag=a
return}copyProperties(a,s)}function setOrUpdateLeafTags(a){var s=v.leafTags
if(!s){v.leafTags=a
return}copyProperties(a,s)}function updateTypes(a){var s=v.types
var r=s.length
s.push.apply(s,a)
return r}function updateHolder(a,b){copyProperties(b,a)
return a}var hunkHelpers=function(){var s=function(a,b,c,d,e){return function(f,g,h,i){return installInstanceTearOff(f,g,a,b,c,d,[h],i,e,false)}},r=function(a,b,c,d){return function(e,f,g,h){return installStaticTearOff(e,f,a,b,c,[g],h,d)}}
return{inherit:inherit,inheritMany:inheritMany,mixin:mixinEasy,mixinHard:mixinHard,installStaticTearOff:installStaticTearOff,installInstanceTearOff:installInstanceTearOff,_instance_0u:s(0,0,null,["$0"],0),_instance_1u:s(0,1,null,["$1"],0),_instance_2u:s(0,2,null,["$2"],0),_instance_0i:s(1,0,null,["$0"],0),_instance_1i:s(1,1,null,["$1"],0),_instance_2i:s(1,2,null,["$2"],0),_static_0:r(0,null,["$0"],0),_static_1:r(1,null,["$1"],0),_static_2:r(2,null,["$2"],0),makeConstList:makeConstList,lazy:lazy,lazyFinal:lazyFinal,updateHolder:updateHolder,convertToFastObject:convertToFastObject,updateTypes:updateTypes,setOrUpdateInterceptorsByTag:setOrUpdateInterceptorsByTag,setOrUpdateLeafTags:setOrUpdateLeafTags}}()
function initializeDeferredHunk(a){x=v.types.length
a(hunkHelpers,v,w,$)}var J={
nc(a,b,c,d){return{i:a,p:b,e:c,x:d}},
ly(a){var s,r,q,p,o,n="_$dart_js",m=a[v.dispatchPropertyName]
if(m==null)if($.na==null){A.vF()
m=a[v.dispatchPropertyName]}if(m!=null){s=m.p
if(!1===s)return m.i
if(!0===s)return a
r=Object.getPrototypeOf(a)
if(s===r)return m.i
if(m.e===r)throw A.d(A.op("Return interceptor for "+A.r(s(a,m))))}q=a.constructor
if(q==null)p=null
else{o=$.kt
if(o==null)o=$.kt=A.lx(n)
p=q[o]}if(p!=null)return p
p=A.vK(a)
if(p!=null)return p
if(typeof a=="function")return B.bg
s=Object.getPrototypeOf(a)
if(s==null)return B.au
if(s===Object.prototype)return B.au
if(typeof q=="function"){o=$.kt
if(o==null)o=$.kt=A.lx(n)
Object.defineProperty(q,o,{value:B.Z,enumerable:false,writable:true,configurable:true})
return B.Z}return B.Z},
o_(a,b){if(a<0||a>4294967295)throw A.d(A.ac(a,0,4294967295,"length",null))
return J.re(new Array(a),b)},
o0(a,b){if(a<0)throw A.d(A.bd("Length must be a non-negative integer: "+a,null))
return A.i(new Array(a),b.h("u<0>"))},
nZ(a,b){if(a<0)throw A.d(A.bd("Length must be a non-negative integer: "+a,null))
return A.i(new Array(a),b.h("u<0>"))},
re(a,b){var s=A.i(a,b.h("u<0>"))
s.$flags=1
return s},
o1(a,b){var s=t.e8
return J.qy(s.a(a),s.a(b))},
o3(a){if(a<256)switch(a){case 9:case 10:case 11:case 12:case 13:case 32:case 133:case 160:return!0
default:return!1}switch(a){case 5760:case 8192:case 8193:case 8194:case 8195:case 8196:case 8197:case 8198:case 8199:case 8200:case 8201:case 8202:case 8232:case 8233:case 8239:case 8287:case 12288:case 65279:return!0
default:return!1}},
o4(a,b){var s,r
for(s=a.length;b<s;){r=a.charCodeAt(b)
if(r!==32&&r!==13&&!J.o3(r))break;++b}return b},
rg(a,b){var s,r,q
for(s=a.length;b>0;b=r){r=b-1
if(!(r<s))return A.a(a,r)
q=a.charCodeAt(r)
if(q!==32&&q!==13&&!J.o3(q))break}return b},
cv(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.dA.prototype
return J.fj.prototype}if(typeof a=="string")return J.bI.prototype
if(a==null)return J.dB.prototype
if(typeof a=="boolean")return J.dz.prototype
if(Array.isArray(a))return J.u.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bm.prototype
if(typeof a=="symbol")return J.cJ.prototype
if(typeof a=="bigint")return J.cI.prototype
return a}if(a instanceof A.m)return a
return J.ly(a)},
aj(a){if(typeof a=="string")return J.bI.prototype
if(a==null)return a
if(Array.isArray(a))return J.u.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bm.prototype
if(typeof a=="symbol")return J.cJ.prototype
if(typeof a=="bigint")return J.cI.prototype
return a}if(a instanceof A.m)return a
return J.ly(a)},
bb(a){if(a==null)return a
if(Array.isArray(a))return J.u.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bm.prototype
if(typeof a=="symbol")return J.cJ.prototype
if(typeof a=="bigint")return J.cI.prototype
return a}if(a instanceof A.m)return a
return J.ly(a)},
vB(a){if(typeof a=="number")return J.cH.prototype
if(typeof a=="string")return J.bI.prototype
if(a==null)return a
if(!(a instanceof A.m))return J.cc.prototype
return a},
n9(a){if(typeof a=="string")return J.bI.prototype
if(a==null)return a
if(!(a instanceof A.m))return J.cc.prototype
return a},
cw(a){if(a==null)return a
if(typeof a!="object"){if(typeof a=="function")return J.bm.prototype
if(typeof a=="symbol")return J.cJ.prototype
if(typeof a=="bigint")return J.cI.prototype
return a}if(a instanceof A.m)return a
return J.ly(a)},
T(a,b){if(a==null)return b==null
if(typeof a!="object")return b!=null&&a===b
return J.cv(a).aC(a,b)},
bi(a,b){if(typeof b==="number")if(Array.isArray(a)||typeof a=="string"||A.vI(a,a[v.dispatchPropertyName]))if(b>>>0===b&&b<a.length)return a[b]
return J.aj(a).l(a,b)},
qv(a,b,c){return J.bb(a).D(a,b,c)},
hr(a,b){return J.bb(a).m(a,b)},
qw(a,b){return J.n9(a).hl(a,b)},
hs(a){return J.cw(a).hm(a)},
eR(a,b,c){return J.cw(a).cw(a,b,c)},
nE(a,b,c){return J.cw(a).hn(a,b,c)},
qx(a,b,c){return J.cw(a).ho(a,b,c)},
ht(a){return J.cw(a).hp(a)},
ak(a,b,c){return J.cw(a).bs(a,b,c)},
qy(a,b){return J.vB(a).be(a,b)},
nF(a,b){return J.bb(a).au(a,b)},
qz(a){return J.bb(a).gc3(a)},
as(a){return J.cv(a).ga1(a)},
nG(a){return J.aj(a).gY(a)},
m8(a){return J.aj(a).gek(a)},
aO(a){return J.bb(a).gI(a)},
B(a){return J.aj(a).gi(a)},
qA(a){return J.cw(a).ghP(a)},
qB(a){return J.cv(a).gae(a)},
qC(a){return J.bb(a).gij(a)},
qD(a,b){return J.bb(a).bi(a,b)},
qE(a,b,c){return J.bb(a).bC(a,b,c)},
m9(a,b){return J.bb(a).a5(a,b)},
qF(a,b){return J.n9(a).bF(a,b)},
qG(a,b,c){return J.bb(a).aZ(a,b,c)},
qH(a,b){return J.n9(a).eH(a,b)},
qI(a,b){return J.bb(a).cR(a,b)},
aY(a){return J.cv(a).n(a)},
fh:function fh(){},
dz:function dz(){},
dB:function dB(){},
dD:function dD(){},
bJ:function bJ(){},
fv:function fv(){},
cc:function cc(){},
bm:function bm(){},
cI:function cI(){},
cJ:function cJ(){},
u:function u(a){this.$ti=a},
fi:function fi(){},
ip:function ip(a){this.$ti=a},
at:function at(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
cH:function cH(){},
dA:function dA(){},
fj:function fj(){},
bI:function bI(){}},A={mk:function mk(){},
nP(a,b,c){if(t.U.b(a))return new A.ej(a,b.h("@<0>").M(c).h("ej<1,2>"))
return new A.c1(a,b.h("@<0>").M(c).h("c1<1,2>"))},
o7(a){return new A.c5("Field '"+a+"' has been assigned during initialization.")},
iq(a){return new A.c5("Field '"+a+"' has not been initialized.")},
rh(a){return new A.c5("Field '"+a+"' has already been initialized.")},
br(a,b){a=a+b&536870911
a=a+((a&524287)<<10)&536870911
return a^a>>>6},
iO(a){a=a+((a&67108863)<<3)&536870911
a^=a>>>11
return a+((a&16383)<<15)&536870911},
ba(a,b,c){return a},
nb(a){var s,r
for(s=$.aN.length,r=0;r<s;++r)if(a===$.aN[r])return!0
return!1},
aK(a,b,c,d){A.bN(b,"start")
if(c!=null){A.bN(c,"end")
if(b>c)A.j(A.ac(b,0,c,"start",null))}return new A.e0(a,b,c,d.h("e0<0>"))},
oc(a,b,c,d){if(t.U.b(a))return new A.ds(a,b,c.h("@<0>").M(d).h("ds<1,2>"))
return new A.c8(a,b,c.h("@<0>").M(d).h("c8<1,2>"))},
nW(a,b,c){return new A.dr(a,b,c.h("dr<0>"))},
cG(){return new A.bR("No element")},
rc(){return new A.bR("Too many elements")},
ka:function ka(a){this.a=0
this.b=a},
cW:function cW(){},
dl:function dl(a,b){this.a=a
this.$ti=b},
c1:function c1(a,b){this.a=a
this.$ti=b},
ej:function ej(a,b){this.a=a
this.$ti=b},
c2:function c2(a,b){this.a=a
this.$ti=b},
i5:function i5(a,b){this.a=a
this.b=b},
i4:function i4(a){this.a=a},
c5:function c5(a){this.a=a},
f2:function f2(a){this.a=a},
lV:function lV(){},
iG:function iG(){},
n:function n(){},
P:function P(){},
e0:function e0(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
au:function au(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
c8:function c8(a,b,c){this.a=a
this.b=b
this.$ti=c},
ds:function ds(a,b,c){this.a=a
this.b=b
this.$ti=c},
dL:function dL(a,b,c){var _=this
_.a=null
_.b=a
_.c=b
_.$ti=c},
av:function av(a,b,c){this.a=a
this.b=b
this.$ti=c},
aT:function aT(a,b,c){this.a=a
this.b=b
this.$ti=c},
e4:function e4(a,b,c){this.a=a
this.b=b
this.$ti=c},
dt:function dt(a){this.$ti=a},
du:function du(a){this.$ti=a},
dy:function dy(a,b,c){this.a=a
this.b=b
this.$ti=c},
dr:function dr(a,b,c){this.a=a
this.b=b
this.$ti=c},
bl:function bl(a,b,c){var _=this
_.a=a
_.b=b
_.c=-1
_.$ti=c},
R:function R(){},
b3:function b3(){},
cP:function cP(){},
b0:function b0(a,b){this.a=a
this.$ti=b},
qZ(){throw A.d(A.ao("Cannot modify constant Set"))},
pM(a){var s=A.pL(a)
if(s!=null)return s
return"minified:"+a},
vI(a,b){var s
if(b!=null){s=b.x
if(s!=null)return s}return t.aU.b(a)},
r(a){var s
if(typeof a=="string")return a
if(typeof a=="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
s=J.aY(a)
return s},
dV(a){var s,r=$.of
if(r==null)r=$.of=Symbol("identityHashCode")
s=a[r]
if(s==null){s=Math.random()*0x3fffffff|0
a[r]=s}return s},
oh(a,b){var s,r=/^\s*[+-]?((0x[a-f0-9]+)|(\d+)|([a-z0-9]+))\s*$/i.exec(a)
if(r==null)return null
if(3>=r.length)return A.a(r,3)
s=r[3]
if(s!=null)return parseInt(a,10)
if(r[2]!=null)return parseInt(a,16)
return null},
fw(a){var s,r,q,p
if(a instanceof A.m)return A.aL(A.ar(a),null)
s=J.cv(a)
if(s===B.be||s===B.bh||t.ak.b(a)){r=B.a5(a)
if(r!=="Object"&&r!=="")return r
q=a.constructor
if(typeof q=="function"){p=q.name
if(typeof p=="string"&&p!=="Object"&&p!=="")return p}}return A.aL(A.ar(a),null)},
oi(a){var s,r,q
if(a==null||typeof a=="number"||A.mW(a))return J.aY(a)
if(typeof a=="string")return JSON.stringify(a)
if(a instanceof A.bD)return a.n(0)
if(a instanceof A.b7)return a.h7(!0)
s=$.qn()
for(r=0;r<1;++r){q=s[r].m3(a)
if(q!=null)return q}return"Instance of '"+A.fw(a)+"'"},
oe(a){var s,r,q,p,o=a.length
if(o<=500)return String.fromCharCode.apply(null,a)
for(s="",r=0;r<o;r=q){q=r+500
p=q<o?q:o
s+=String.fromCharCode.apply(null,a.slice(r,p))}return s},
rr(a){var s,r,q,p=A.i([],t.t)
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.O)(a),++r){q=a[r]
if(!A.kZ(q))throw A.d(A.bY(q))
if(q<=65535)B.b.m(p,q)
else if(q<=1114111){B.b.m(p,55296+(B.a.k(q-65536,10)&1023))
B.b.m(p,56320+(q&1023))}else throw A.d(A.bY(q))}return A.oe(p)},
oj(a){var s,r,q
for(s=a.length,r=0;r<s;++r){q=a[r]
if(!A.kZ(q))throw A.d(A.bY(q))
if(q<0)throw A.d(A.bY(q))
if(q>65535)return A.rr(a)}return A.oe(a)},
rs(a,b,c){var s,r,q,p
if(c<=500&&b===0&&c===a.length)return String.fromCharCode.apply(null,a)
for(s=b,r="";s<c;s=q){q=s+500
p=q<c?q:c
r+=String.fromCharCode.apply(null,a.subarray(s,p))}return r},
X(a){var s
if(a<=65535)return String.fromCharCode(a)
if(a<=1114111){s=a-65536
return String.fromCharCode((B.a.k(s,10)|55296)>>>0,s&1023|56320)}throw A.d(A.ac(a,0,1114111,null,null))},
mu(a,b,c,d,e,f,g,h,i){var s,r,q,p=b-1
if(0<=a&&a<100){a+=400
p-=4800}s=B.a.E(h,1000)
g+=B.a.t(h-s,1000)
r=i?Date.UTC(a,p,c,d,e,f,g):new Date(a,p,c,d,e,f,g).valueOf()
q=!0
if(!isNaN(r))if(!(r<-864e13))if(!(r>864e13))q=r===864e13&&s!==0
if(q)return null
return r},
aJ(a){if(a.date===void 0)a.date=new Date(a.a)
return a.date},
ca(a){return a.c?A.aJ(a).getUTCFullYear()+0:A.aJ(a).getFullYear()+0},
iD(a){return a.c?A.aJ(a).getUTCMonth()+1:A.aJ(a).getMonth()+1},
mq(a){return a.c?A.aJ(a).getUTCDate()+0:A.aJ(a).getDate()+0},
mr(a){return a.c?A.aJ(a).getUTCHours()+0:A.aJ(a).getHours()+0},
iC(a){return a.c?A.aJ(a).getUTCMinutes()+0:A.aJ(a).getMinutes()+0},
ms(a){return a.c?A.aJ(a).getUTCSeconds()+0:A.aJ(a).getSeconds()+0},
og(a){return a.c?A.aJ(a).getUTCMilliseconds()+0:A.aJ(a).getMilliseconds()+0},
rq(a){var s=a.$thrownJsError
if(s==null)return null
return A.aq(s)},
mt(a,b){var s
if(a.$thrownJsError==null){s=new Error()
A.a5(a,s)
a.$thrownJsError=s
s.stack=b.n(0)}},
Z(a){throw A.d(A.bY(a))},
a(a,b){if(a==null)J.B(a)
throw A.d(A.lu(a,b))},
lu(a,b){var s,r="index"
if(!A.kZ(b))return new A.aQ(!0,b,r,null)
s=A.H(J.B(a))
if(b<0||b>=s)return A.mi(b,s,a,r)
return A.rv(b,r)},
vw(a,b,c){if(a<0||a>c)return A.ac(a,0,c,"start",null)
if(b!=null)if(b<a||b>c)return A.ac(b,a,c,"end",null)
return new A.aQ(!0,b,"end",null)},
bY(a){return new A.aQ(!0,a,null,null)},
d(a){return A.a5(a,new Error())},
a5(a,b){var s
if(a==null)a=new A.bs()
b.dartException=a
s=A.vY
if("defineProperty" in Object){Object.defineProperty(b,"message",{get:s})
b.name=""}else b.toString=s
return b},
vY(){return J.aY(this.dartException)},
j(a,b){throw A.a5(a,b==null?new Error():b)},
b(a,b,c){var s
if(b==null)b=0
if(c==null)c=0
s=Error()
A.j(A.tN(a,b,c),s)},
tN(a,b,c){var s,r,q,p,o,n,m,l,k
if(typeof b=="string")s=b
else{r="[]=;add;removeWhere;retainWhere;removeRange;setRange;setInt8;setInt16;setInt32;setUint8;setUint16;setUint32;setFloat32;setFloat64".split(";")
q=r.length
p=b
if(p>q){c=p/q|0
p%=q}s=r[p]}o=typeof c=="string"?c:"modify;remove from;add to".split(";")[c]
n=t.j.b(a)?"list":"ByteData"
m=a.$flags|0
l="a "
if((m&4)!==0)k="constant "
else if((m&2)!==0){k="unmodifiable "
l="an "}else k=(m&1)!==0?"fixed-length ":""
return new A.e3("'"+s+"': Cannot "+o+" "+l+k+n)},
O(a){throw A.d(A.ax(a))},
bt(a){var s,r,q,p,o,n
a=A.pI(a.replace(String({}),"$receiver$"))
s=a.match(/\\\$[a-zA-Z]+\\\$/g)
if(s==null)s=A.i([],t.s)
r=s.indexOf("\\$arguments\\$")
q=s.indexOf("\\$argumentsExpr\\$")
p=s.indexOf("\\$expr\\$")
o=s.indexOf("\\$method\\$")
n=s.indexOf("\\$receiver\\$")
return new A.iP(a.replace(new RegExp("\\\\\\$arguments\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$argumentsExpr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$expr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$method\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$receiver\\\\\\$","g"),"((?:x|[^x])*)"),r,q,p,o,n)},
iQ(a){return function($expr$){var $argumentsExpr$="$arguments$"
try{$expr$.$method$($argumentsExpr$)}catch(s){return s.message}}(a)},
oo(a){return function($expr$){try{$expr$.$method$}catch(s){return s.message}}(a)},
ml(a,b){var s=b==null,r=s?null:b.method
return new A.fk(a,r,s?null:b.receiver)},
G(a){var s
if(a==null)return new A.iz(a)
if(a instanceof A.dv){s=a.a
return A.bZ(a,s==null?A.b8(s):s)}if(typeof a!=="object")return a
if("dartException" in a)return A.bZ(a,a.dartException)
return A.v8(a)},
bZ(a,b){if(t.C.b(b))if(b.$thrownJsError==null)b.$thrownJsError=a
return b},
v8(a){var s,r,q,p,o,n,m,l,k,j,i,h,g
if(!("message" in a))return a
s=a.message
if("number" in a&&typeof a.number=="number"){r=a.number
q=r&65535
if((B.a.k(r,16)&8191)===10)switch(q){case 438:return A.bZ(a,A.ml(A.r(s)+" (Error "+q+")",null))
case 445:case 5007:A.r(s)
return A.bZ(a,new A.dT())}}if(a instanceof TypeError){p=$.q2()
o=$.q3()
n=$.q4()
m=$.q5()
l=$.q8()
k=$.q9()
j=$.q7()
$.q6()
i=$.qb()
h=$.qa()
g=p.aP(s)
if(g!=null)return A.bZ(a,A.ml(A.a9(s),g))
else{g=o.aP(s)
if(g!=null){g.method="call"
return A.bZ(a,A.ml(A.a9(s),g))}else if(n.aP(s)!=null||m.aP(s)!=null||l.aP(s)!=null||k.aP(s)!=null||j.aP(s)!=null||m.aP(s)!=null||i.aP(s)!=null||h.aP(s)!=null){A.a9(s)
return A.bZ(a,new A.dT())}}return A.bZ(a,new A.fD(typeof s=="string"?s:""))}if(a instanceof RangeError){if(typeof s=="string"&&s.indexOf("call stack")!==-1)return new A.dY()
s=function(b){try{return String(b)}catch(f){}return null}(a)
return A.bZ(a,new A.aQ(!1,null,null,typeof s=="string"?s.replace(/^RangeError:\s*/,""):s))}if(typeof InternalError=="function"&&a instanceof InternalError)if(typeof s=="string"&&s==="too much recursion")return new A.dY()
return a},
aq(a){var s
if(a instanceof A.dv)return a.b
if(a==null)return new A.ex(a)
s=a.$cachedTrace
if(s!=null)return s
s=new A.ex(a)
if(typeof a==="object")a.$cachedTrace=s
return s},
nd(a){if(a==null)return J.as(a)
if(typeof a=="object")return A.dV(a)
return J.as(a)},
vq(a){if(typeof a=="number")return B.w.ga1(a)
if(a instanceof A.hd)return A.dV(a)
if(a instanceof A.b7)return a.ga1(a)
return A.nd(a)},
pz(a,b){var s,r,q,p=a.length
for(s=0;s<p;s=q){r=s+1
q=r+1
b.D(0,a[s],a[r])}return b},
u2(a,b,c,d,e,f){t.Y.a(a)
switch(A.H(b)){case 0:return a.$0()
case 1:return a.$1(c)
case 2:return a.$2(c,d)
case 3:return a.$3(c,d,e)
case 4:return a.$4(c,d,e,f)}throw A.d(new A.kg("Unsupported number of arguments for wrapped closure"))},
d7(a,b){var s=a.$identity
if(!!s)return s
s=A.vr(a,b)
a.$identity=s
return s},
vr(a,b){var s
switch(b){case 0:s=a.$0
break
case 1:s=a.$1
break
case 2:s=a.$2
break
case 3:s=a.$3
break
case 4:s=a.$4
break
default:s=null}if(s!=null)return s.bind(a)
return function(c,d,e){return function(f,g,h,i){return e(c,d,f,g,h,i)}}(a,b,A.u2)},
qY(a2){var s,r,q,p,o,n,m,l,k,j,i=a2.co,h=a2.iS,g=a2.iI,f=a2.nDA,e=a2.aI,d=a2.fs,c=a2.cs,b=d[0],a=c[0],a0=i[b],a1=a2.fT
a1.toString
s=h?Object.create(new A.fz().constructor.prototype):Object.create(new A.cA(null,null).constructor.prototype)
s.$initialize=s.constructor
r=h?function static_tear_off(){this.$initialize()}:function tear_off(a3,a4){this.$initialize(a3,a4)}
s.constructor=r
r.prototype=s
s.$_name=b
s.$_target=a0
q=!h
if(q)p=A.nQ(b,a0,g,f)
else{s.$static_name=b
p=a0}s.$S=A.qU(a1,h,g)
s[a]=p
for(o=p,n=1;n<d.length;++n){m=d[n]
if(typeof m=="string"){l=i[m]
k=m
m=l}else k=""
j=c[n]
if(j!=null){if(q)m=A.nQ(k,m,g,f)
s[j]=m}if(n===e)o=m}s.$C=o
s.$R=a2.rC
s.$D=a2.dV
return r},
qU(a,b,c){if(typeof a=="number")return a
if(typeof a=="string"){if(b)throw A.d("Cannot compute signature for static tearoff.")
return function(d,e){return function(){return e(this,d)}}(a,A.qO)}throw A.d("Error in functionType of tearoff")},
qV(a,b,c,d){var s=A.nO
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,s)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,s)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,s)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,s)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,s)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,s)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,s)}},
nQ(a,b,c,d){if(c)return A.qX(a,b,d)
return A.qV(b.length,d,a,b)},
qW(a,b,c,d){var s=A.nO,r=A.qP
switch(b?-1:a){case 0:throw A.d(new A.fy("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,r,s)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,r,s)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,r,s)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,r,s)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,r,s)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,r,s)
default:return function(e,f,g){return function(){var q=[g(this)]
Array.prototype.push.apply(q,arguments)
return e.apply(f(this),q)}}(d,r,s)}},
qX(a,b,c){var s,r
if($.nM==null)$.nM=A.nL("interceptor")
if($.nN==null)$.nN=A.nL("receiver")
s=b.length
r=A.qW(s,c,a,b)
return r},
n7(a){return A.qY(a)},
qO(a,b){return A.eD(v.typeUniverse,A.ar(a.a),b)},
nO(a){return a.a},
qP(a){return a.b},
nL(a){var s,r,q,p=new A.cA("receiver","interceptor"),o=Object.getOwnPropertyNames(p)
o.$flags=1
s=o
for(o=s.length,r=0;r<o;++r){q=s[r]
if(p[q]===a)return q}throw A.d(A.bd("Field name "+a+" not found.",null))},
lx(a){return v.getIsolateTag(a)},
pK(){return v.G},
x3(a,b,c){Object.defineProperty(a,b,{value:c,enumerable:false,writable:true,configurable:true})},
vK(a){var s,r,q,p,o,n=A.a9($.pC.$1(a)),m=$.lv[n]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.lE[n]
if(s!=null)return s
r=v.interceptorsByTag[n]
if(r==null){q=A.mQ($.pu.$2(a,n))
if(q!=null){m=$.lv[q]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.lE[q]
if(s!=null)return s
r=v.interceptorsByTag[q]
n=q}}if(r==null)return null
s=r.prototype
p=n[0]
if(p==="!"){m=A.lU(s)
$.lv[n]=m
Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}if(p==="~"){$.lE[n]=s
return s}if(p==="-"){o=A.lU(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}if(p==="+")return A.pF(a,s)
if(p==="*")throw A.d(A.op(n))
if(v.leafTags[n]===true){o=A.lU(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}else return A.pF(a,s)},
pF(a,b){var s=Object.getPrototypeOf(a)
Object.defineProperty(s,v.dispatchPropertyName,{value:J.nc(b,s,null,null),enumerable:false,writable:true,configurable:true})
return b},
lU(a){return J.nc(a,!1,null,!!a.$iaG)},
vM(a,b,c){var s=b.prototype
if(v.leafTags[a]===true)return A.lU(s)
else return J.nc(s,c,null,null)},
vF(){if(!0===$.na)return
$.na=!0
A.vG()},
vG(){var s,r,q,p,o,n,m,l
$.lv=Object.create(null)
$.lE=Object.create(null)
A.vE()
s=v.interceptorsByTag
r=Object.getOwnPropertyNames(s)
if(typeof window!="undefined"){window
q=function(){}
for(p=0;p<r.length;++p){o=r[p]
n=$.pH.$1(o)
if(n!=null){m=A.vM(o,s[o],n)
if(m!=null){Object.defineProperty(n,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
q.prototype=n}}}}for(p=0;p<r.length;++p){o=r[p]
if(/^[A-Za-z_]/.test(o)){l=s[o]
s["!"+o]=l
s["~"+o]=l
s["-"+o]=l
s["+"+o]=l
s["*"+o]=l}}},
vE(){var s,r,q,p,o,n,m=B.aH()
m=A.d6(B.aI,A.d6(B.aJ,A.d6(B.a4,A.d6(B.a4,A.d6(B.aK,A.d6(B.aL,A.d6(B.aM(B.a5),m)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){s=dartNativeDispatchHooksTransformer
if(typeof s=="function")s=[s]
if(Array.isArray(s))for(r=0;r<s.length;++r){q=s[r]
if(typeof q=="function")m=q(m)||m}}p=m.getTag
o=m.getUnknownTag
n=m.prototypeForTag
$.pC=new A.lB(p)
$.pu=new A.lC(o)
$.pH=new A.lD(n)},
d6(a,b){return a(b)||b},
vu(a,b){var s=b.length,r=v.rttc[""+s+";"+a]
if(r==null)return null
if(s===0)return r
if(s===r.length)return r.apply(null,b)
return r(b)},
o5(a,b,c,d,e,f){var s=b?"m":"",r=c?"":"i",q=d?"u":"",p=e?"s":"",o=function(g,h){try{return new RegExp(g,h)}catch(n){return n}}(a,s+r+q+p+f)
if(o instanceof RegExp)return o
throw A.d(A.dx("Illegal RegExp pattern ("+String(o)+")",a,null))},
vR(a,b,c){var s=a.indexOf(b,c)
return s>=0},
n8(a){if(a.indexOf("$",0)>=0)return a.replace(/\$/g,"$$$$")
return a},
vU(a,b,c,d){var s=b.fk(a,d)
if(s==null)return a
return A.vW(a,s.b.index,s.gcD(),c)},
pI(a){if(/[[\]{}()*+?.\\^$|]/.test(a))return a.replace(/[[\]{}()*+?.\\^$|]/g,"\\$&")
return a},
bB(a,b,c){var s
if(typeof b=="string")return A.vT(a,b,c)
if(b instanceof A.dC){s=b.gfI()
s.lastIndex=0
return a.replace(s,A.n8(c))}return A.vS(a,b,c)},
vS(a,b,c){var s,r,q,p
for(s=J.qw(b,a),s=s.gI(s),r=0,q="";s.u();){p=s.gC()
q=q+a.substring(r,p.geG())+c
r=p.gcD()}s=q+a.substring(r)
return s.charCodeAt(0)==0?s:s},
vT(a,b,c){var s,r,q
if(b===""){if(a==="")return c
s=a.length
for(r=c,q=0;q<s;++q)r=r+a[q]+c
return r.charCodeAt(0)==0?r:r}if(a.indexOf(b,0)<0)return a
if(a.length<500||c.indexOf("$",0)>=0)return a.split(b).join(c)
return a.replace(new RegExp(A.pI(b),"g"),A.n8(c))},
vV(a,b,c,d){return d===0?a.replace(b.b,A.n8(c)):A.vU(a,b,c,d)},
vW(a,b,c,d){return a.substring(0,b)+d+a.substring(c)},
cn:function cn(a,b){this.a=a
this.b=b},
bw:function bw(a,b){this.a=a
this.b=b},
d_:function d_(a,b,c){this.a=a
this.b=b
this.c=c},
cB:function cB(){},
dn:function dn(a,b,c){this.a=a
this.b=b
this.$ti=c},
cj:function cj(a,b){this.a=a
this.$ti=b},
ck:function ck(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
c4:function c4(a,b){this.a=a
this.$ti=b},
dm:function dm(){},
cC:function cC(a,b,c){this.a=a
this.b=b
this.$ti=c},
dX:function dX(){},
iP:function iP(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
dT:function dT(){},
fk:function fk(a,b,c){this.a=a
this.b=b
this.c=c},
fD:function fD(a){this.a=a},
iz:function iz(a){this.a=a},
dv:function dv(a,b){this.a=a
this.b=b},
ex:function ex(a){this.a=a
this.b=null},
bD:function bD(){},
f0:function f0(){},
f1:function f1(){},
fB:function fB(){},
fz:function fz(){},
cA:function cA(a,b){this.a=a
this.b=b},
fy:function fy(a){this.a=a},
bn:function bn(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
ir:function ir(a,b){var _=this
_.a=a
_.b=b
_.d=_.c=null},
bo:function bo(a,b){this.a=a
this.$ti=b},
dI:function dI(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
bp:function bp(a,b){this.a=a
this.$ti=b},
dJ:function dJ(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
c6:function c6(a,b){this.a=a
this.$ti=b},
dH:function dH(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
dE:function dE(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
lB:function lB(a){this.a=a},
lC:function lC(a){this.a=a},
lD:function lD(a){this.a=a},
b7:function b7(){},
cm:function cm(){},
cZ:function cZ(){},
dC:function dC(a,b){var _=this
_.a=a
_.b=b
_.e=_.d=_.c=null},
eo:function eo(a){this.b=a},
fN:function fN(a,b,c){this.a=a
this.b=b
this.c=c},
fO:function fO(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=null},
fA:function fA(a,b){this.a=a
this.c=b},
ha:function ha(a,b,c){this.a=a
this.b=b
this.c=c},
hb:function hb(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=null},
vX(a){throw A.a5(A.o7(a),new Error())},
c(){throw A.a5(A.iq(""),new Error())},
da(){throw A.a5(A.rh(""),new Error())},
bC(){throw A.a5(A.o7(""),new Error())},
mH(){var s=new A.kb()
return s.b=s},
kb:function kb(){this.b=null},
cq(a,b,c){},
N(a){var s,r,q
if(t.aP.b(a))return a
s=J.aj(a)
r=A.b_(s.gi(a),null,!1,t.z)
for(q=0;q<s.gi(a);++q)B.b.D(r,q,s.l(a,q))
return r},
rj(a){return new DataView(new ArrayBuffer(a))},
rk(a,b,c){A.cq(a,b,c)
return c==null?new DataView(a,b):new DataView(a,b,c)},
mo(a){return new Int16Array(A.N(a))},
rl(a){return new Int32Array(a)},
dQ(a){return new Uint16Array(A.N(a))},
rm(a,b,c){A.cq(a,b,c)
c=B.a.t(a.byteLength-b,2)
return new Uint16Array(a,b,c)},
rn(a){return new Uint32Array(a)},
ix(a){return new Uint32Array(A.N(a))},
ro(a,b,c){A.cq(a,b,c)
if(c==null)c=B.a.t(a.byteLength-b,4)
return new Uint32Array(a,b,c)},
mp(a){return new Uint8Array(a)},
bf(a){return new Uint8Array(A.N(a))},
od(a,b,c){A.cq(a,b,c)
return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
bz(a,b,c){if(a>>>0!==a||a>=c)throw A.d(A.lu(b,a))},
d3(a,b,c){var s
if(!(a>>>0!==a))if(b==null)s=a>c
else s=b>>>0!==b||a>b||b>c
else s=!0
if(s)throw A.d(A.vw(a,b,c))
if(b==null)return c
return b},
bK:function bK(){},
cL:function cL(){},
dO:function dO(){},
hf:function hf(a){this.a=a},
dM:function dM(){},
ad:function ad(){},
bL:function bL(){},
aH:function aH(){},
fq:function fq(){},
fr:function fr(){},
fs:function fs(){},
dN:function dN(){},
ft:function ft(){},
dP:function dP(){},
dR:function dR(){},
dS:function dS(){},
c9:function c9(){},
er:function er(){},
es:function es(){},
et:function et(){},
eu:function eu(){},
mv(a,b){var s=b.c
return s==null?b.c=A.eB(a,"am",[b.x]):s},
ok(a){var s=a.w
if(s===6||s===7)return A.ok(a.x)
return s===11||s===12},
rx(a){return a.as},
aW(a){return A.kH(v.typeUniverse,a,!1)},
cs(a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=a2.w
switch(a0){case 5:case 1:case 2:case 3:case 4:return a2
case 6:s=a2.x
r=A.cs(a1,s,a3,a4)
if(r===s)return a2
return A.oM(a1,r,!0)
case 7:s=a2.x
r=A.cs(a1,s,a3,a4)
if(r===s)return a2
return A.oL(a1,r,!0)
case 8:q=a2.y
p=A.d5(a1,q,a3,a4)
if(p===q)return a2
return A.eB(a1,a2.x,p)
case 9:o=a2.x
n=A.cs(a1,o,a3,a4)
m=a2.y
l=A.d5(a1,m,a3,a4)
if(n===o&&l===m)return a2
return A.mM(a1,n,l)
case 10:k=a2.x
j=a2.y
i=A.d5(a1,j,a3,a4)
if(i===j)return a2
return A.oN(a1,k,i)
case 11:h=a2.x
g=A.cs(a1,h,a3,a4)
f=a2.y
e=A.uZ(a1,f,a3,a4)
if(g===h&&e===f)return a2
return A.oK(a1,g,e)
case 12:d=a2.y
a4+=d.length
c=A.d5(a1,d,a3,a4)
o=a2.x
n=A.cs(a1,o,a3,a4)
if(c===d&&n===o)return a2
return A.mN(a1,n,c,!0)
case 13:b=a2.x
if(b<a4)return a2
a=a3[b-a4]
if(a==null)return a2
return a
default:throw A.d(A.eV("Attempted to substitute unexpected RTI kind "+a0))}},
d5(a,b,c,d){var s,r,q,p,o=b.length,n=A.kL(o)
for(s=!1,r=0;r<o;++r){q=b[r]
p=A.cs(a,q,c,d)
if(p!==q)s=!0
n[r]=p}return s?n:b},
v_(a,b,c,d){var s,r,q,p,o,n,m=b.length,l=A.kL(m)
for(s=!1,r=0;r<m;r+=3){q=b[r]
p=b[r+1]
o=b[r+2]
n=A.cs(a,o,c,d)
if(n!==o)s=!0
l.splice(r,3,q,p,n)}return s?l:b},
uZ(a,b,c,d){var s,r=b.a,q=A.d5(a,r,c,d),p=b.b,o=A.d5(a,p,c,d),n=b.c,m=A.v_(a,n,c,d)
if(q===r&&o===p&&m===n)return b
s=new A.h_()
s.a=q
s.b=o
s.c=m
return s},
i(a,b){a[v.arrayRti]=b
return a},
px(a){var s=a.$S
if(s!=null){if(typeof s=="number")return A.vC(s)
return a.$S()}return null},
vH(a,b){var s
if(A.ok(b))if(a instanceof A.bD){s=A.px(a)
if(s!=null)return s}return A.ar(a)},
ar(a){if(a instanceof A.m)return A.y(a)
if(Array.isArray(a))return A.F(a)
return A.mV(J.cv(a))},
F(a){var s=a[v.arrayRti],r=t.o
if(s==null)return r
if(s.constructor!==r.constructor)return r
return s},
y(a){var s=a.$ti
return s!=null?s:A.mV(a)},
mV(a){var s=a.constructor,r=s.$ccache
if(r!=null)return r
return A.u0(a,s)},
u0(a,b){var s=a instanceof A.bD?Object.getPrototypeOf(Object.getPrototypeOf(a)).constructor:b,r=A.tm(v.typeUniverse,s.name)
b.$ccache=r
return r},
vC(a){var s,r=v.types,q=r[a]
if(typeof q=="string"){s=A.kH(v.typeUniverse,q,!1)
r[a]=s
return s}return q},
lz(a){return A.cu(A.y(a))},
n5(a){var s
if(a instanceof A.b7)return A.vx(a.$r,a.dz())
s=a instanceof A.bD?A.px(a):null
if(s!=null)return s
if(t.dm.b(a))return J.qB(a).a
if(Array.isArray(a))return A.F(a)
return A.ar(a)},
cu(a){var s=a.r
return s==null?a.r=new A.hd(a):s},
vx(a,b){var s,r,q=b,p=q.length
if(p===0)return t.bQ
if(0>=p)return A.a(q,0)
s=A.eD(v.typeUniverse,A.n5(q[0]),"@<0>")
for(r=1;r<p;++r){if(!(r<q.length))return A.a(q,r)
s=A.oP(v.typeUniverse,s,A.n5(q[r]))}return A.eD(v.typeUniverse,s,a)},
aX(a){return A.cu(A.kH(v.typeUniverse,a,!1))},
u_(a){var s=this
s.b=A.uT(s)
return s.b(a)},
uT(a){var s,r,q,p,o
if(a===t.K)return A.u8
if(A.cx(a))return A.uc
s=a.w
if(s===6)return A.tY
if(s===1)return A.pd
if(s===7)return A.u3
r=A.uS(a)
if(r!=null)return r
if(s===8){q=a.x
if(a.y.every(A.cx)){a.f="$i"+q
if(q==="k")return A.u6
if(a===t.m)return A.u5
return A.ub}}else if(s===10){p=A.vu(a.x,a.y)
o=p==null?A.pd:p
return o==null?A.b8(o):o}return A.tW},
uS(a){if(a.w===8){if(a===t.S)return A.kZ
if(a===t.i||a===t.q)return A.u7
if(a===t.N)return A.ua
if(a===t.y)return A.mW}return null},
tZ(a){var s=this,r=A.tV
if(A.cx(s))r=A.tv
else if(s===t.K)r=A.b8
else if(A.d9(s)){r=A.tX
if(s===t.h6)r=A.oU
else if(s===t.dk)r=A.mQ
else if(s===t.fQ)r=A.tt
else if(s===t.cg)r=A.oW
else if(s===t.cD)r=A.tu
else if(s===t.an)r=A.v}else if(s===t.S)r=A.H
else if(s===t.N)r=A.a9
else if(s===t.y)r=A.d2
else if(s===t.q)r=A.oV
else if(s===t.i)r=A.oT
else if(s===t.m)r=A.f
s.a=r
return s.a(a)},
tW(a){var s=this
if(a==null)return A.d9(s)
return A.vJ(v.typeUniverse,A.vH(a,s),s)},
tY(a){if(a==null)return!0
return this.x.b(a)},
ub(a){var s,r=this
if(a==null)return A.d9(r)
s=r.f
if(a instanceof A.m)return!!a[s]
return!!J.cv(a)[s]},
u6(a){var s,r=this
if(a==null)return A.d9(r)
if(typeof a!="object")return!1
if(Array.isArray(a))return!0
s=r.f
if(a instanceof A.m)return!!a[s]
return!!J.cv(a)[s]},
u5(a){var s=this
if(a==null)return!1
if(typeof a=="object"){if(a instanceof A.m)return!!a[s.f]
return!0}if(typeof a=="function")return!0
return!1},
pc(a){if(typeof a=="object"){if(a instanceof A.m)return t.m.b(a)
return!0}if(typeof a=="function")return!0
return!1},
tV(a){var s=this
if(a==null){if(A.d9(s))return a}else if(s.b(a))return a
throw A.a5(A.p2(a,s),new Error())},
tX(a){var s=this
if(a==null||s.b(a))return a
throw A.a5(A.p2(a,s),new Error())},
p2(a,b){return new A.ez("TypeError: "+A.oD(a,A.aL(b,null)))},
oD(a,b){return A.fb(a)+": type '"+A.aL(A.n5(a),null)+"' is not a subtype of type '"+b+"'"},
aV(a,b){return new A.ez("TypeError: "+A.oD(a,b))},
u3(a){var s=this
return s.x.b(a)||A.mv(v.typeUniverse,s).b(a)},
u8(a){return a!=null},
b8(a){if(a!=null)return a
throw A.a5(A.aV(a,"Object"),new Error())},
uc(a){return!0},
tv(a){return a},
pd(a){return!1},
mW(a){return!0===a||!1===a},
d2(a){if(!0===a)return!0
if(!1===a)return!1
throw A.a5(A.aV(a,"bool"),new Error())},
tt(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.a5(A.aV(a,"bool?"),new Error())},
oT(a){if(typeof a=="number")return a
throw A.a5(A.aV(a,"double"),new Error())},
tu(a){if(typeof a=="number")return a
if(a==null)return a
throw A.a5(A.aV(a,"double?"),new Error())},
kZ(a){return typeof a=="number"&&Math.floor(a)===a},
H(a){if(typeof a=="number"&&Math.floor(a)===a)return a
throw A.a5(A.aV(a,"int"),new Error())},
oU(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.a5(A.aV(a,"int?"),new Error())},
u7(a){return typeof a=="number"},
oV(a){if(typeof a=="number")return a
throw A.a5(A.aV(a,"num"),new Error())},
oW(a){if(typeof a=="number")return a
if(a==null)return a
throw A.a5(A.aV(a,"num?"),new Error())},
ua(a){return typeof a=="string"},
a9(a){if(typeof a=="string")return a
throw A.a5(A.aV(a,"String"),new Error())},
mQ(a){if(typeof a=="string")return a
if(a==null)return a
throw A.a5(A.aV(a,"String?"),new Error())},
f(a){if(A.pc(a))return a
throw A.a5(A.aV(a,"JSObject"),new Error())},
v(a){if(a==null)return a
if(A.pc(a))return a
throw A.a5(A.aV(a,"JSObject?"),new Error())},
pl(a,b){var s,r,q
for(s="",r="",q=0;q<a.length;++q,r=", ")s+=r+A.aL(a[q],b)
return s},
uB(a,b){var s,r,q,p,o,n,m=a.x,l=a.y
if(""===m)return"("+A.pl(l,b)+")"
s=l.length
r=m.split(",")
q=r.length-s
for(p="(",o="",n=0;n<s;++n,o=", "){p+=o
if(q===0)p+="{"
p+=A.aL(l[n],b)
if(q>=0)p+=" "+r[q];++q}return p+"})"},
p6(a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=", ",a2=null
if(a5!=null){s=a5.length
if(a4==null)a4=A.i([],t.s)
else a2=a4.length
r=a4.length
for(q=s;q>0;--q)B.b.m(a4,"T"+(r+q))
for(p=t.X,o="<",n="",q=0;q<s;++q,n=a1){m=a4.length
l=m-1-q
if(!(l>=0))return A.a(a4,l)
o=o+n+a4[l]
k=a5[q]
j=k.w
if(!(j===2||j===3||j===4||j===5||k===p))o+=" extends "+A.aL(k,a4)}o+=">"}else o=""
p=a3.x
i=a3.y
h=i.a
g=h.length
f=i.b
e=f.length
d=i.c
c=d.length
b=A.aL(p,a4)
for(a="",a0="",q=0;q<g;++q,a0=a1)a+=a0+A.aL(h[q],a4)
if(e>0){a+=a0+"["
for(a0="",q=0;q<e;++q,a0=a1)a+=a0+A.aL(f[q],a4)
a+="]"}if(c>0){a+=a0+"{"
for(a0="",q=0;q<c;q+=3,a0=a1){a+=a0
if(d[q+1])a+="required "
a+=A.aL(d[q+2],a4)+" "+d[q]}a+="}"}if(a2!=null){a4.toString
a4.length=a2}return o+"("+a+") => "+b},
aL(a,b){var s,r,q,p,o,n,m,l=a.w
if(l===5)return"erased"
if(l===2)return"dynamic"
if(l===3)return"void"
if(l===1)return"Never"
if(l===4)return"any"
if(l===6){s=a.x
r=A.aL(s,b)
q=s.w
return(q===11||q===12?"("+r+")":r)+"?"}if(l===7)return"FutureOr<"+A.aL(a.x,b)+">"
if(l===8){p=A.v7(a.x)
o=a.y
return o.length>0?p+("<"+A.pl(o,b)+">"):p}if(l===10)return A.uB(a,b)
if(l===11)return A.p6(a,b,null)
if(l===12)return A.p6(a.x,b,a.y)
if(l===13){n=a.x
m=b.length
n=m-1-n
if(!(n>=0&&n<m))return A.a(b,n)
return b[n]}return"?"},
v7(a){var s=A.pL(a)
if(s!=null)return s
return"minified:"+a},
tn(a,b){var s=a.tR[b]
while(typeof s=="string")s=a.tR[s]
return s},
tm(a,b){var s,r,q,p,o,n=a.eT,m=n[b]
if(m==null)return A.kH(a,b,!1)
else if(typeof m=="number"){s=m
r=A.eC(a,5,"#")
q=A.kL(s)
for(p=0;p<s;++p)q[p]=r
o=A.eB(a,b,q)
n[b]=o
return o}else return m},
tl(a,b){return A.oR(a.tR,b)},
tk(a,b){return A.oR(a.eT,b)},
kH(a,b,c){var s,r=a.eC,q=r.get(b)
if(q!=null)return q
s=A.oO(a,null,b,!1)
r.set(b,s)
return s},
eD(a,b,c){var s,r,q=b.z
if(q==null)q=b.z=new Map()
s=q.get(c)
if(s!=null)return s
r=A.oO(a,b,c,!0)
q.set(c,r)
return r},
oP(a,b,c){var s,r,q,p=b.Q
if(p==null)p=b.Q=new Map()
s=c.as
r=p.get(s)
if(r!=null)return r
q=A.mM(a,b,c.w===9?c.y:[c])
p.set(s,q)
return q},
oO(a,b,c,d){return A.tb(A.t5(a,b,c,d))},
bW(a,b){b.a=A.tZ
b.b=A.u_
return b},
eC(a,b,c){var s,r,q=a.eC.get(c)
if(q!=null)return q
s=new A.b1(null,null)
s.w=b
s.as=c
r=A.bW(a,s)
a.eC.set(c,r)
return r},
oM(a,b,c){var s,r=b.as+"?",q=a.eC.get(r)
if(q!=null)return q
s=A.ti(a,b,r,c)
a.eC.set(r,s)
return s},
ti(a,b,c,d){var s,r,q
if(d){s=b.w
r=!0
if(!A.cx(b))if(!(b===t.P||b===t.T))if(s!==6)r=s===7&&A.d9(b.x)
if(r)return b
else if(s===1)return t.P}q=new A.b1(null,null)
q.w=6
q.x=b
q.as=c
return A.bW(a,q)},
oL(a,b,c){var s,r=b.as+"/",q=a.eC.get(r)
if(q!=null)return q
s=A.tg(a,b,r,c)
a.eC.set(r,s)
return s},
tg(a,b,c,d){var s,r
if(d){s=b.w
if(A.cx(b)||b===t.K)return b
else if(s===1)return A.eB(a,"am",[b])
else if(b===t.P||b===t.T)return t.eH}r=new A.b1(null,null)
r.w=7
r.x=b
r.as=c
return A.bW(a,r)},
tj(a,b){var s,r,q=""+b+"^",p=a.eC.get(q)
if(p!=null)return p
s=new A.b1(null,null)
s.w=13
s.x=b
s.as=q
r=A.bW(a,s)
a.eC.set(q,r)
return r},
eA(a){var s,r,q,p=a.length
for(s="",r="",q=0;q<p;++q,r=",")s+=r+a[q].as
return s},
tf(a){var s,r,q,p,o,n=a.length
for(s="",r="",q=0;q<n;q+=3,r=","){p=a[q]
o=a[q+1]?"!":":"
s+=r+p+o+a[q+2].as}return s},
eB(a,b,c){var s,r,q,p=b
if(c.length>0)p+="<"+A.eA(c)+">"
s=a.eC.get(p)
if(s!=null)return s
r=new A.b1(null,null)
r.w=8
r.x=b
r.y=c
if(c.length>0)r.c=c[0]
r.as=p
q=A.bW(a,r)
a.eC.set(p,q)
return q},
mM(a,b,c){var s,r,q,p,o,n
if(b.w===9){s=b.x
r=b.y.concat(c)}else{r=c
s=b}q=s.as+(";<"+A.eA(r)+">")
p=a.eC.get(q)
if(p!=null)return p
o=new A.b1(null,null)
o.w=9
o.x=s
o.y=r
o.as=q
n=A.bW(a,o)
a.eC.set(q,n)
return n},
oN(a,b,c){var s,r,q="+"+(b+"("+A.eA(c)+")"),p=a.eC.get(q)
if(p!=null)return p
s=new A.b1(null,null)
s.w=10
s.x=b
s.y=c
s.as=q
r=A.bW(a,s)
a.eC.set(q,r)
return r},
oK(a,b,c){var s,r,q,p,o,n=b.as,m=c.a,l=m.length,k=c.b,j=k.length,i=c.c,h=i.length,g="("+A.eA(m)
if(j>0){s=l>0?",":""
g+=s+"["+A.eA(k)+"]"}if(h>0){s=l>0?",":""
g+=s+"{"+A.tf(i)+"}"}r=n+(g+")")
q=a.eC.get(r)
if(q!=null)return q
p=new A.b1(null,null)
p.w=11
p.x=b
p.y=c
p.as=r
o=A.bW(a,p)
a.eC.set(r,o)
return o},
mN(a,b,c,d){var s,r=b.as+("<"+A.eA(c)+">"),q=a.eC.get(r)
if(q!=null)return q
s=A.th(a,b,c,r,d)
a.eC.set(r,s)
return s},
th(a,b,c,d,e){var s,r,q,p,o,n,m,l
if(e){s=c.length
r=A.kL(s)
for(q=0,p=0;p<s;++p){o=c[p]
if(o.w===1){r[p]=o;++q}}if(q>0){n=A.cs(a,b,r,0)
m=A.d5(a,c,r,0)
return A.mN(a,n,m,c!==m)}}l=new A.b1(null,null)
l.w=12
l.x=b
l.y=c
l.as=d
return A.bW(a,l)},
t5(a,b,c,d){return{u:a,e:b,r:c,s:[],p:0,n:d}},
tb(a){var s,r,q,p,o,n,m,l=a.r,k=a.s
for(s=l.length,r=0;r<s;){q=l.charCodeAt(r)
if(q>=48&&q<=57)r=A.t7(r+1,q,l,k)
else if((((q|32)>>>0)-97&65535)<26||q===95||q===36||q===124)r=A.oG(a,r,l,k,!1)
else if(q===46)r=A.oG(a,r,l,k,!0)
else{++r
switch(q){case 44:break
case 58:k.push(!1)
break
case 33:k.push(!0)
break
case 59:k.push(A.cl(a.u,a.e,k.pop()))
break
case 94:k.push(A.tj(a.u,k.pop()))
break
case 35:k.push(A.eC(a.u,5,"#"))
break
case 64:k.push(A.eC(a.u,2,"@"))
break
case 126:k.push(A.eC(a.u,3,"~"))
break
case 60:k.push(a.p)
a.p=k.length
break
case 62:A.t9(a,k)
break
case 38:A.t8(a,k)
break
case 63:p=a.u
k.push(A.oM(p,A.cl(p,a.e,k.pop()),a.n))
break
case 47:p=a.u
k.push(A.oL(p,A.cl(p,a.e,k.pop()),a.n))
break
case 40:k.push(-3)
k.push(a.p)
a.p=k.length
break
case 41:A.t6(a,k)
break
case 91:k.push(a.p)
a.p=k.length
break
case 93:o=k.splice(a.p)
A.oH(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-1)
break
case 123:k.push(a.p)
a.p=k.length
break
case 125:o=k.splice(a.p)
A.tc(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-2)
break
case 43:n=l.indexOf("(",r)
k.push(l.substring(r,n))
k.push(-4)
k.push(a.p)
a.p=k.length
r=n+1
break
default:throw"Bad character "+q}}}m=k.pop()
return A.cl(a.u,a.e,m)},
t7(a,b,c,d){var s,r,q=b-48
for(s=c.length;a<s;++a){r=c.charCodeAt(a)
if(!(r>=48&&r<=57))break
q=q*10+(r-48)}d.push(q)
return a},
oG(a,b,c,d,e){var s,r,q,p,o,n,m=b+1
for(s=c.length;m<s;++m){r=c.charCodeAt(m)
if(r===46){if(e)break
e=!0}else{if(!((((r|32)>>>0)-97&65535)<26||r===95||r===36||r===124))q=r>=48&&r<=57
else q=!0
if(!q)break}}p=c.substring(b,m)
if(e){s=a.u
o=a.e
if(o.w===9)o=o.x
n=A.tn(s,o.x)[p]
if(n==null)A.j('No "'+p+'" in "'+A.rx(o)+'"')
d.push(A.eD(s,o,n))}else d.push(p)
return m},
t9(a,b){var s,r=a.u,q=A.oF(a,b),p=b.pop()
if(typeof p=="string")b.push(A.eB(r,p,q))
else{s=A.cl(r,a.e,p)
switch(s.w){case 11:b.push(A.mN(r,s,q,a.n))
break
default:b.push(A.mM(r,s,q))
break}}},
t6(a,b){var s,r,q,p=a.u,o=b.pop(),n=null,m=null
if(typeof o=="number")switch(o){case-1:n=b.pop()
break
case-2:m=b.pop()
break
default:b.push(o)
break}else b.push(o)
s=A.oF(a,b)
o=b.pop()
switch(o){case-3:o=b.pop()
if(n==null)n=p.sEA
if(m==null)m=p.sEA
r=A.cl(p,a.e,o)
q=new A.h_()
q.a=s
q.b=n
q.c=m
b.push(A.oK(p,r,q))
return
case-4:b.push(A.oN(p,b.pop(),s))
return
default:throw A.d(A.eV("Unexpected state under `()`: "+A.r(o)))}},
t8(a,b){var s=b.pop()
if(0===s){b.push(A.eC(a.u,1,"0&"))
return}if(1===s){b.push(A.eC(a.u,4,"1&"))
return}throw A.d(A.eV("Unexpected extended operation "+A.r(s)))},
oF(a,b){var s=b.splice(a.p)
A.oH(a.u,a.e,s)
a.p=b.pop()
return s},
cl(a,b,c){if(typeof c=="string")return A.eB(a,c,a.sEA)
else if(typeof c=="number"){b.toString
return A.ta(a,b,c)}else return c},
oH(a,b,c){var s,r=c.length
for(s=0;s<r;++s)c[s]=A.cl(a,b,c[s])},
tc(a,b,c){var s,r=c.length
for(s=2;s<r;s+=3)c[s]=A.cl(a,b,c[s])},
ta(a,b,c){var s,r,q=b.w
if(q===9){if(c===0)return b.x
s=b.y
r=s.length
if(c<=r)return s[c-1]
c-=r
b=b.x
q=b.w}else if(c===0)return b
if(q!==8)throw A.d(A.eV("Indexed base must be an interface type"))
s=b.y
if(c<=s.length)return s[c-1]
throw A.d(A.eV("Bad index "+c+" for "+b.n(0)))},
vJ(a,b,c){var s,r=b.d
if(r==null)r=b.d=new Map()
s=r.get(c)
if(s==null){s=A.ab(a,b,null,c,null)
r.set(c,s)}return s},
ab(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i
if(b===d)return!0
if(A.cx(d))return!0
s=b.w
if(s===4)return!0
if(A.cx(b))return!1
if(b.w===1)return!0
r=s===13
if(r)if(A.ab(a,c[b.x],c,d,e))return!0
q=d.w
p=t.P
if(b===p||b===t.T){if(q===7)return A.ab(a,b,c,d.x,e)
return d===p||d===t.T||q===6}if(d===t.K){if(s===7)return A.ab(a,b.x,c,d,e)
return s!==6}if(s===7){if(!A.ab(a,b.x,c,d,e))return!1
return A.ab(a,A.mv(a,b),c,d,e)}if(s===6)return A.ab(a,p,c,d,e)&&A.ab(a,b.x,c,d,e)
if(q===7){if(A.ab(a,b,c,d.x,e))return!0
return A.ab(a,b,c,A.mv(a,d),e)}if(q===6)return A.ab(a,b,c,p,e)||A.ab(a,b,c,d.x,e)
if(r)return!1
p=s!==11
if((!p||s===12)&&d===t.Y)return!0
o=s===10
if(o&&d===t.gT)return!0
if(q===12){if(b===t.W)return!0
if(s!==12)return!1
n=b.y
m=d.y
l=n.length
if(l!==m.length)return!1
c=c==null?n:n.concat(c)
e=e==null?m:m.concat(e)
for(k=0;k<l;++k){j=n[k]
i=m[k]
if(!A.ab(a,j,c,i,e)||!A.ab(a,i,e,j,c))return!1}return A.pb(a,b.x,c,d.x,e)}if(q===11){if(b===t.W)return!0
if(p)return!1
return A.pb(a,b,c,d,e)}if(s===8){if(q!==8)return!1
return A.u4(a,b,c,d,e)}if(o&&q===10)return A.u9(a,b,c,d,e)
return!1},
pb(a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
if(!A.ab(a3,a4.x,a5,a6.x,a7))return!1
s=a4.y
r=a6.y
q=s.a
p=r.a
o=q.length
n=p.length
if(o>n)return!1
m=n-o
l=s.b
k=r.b
j=l.length
i=k.length
if(o+j<n+i)return!1
for(h=0;h<o;++h){g=q[h]
if(!A.ab(a3,p[h],a7,g,a5))return!1}for(h=0;h<m;++h){g=l[h]
if(!A.ab(a3,p[o+h],a7,g,a5))return!1}for(h=0;h<i;++h){g=l[m+h]
if(!A.ab(a3,k[h],a7,g,a5))return!1}f=s.c
e=r.c
d=f.length
c=e.length
for(b=0,a=0;a<c;a+=3){a0=e[a]
for(;;){if(b>=d)return!1
a1=f[b]
b+=3
if(a0<a1)return!1
a2=f[b-2]
if(a1<a0){if(a2)return!1
continue}g=e[a+1]
if(a2&&!g)return!1
g=f[b-1]
if(!A.ab(a3,e[a+2],a7,g,a5))return!1
break}}while(b<d){if(f[b+1])return!1
b+=3}return!0},
u4(a,b,c,d,e){var s,r,q,p,o,n=b.x,m=d.x
while(n!==m){s=a.tR[n]
if(s==null)return!1
if(typeof s=="string"){n=s
continue}r=s[m]
if(r==null)return!1
q=r.length
p=q>0?new Array(q):v.typeUniverse.sEA
for(o=0;o<q;++o)p[o]=A.eD(a,b,r[o])
return A.oS(a,p,null,c,d.y,e)}return A.oS(a,b.y,null,c,d.y,e)},
oS(a,b,c,d,e,f){var s,r=b.length
for(s=0;s<r;++s)if(!A.ab(a,b[s],d,e[s],f))return!1
return!0},
u9(a,b,c,d,e){var s,r=b.y,q=d.y,p=r.length
if(p!==q.length)return!1
if(b.x!==d.x)return!1
for(s=0;s<p;++s)if(!A.ab(a,r[s],c,q[s],e))return!1
return!0},
d9(a){var s=a.w,r=!0
if(!(a===t.P||a===t.T))if(!A.cx(a))if(s!==6)r=s===7&&A.d9(a.x)
return r},
cx(a){var s=a.w
return s===2||s===3||s===4||s===5||a===t.X},
oR(a,b){var s,r,q=Object.keys(b),p=q.length
for(s=0;s<p;++s){r=q[s]
a[r]=b[r]}},
kL(a){return a>0?new Array(a):v.typeUniverse.sEA},
b1:function b1(a,b){var _=this
_.a=a
_.b=b
_.r=_.f=_.d=_.c=null
_.w=0
_.as=_.Q=_.z=_.y=_.x=null},
h_:function h_(){this.c=this.b=this.a=null},
hd:function hd(a){this.a=a},
fZ:function fZ(){},
ez:function ez(a){this.a=a},
rV(){var s,r,q
if(self.scheduleImmediate!=null)return A.vk()
if(self.MutationObserver!=null&&self.document!=null){s={}
r=self.document.createElement("div")
q=self.document.createElement("span")
s.a=null
new self.MutationObserver(A.d7(new A.k4(s),1)).observe(r,{childList:true})
return new A.k3(s,r,q)}else if(self.setImmediate!=null)return A.vl()
return A.vm()},
rW(a){self.scheduleImmediate(A.d7(new A.k5(t.M.a(a)),0))},
rX(a){self.setImmediate(A.d7(new A.k6(t.M.a(a)),0))},
rY(a){A.on(B.b9,t.M.a(a))},
on(a,b){return A.td(a.a/1000|0,b)},
td(a,b){var s=new A.kF()
s.it(a,b)
return s},
a3(a){return new A.fP(new A.x($.w,a.h("x<0>")),a.h("fP<0>"))},
a2(a,b){a.$2(0,null)
b.b=!0
return b.a},
A(a,b){A.tw(a,b)},
a1(a,b){b.cA(a)},
a0(a,b){b.e9(A.G(a),A.aq(a))},
tw(a,b){var s,r,q=new A.kR(b),p=new A.kS(b)
if(a instanceof A.x)a.h6(q,p,t.z)
else{s=t.z
if(a instanceof A.x)a.cS(q,p,s)
else{r=new A.x($.w,t._)
r.a=8
r.c=a
r.h6(q,p,s)}}},
a4(a){var s=function(b,c){return function(d,e){while(true){try{b(d,e)
break}catch(q){e=q
d=c}}}}(a,1),r=$.w
return r.dR(r,t.cl.a(new A.lm(s)),t.H,t.S,t.z)},
oJ(a,b,c){return 0},
cz(a){var s
if(t.C.b(a)){s=a.gbE()
if(s!=null)return s}return B.S},
ra(a,b){var s=a==null?b.a(a):a,r=new A.x($.w,b.h("x<0>"))
r.bL(s)
return r},
r9(a,b,c){var s
if(b==null&&!c.b(null))throw A.d(A.aZ(null,"computation","The type parameter is not nullable"))
s=new A.x($.w,c.h("x<0>"))
A.rB(a,new A.ij(b,s,c))
return s},
hh(a,b){var s=$.w
if(s===B.n)return null
s.jb(s,a,b)
return null},
pa(a,b){if($.w!==B.n)A.hh(a,b)
if(b==null)if(t.C.b(a)){b=a.gbE()
if(b==null){A.mt(a,B.S)
b=B.S}}else b=B.S
else if(t.C.b(a))A.mt(a,b)
return new A.aa(a,b)},
t0(a,b,c){var s=new A.x(b,c.h("x<0>"))
c.a(a)
s.a=8
s.c=a
return s},
kk(a,b,c){var s,r,q,p,o,n={},m=n.a=a
for(s=t._;r=m.a,(r&4)!==0;m=a){a=s.a(m.c)
n.a=a}if(m===b){s=A.ry()
b.bM(new A.aa(new A.aQ(!0,m,null,"Cannot complete a future with itself"),s))
return}q=b.a&1
s=m.a=r|q
if((s&24)===0){p=t.F.a(b.c)
b.a=b.a&1|4
b.c=m
m.fN(p)
return}if(!c)if(b.c==null)m=(s&16)===0||q!==0
else m=!1
else m=!0
if(m){p=b.bV()
b.cb(n.a)
A.ci(b,p)
return}b.a^=2
o=b.b
o.b2(o,new A.kl(n,b))},
ci(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e={},d=e.a=a
for(s=t.n,r=t.F;;){q={}
p=d.a
o=(p&16)===0
n=!o
if(b==null){if(n&&(p&1)===0){m=s.a(d.c)
d=d.b
d.b8(d,m.a,m.b)}return}q.a=b
l=b.a
for(d=b;l!=null;d=l,l=k){d.a=null
A.ci(e.a,d)
q.a=l
k=l.a}j=e.a.c
q.b=n
q.c=j
if(o){p=d.c
p=(p&1)!==0||(p&15)===8}else p=!0
if(p){i=d.b.b
h=$.w
if(h!==i)$.w=i
else h=null
d=d.c
if((d&15)===8)new A.kp(q,e,n).$0()
else if(o){if((d&1)!==0)new A.ko(q,j).$0()}else if((d&2)!==0)new A.kn(e,q).$0()
if(h!=null)$.w=h
d=q.c
if(d instanceof A.x){p=q.a.$ti
p=p.h("am<2>").b(d)||!p.y[1].b(d)}else p=!1
if(p){g=q.a.b
if((d.a&24)!==0){f=r.a(g.c)
g.c=null
b=g.co(f)
g.a=d.a&30|g.a&1
g.c=d.c
e.a=d
continue}else A.kk(d,g,!0)
return}}g=q.a.b
f=r.a(g.c)
g.c=null
b=g.co(f)
d=q.b
p=q.c
if(!d){g.$ti.c.a(p)
g.a=8
g.c=p}else{s.a(p)
g.a=g.a&1|16
g.c=p}e.a=g
d=g}},
ph(a,b){var s=t.Q
if(s.b(a))return b.dR(b,s.a(a),t.z,t.K,t.l)
s=t.v
if(s.b(a))return b.cn(b,s.a(a),t.z,t.K)
throw A.d(A.aZ(a,"onError",u.c))},
uk(){var s,r
for(s=$.d4;s!=null;s=$.d4){$.eL=null
r=s.b
$.d4=r
if(r==null)$.eK=null
s.a.$0()}},
uV(){$.mY=!0
try{A.uk()}finally{$.eL=null
$.mY=!1
if($.d4!=null)$.nr().$1(A.pv())}},
pm(a){var s=new A.fQ(a),r=$.eK
if(r==null){$.d4=$.eK=s
if(!$.mY)$.nr().$1(A.pv())}else $.eK=r.b=s},
uO(a){var s,r,q,p=$.d4
if(p==null){A.pm(a)
$.eL=$.eK
return}s=new A.fQ(a)
r=$.eL
if(r==null){s.b=p
$.d4=$.eL=s}else{q=r.b
s.b=q
$.eL=r.b=s
if(q==null)$.eK=s}},
vQ(a){var s=$.w
if(B.n===s){A.n2(B.n,a)
return}A.n2(s,s.bU(s,a,t.H))
return},
om(a,b){return new A.ep(new A.iK(a,b),b.h("ep<0>"))},
wq(a,b){return new A.co(A.ba(a,"stream",t.K),b.h("co<0>"))},
hk(a){var s,r,q,p
if(a==null)return
try{a.$0()}catch(q){s=A.G(q)
r=A.aq(q)
p=$.w
p.b8(p,A.b8(s),t.l.a(r))}},
t_(a,b){if(b==null)b=A.vo()
if(t.da.b(b))return a.dR(a,t.Q.a(b),t.z,t.K,t.l)
if(t.d5.b(b))return a.cn(a,t.v.a(b),t.z,t.K)
throw A.d(A.bd("handleError callback must take either an Object (the error), or both an Object (the error) and a StackTrace.",null))},
un(a,b){var s=$.w
s.b8(s,a,b)},
um(){},
rB(a,b){var s=$.w
if(s===B.n)return s.f0(s,a,t.M.a(b))
return s.f0(s,a,t.M.a(s.l0(b)))},
uL(a,b){A.uO(new A.lg(a,b))},
n2(a,b){if(B.n!==a)b=a.hs(b,t.H)
A.pm(b)},
k4:function k4(a){this.a=a},
k3:function k3(a,b,c){this.a=a
this.b=b
this.c=c},
k5:function k5(a){this.a=a},
k6:function k6(a){this.a=a},
kF:function kF(){},
kG:function kG(a,b){this.a=a
this.b=b},
fP:function fP(a,b){this.a=a
this.b=!1
this.$ti=b},
kR:function kR(a){this.a=a},
kS:function kS(a){this.a=a},
lm:function lm(a){this.a=a},
cp:function cp(a,b){var _=this
_.a=a
_.e=_.d=_.c=_.b=null
_.$ti=b},
bx:function bx(a,b){this.a=a
this.$ti=b},
aa:function aa(a,b){this.a=a
this.b=b},
ij:function ij(a,b,c){this.a=a
this.b=b
this.c=c},
fR:function fR(){},
cg:function cg(a,b){this.a=a
this.$ti=b},
b5:function b5(a,b,c,d,e){var _=this
_.a=null
_.b=a
_.c=b
_.d=c
_.e=d
_.$ti=e},
x:function x(a,b){var _=this
_.a=0
_.b=a
_.c=null
_.$ti=b},
kh:function kh(a,b){this.a=a
this.b=b},
km:function km(a,b){this.a=a
this.b=b},
kl:function kl(a,b){this.a=a
this.b=b},
kj:function kj(a,b){this.a=a
this.b=b},
ki:function ki(a,b){this.a=a
this.b=b},
kp:function kp(a,b,c){this.a=a
this.b=b
this.c=c},
kq:function kq(a,b){this.a=a
this.b=b},
kr:function kr(a){this.a=a},
ko:function ko(a,b){this.a=a
this.b=b},
kn:function kn(a,b){this.a=a
this.b=b},
fQ:function fQ(a){this.a=a
this.b=null},
dZ:function dZ(){},
iK:function iK(a,b){this.a=a
this.b=b},
iL:function iL(a,b,c){this.a=a
this.b=b
this.c=c},
iJ:function iJ(a,b,c){this.a=a
this.b=b
this.c=c},
iM:function iM(a,b){this.a=a
this.b=b},
iN:function iN(a,b){this.a=a
this.b=b},
d0:function d0(){},
kE:function kE(a){this.a=a},
kD:function kD(a){this.a=a},
ee:function ee(){},
cV:function cV(){},
ch:function ch(a,b,c,d,e,f,g){var _=this
_.w=a
_.a=b
_.b=c
_.c=d
_.d=e
_.e=f
_.r=_.f=null
_.$ti=g},
ef:function ef(){},
k9:function k9(a,b,c){this.a=a
this.b=b
this.c=c},
k8:function k8(a){this.a=a},
bv:function bv(){},
eh:function eh(a,b){this.b=a
this.a=null
this.$ti=b},
cY:function cY(a,b){this.b=a
this.c=b
this.a=null},
fY:function fY(){},
b6:function b6(a){var _=this
_.a=0
_.c=_.b=null
_.$ti=a},
kA:function kA(a,b){this.a=a
this.b=b},
co:function co(a,b){var _=this
_.a=null
_.b=a
_.c=!1
_.$ti=b},
ep:function ep(a,b){this.b=a
this.$ti=b},
kz:function kz(a,b){this.a=a
this.b=b},
eq:function eq(a,b,c,d,e){var _=this
_.a=null
_.b=0
_.c=null
_.d=a
_.e=b
_.f=c
_.r=d
_.$ti=e},
jo:function jo(){},
jq:function jq(a,b,c){this.a=a
this.b=b
this.c=c},
jp:function jp(a,b){this.a=a
this.b=b},
lg:function lg(a,b){this.a=a
this.b=b},
z(a,b,c){return b.h("@<0>").M(c).h("mm<1,2>").a(A.pz(a,new A.bn(b.h("@<0>").M(c).h("bn<1,2>"))))},
c7(a,b){return new A.bn(a.h("@<0>").M(b).h("bn<1,2>"))},
o8(a){return new A.ek(a.h("ek<0>"))},
mJ(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s},
mn(a){var s,r
if(A.nb(a))return"{...}"
s=new A.bS("")
try{r={}
B.b.m($.aN,a)
s.a+="{"
r.a=!0
a.aO(0,new A.iv(r,s))
s.a+="}"}finally{if(0>=$.aN.length)return A.a($.aN,-1)
$.aN.pop()}r=s.a
return r.charCodeAt(0)==0?r:r},
ek:function ek(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
h4:function h4(a){this.a=a
this.c=this.b=null},
el:function el(a,b,c){var _=this
_.a=a
_.b=b
_.d=_.c=null
_.$ti=c},
e2:function e2(a,b){this.a=a
this.$ti=b},
o:function o(){},
D:function D(){},
iu:function iu(a){this.a=a},
iv:function iv(a,b){this.a=a
this.b=b},
em:function em(a,b){this.a=a
this.$ti=b},
en:function en(a,b,c){var _=this
_.a=a
_.b=b
_.c=null
_.$ti=c},
bP:function bP(){},
ev:function ev(){},
ur(a,b){var s,r,q,p=null
try{p=JSON.parse(a)}catch(r){s=A.G(r)
q=A.dx(String(s),null,null)
throw A.d(q)}q=A.kX(p)
return q},
kX(a){var s
if(a==null)return null
if(typeof a!="object")return a
if(!Array.isArray(a))return new A.h1(a,Object.create(null))
for(s=0;s<a.length;++s)a[s]=A.kX(a[s])
return a},
tp(a,b,c){var s,r,q,p,o=c-b
if(o<=4096)s=$.qm()
else s=new Uint8Array(o)
for(r=J.aj(a),q=0;q<o;++q){p=r.l(a,b+q)
if((p&255)!==p)p=255
s[q]=p}return s},
to(a,b,c,d){var s=a?$.ql():$.qk()
if(s==null)return null
if(0===c&&d===b.length)return A.oQ(s,b)
return A.oQ(s,b.subarray(c,d))},
oQ(a,b){var s,r
try{s=a.decode(b)
return s}catch(r){}return null},
rZ(a,b,c,d,e,f,g,a0){var s,r,q,p,o,n,m,l,k,j,i=a0>>>2,h=3-(a0&3)
for(s=b.length,r=a.length,q=f.$flags|0,p=c,o=0;p<d;++p){if(!(p<s))return A.a(b,p)
n=b[p]
o|=n
i=(i<<8|n)&16777215;--h
if(h===0){m=g+1
l=i>>>18&63
if(!(l<r))return A.a(a,l)
q&2&&A.b(f)
k=f.length
if(!(g<k))return A.a(f,g)
f[g]=a.charCodeAt(l)
g=m+1
l=i>>>12&63
if(!(l<r))return A.a(a,l)
if(!(m<k))return A.a(f,m)
f[m]=a.charCodeAt(l)
m=g+1
l=i>>>6&63
if(!(l<r))return A.a(a,l)
if(!(g<k))return A.a(f,g)
f[g]=a.charCodeAt(l)
g=m+1
l=i&63
if(!(l<r))return A.a(a,l)
if(!(m<k))return A.a(f,m)
f[m]=a.charCodeAt(l)
i=0
h=3}}if(o>=0&&o<=255){if(h<3){m=g+1
j=m+1
if(3-h===1){s=i>>>2&63
if(!(s<r))return A.a(a,s)
q&2&&A.b(f)
q=f.length
if(!(g<q))return A.a(f,g)
f[g]=a.charCodeAt(s)
s=i<<4&63
if(!(s<r))return A.a(a,s)
if(!(m<q))return A.a(f,m)
f[m]=a.charCodeAt(s)
g=j+1
if(!(j<q))return A.a(f,j)
f[j]=61
if(!(g<q))return A.a(f,g)
f[g]=61}else{s=i>>>10&63
if(!(s<r))return A.a(a,s)
q&2&&A.b(f)
q=f.length
if(!(g<q))return A.a(f,g)
f[g]=a.charCodeAt(s)
s=i>>>4&63
if(!(s<r))return A.a(a,s)
if(!(m<q))return A.a(f,m)
f[m]=a.charCodeAt(s)
g=j+1
s=i<<2&63
if(!(s<r))return A.a(a,s)
if(!(j<q))return A.a(f,j)
f[j]=a.charCodeAt(s)
if(!(g<q))return A.a(f,g)
f[g]=61}return 0}return(i<<2|3-h)>>>0}for(p=c;p<d;){if(!(p<s))return A.a(b,p)
n=b[p]
if(n>255)break;++p}if(!(p<s))return A.a(b,p)
throw A.d(A.aZ(b,"Not a byte value at index "+p+": 0x"+B.a.m2(b[p],16),null))},
o6(a,b,c){return new A.dF(a,b)},
tM(a){return a.me()},
t3(a,b){return new A.kv(a,[],A.vs())},
t4(a,b,c){var s,r=new A.bS(""),q=A.t3(r,b)
q.cV(a)
s=r.a
return s.charCodeAt(0)==0?s:s},
tq(a){switch(a){case 65:return"Missing extension byte"
case 67:return"Unexpected extension byte"
case 69:return"Invalid UTF-8 byte"
case 71:return"Overlong encoding"
case 73:return"Out of unicode range"
case 75:return"Encoded surrogate"
case 77:return"Unfinished UTF-8 octet sequence"
default:return""}},
h1:function h1(a,b){this.a=a
this.b=b
this.c=null},
ku:function ku(a){this.a=a},
h2:function h2(a){this.a=a},
kJ:function kJ(){},
kI:function kI(){},
eS:function eS(){},
he:function he(){},
eT:function eT(){},
di:function di(){},
eW:function eW(){},
k7:function k7(a){this.a=0
this.b=a},
eZ:function eZ(){},
aD:function aD(){},
a_:function a_(){},
cD:function cD(){},
dF:function dF(a,b){this.a=a
this.b=b},
fm:function fm(a,b){this.a=a
this.b=b},
fl:function fl(){},
fo:function fo(a){this.b=a},
fn:function fn(a){this.a=a},
kw:function kw(){},
kx:function kx(a,b){this.a=a
this.b=b},
kv:function kv(a,b,c){this.c=a
this.a=b
this.b=c},
fE:function fE(){},
fG:function fG(){},
kK:function kK(a){this.b=0
this.c=a},
fF:function fF(a){this.a=a},
eE:function eE(a){this.a=a
this.b=16
this.c=0},
hm(a){var s=A.oh(a,null)
if(s!=null)return s
throw A.d(A.dx(a,null,null))},
r6(a,b){a=A.a5(a,new Error())
if(a==null)a=A.b8(a)
a.stack=b.n(0)
throw a},
b_(a,b,c,d){var s,r=c?J.o0(a,d):J.o_(a,d)
if(a!==0&&b!=null)for(s=0;s<r.length;++s)r[s]=b
return r},
ri(a,b,c){var s,r=A.i([],c.h("u<0>"))
for(s=J.aO(a);s.u();)B.b.m(r,c.a(s.gC()))
if(b)return r
r.$flags=1
return r},
aS(a,b){var s,r
if(Array.isArray(a))return A.i(a.slice(0),b.h("u<0>"))
s=A.i([],b.h("u<0>"))
for(r=J.aO(a);r.u();)B.b.m(s,r.gC())
return s},
cb(a,b,c){var s,r,q,p,o
A.bN(b,"start")
s=c==null
r=!s
if(r){q=c-b
if(q<0)throw A.d(A.ac(c,b,null,"end",null))
if(q===0)return""}if(Array.isArray(a)){p=a
o=p.length
if(s)c=o
return A.oj(b>0||c<o?p.slice(b,c):p)}if(t.bm.b(a))return A.rA(a,b,c)
if(r)a=J.qI(a,c)
if(b>0)a=J.m9(a,b)
s=A.aS(a,t.S)
return A.oj(s)},
rA(a,b,c){var s=a.length
if(b>=s)return""
return A.rs(a,b,c==null||c>s?s:c)},
an(a,b){return new A.dC(a,A.o5(a,!1,b,!1,!1,""))},
my(a,b,c){var s=J.aO(b)
if(!s.u())return a
if(c.length===0){do a+=A.r(s.gC())
while(s.u())}else{a+=A.r(s.gC())
while(s.u())a=a+c+A.r(s.gC())}return a},
ry(){return A.aq(new Error())},
md(a,b){var s="microsecond"
if(b>999)throw A.d(A.ac(b,0,999,s,null))
if(a<-864e13||a>864e13)throw A.d(A.ac(a,-864e13,864e13,"millisecondsSinceEpoch",null))
if(a===864e13&&b!==0)throw A.d(A.aZ(b,s,"Time including microseconds is outside valid range"))
return a},
r2(a,b,c,d,e,f,g,h,i){var s=A.mu(a,b,c,d,e,f,g,h,i)
if(s==null)return null
return new A.aF(A.md(s,h),h,i)},
mc(a,b,c,d,e,f){var s=A.mu(a,b,c,d,e,f,0,0,!1)
return new A.aF(s==null?new A.f8(a,b,c,d,e,f,0,0).$0():s,0,!1)},
r1(a){var s=A.mu(a,1,1,0,0,0,0,0,!0)
return new A.aF(s==null?new A.f8(a,1,1,0,0,0,0,0).$0():s,0,!0)},
r4(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=$.pX().bA(a)
if(c!=null){s=new A.ig()
r=c.b
if(1>=r.length)return A.a(r,1)
q=r[1]
q.toString
p=A.hm(q)
if(2>=r.length)return A.a(r,2)
q=r[2]
q.toString
o=A.hm(q)
if(3>=r.length)return A.a(r,3)
q=r[3]
q.toString
n=A.hm(q)
if(4>=r.length)return A.a(r,4)
m=s.$1(r[4])
if(5>=r.length)return A.a(r,5)
l=s.$1(r[5])
if(6>=r.length)return A.a(r,6)
k=s.$1(r[6])
if(7>=r.length)return A.a(r,7)
j=new A.ih().$1(r[7])
i=B.a.t(j,1000)
q=r.length
if(8>=q)return A.a(r,8)
h=r[8]!=null
if(h){if(9>=q)return A.a(r,9)
g=r[9]
if(g!=null){f=g==="-"?-1:1
if(10>=q)return A.a(r,10)
q=r[10]
q.toString
e=A.hm(q)
if(11>=r.length)return A.a(r,11)
l-=f*(s.$1(r[11])+60*e)}}d=A.r2(p,o,n,m,l,k,i,j%1000,h)
if(d==null)throw A.d(A.dx("Time out of range",a,null))
return d}else throw A.d(A.dx("Invalid date format",a,null))},
r5(a){var s,r
try{s=A.r4(a)
return s}catch(r){if(A.G(r) instanceof A.ay)return null
else throw r}},
nS(a){var s=Math.abs(a),r=a<0?"-":""
if(s>=1000)return""+a
if(s>=100)return r+"0"+s
if(s>=10)return r+"00"+s
return r+"000"+s},
r3(a){var s=Math.abs(a),r=a<0?"-":"+"
if(s>=1e5)return r+s
return r+"0"+s},
ie(a){if(a>=100)return""+a
if(a>=10)return"0"+a
return"00"+a},
bk(a){if(a>=10)return""+a
return"0"+a},
fb(a){if(typeof a=="number"||A.mW(a)||a==null)return J.aY(a)
if(typeof a=="string")return JSON.stringify(a)
return A.oi(a)},
me(a,b){A.ba(a,"error",t.K)
A.ba(b,"stackTrace",t.l)
A.r6(a,b)},
eV(a){return new A.eU(a)},
bd(a,b){return new A.aQ(!1,null,b,a)},
aZ(a,b,c){return new A.aQ(!0,a,b,c)},
rv(a,b){return new A.bq(null,null,!0,a,b,"Value not in range")},
ac(a,b,c,d,e){return new A.bq(b,c,!0,a,d,"Invalid value")},
bO(a,b,c){if(0>a||a>c)throw A.d(A.ac(a,0,c,"start",null))
if(b!=null){if(a>b||b>c)throw A.d(A.ac(b,a,c,"end",null))
return b}return c},
bN(a,b){if(a<0)throw A.d(A.ac(a,0,null,b,null))
return a},
mi(a,b,c,d){return new A.fe(b,!0,a,d,"Index out of range")},
ao(a){return new A.e3(a)},
op(a){return new A.fC(a)},
az(a){return new A.bR(a)},
ax(a){return new A.f3(a)},
dx(a,b,c){return new A.ay(a,b,c)},
rd(a,b,c){var s,r
if(A.nb(a)){if(b==="("&&c===")")return"(...)"
return b+"..."+c}s=A.i([],t.s)
B.b.m($.aN,a)
try{A.ud(a,s)}finally{if(0>=$.aN.length)return A.a($.aN,-1)
$.aN.pop()}r=A.my(b,t.hf.a(s),", ")+c
return r.charCodeAt(0)==0?r:r},
mj(a,b,c){var s,r
if(A.nb(a))return b+"..."+c
s=new A.bS(b)
B.b.m($.aN,a)
try{r=s
r.a=A.my(r.a,a,", ")}finally{if(0>=$.aN.length)return A.a($.aN,-1)
$.aN.pop()}s.a+=c
r=s.a
return r.charCodeAt(0)==0?r:r},
ud(a,b){var s,r,q,p,o,n,m,l=a.gI(a),k=0,j=0
for(;;){if(!(k<80||j<3))break
if(!l.u())return
s=A.r(l.gC())
B.b.m(b,s)
k+=s.length+2;++j}if(!l.u()){if(j<=5)return
if(0>=b.length)return A.a(b,-1)
r=b.pop()
if(0>=b.length)return A.a(b,-1)
q=b.pop()}else{p=l.gC();++j
if(!l.u()){if(j<=4){B.b.m(b,A.r(p))
return}r=A.r(p)
if(0>=b.length)return A.a(b,-1)
q=b.pop()
k+=r.length+2}else{o=l.gC();++j
for(;l.u();p=o,o=n){n=l.gC();++j
if(j>100){for(;;){if(!(k>75&&j>3))break
if(0>=b.length)return A.a(b,-1)
k-=b.pop().length+2;--j}B.b.m(b,"...")
return}}q=A.r(p)
r=A.r(o)
k+=r.length+q.length+4}}if(j>b.length+2){k+=5
m="..."}else m=null
for(;;){if(!(k>80&&b.length>3))break
if(0>=b.length)return A.a(b,-1)
k-=b.pop().length+2
if(m==null){k+=5
m="..."}}if(m!=null)B.b.m(b,m)
B.b.m(b,q)
B.b.m(b,r)},
ob(a,b,c,d,e){return new A.c2(a,b.h("@<0>").M(c).M(d).M(e).h("c2<1,2,3,4>"))},
iA(a,b,c,d){var s
if(B.G===c){s=J.as(a)
b=J.as(b)
return A.iO(A.br(A.br($.hp(),s),b))}if(B.G===d){s=J.as(a)
b=J.as(b)
c=J.as(c)
return A.iO(A.br(A.br(A.br($.hp(),s),b),c))}s=J.as(a)
b=J.as(b)
c=J.as(c)
d=J.as(d)
d=A.iO(A.br(A.br(A.br(A.br($.hp(),s),b),c),d))
return d},
rp(a){var s,r,q=$.hp()
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.O)(a),++r)q=A.br(q,J.as(a[r]))
return A.iO(q)},
f8:function f8(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h},
aF:function aF(a,b,c){this.a=a
this.b=b
this.c=c},
ig:function ig(){},
ih:function ih(){},
bG:function bG(a){this.a=a},
kf:function kf(){},
L:function L(){},
eU:function eU(a){this.a=a},
bs:function bs(){},
aQ:function aQ(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
bq:function bq(a,b,c,d,e,f){var _=this
_.e=a
_.f=b
_.a=c
_.b=d
_.c=e
_.d=f},
fe:function fe(a,b,c,d,e){var _=this
_.f=a
_.a=b
_.b=c
_.c=d
_.d=e},
e3:function e3(a){this.a=a},
fC:function fC(a){this.a=a},
bR:function bR(a){this.a=a},
f3:function f3(a){this.a=a},
fu:function fu(){},
dY:function dY(){},
kg:function kg(a){this.a=a},
ay:function ay(a,b,c){this.a=a
this.b=b
this.c=c},
h:function h(){},
a7:function a7(a,b,c){this.a=a
this.b=b
this.$ti=c},
W:function W(){},
m:function m(){},
hc:function hc(a){this.a=a},
cN:function cN(a){this.a=a},
fx:function fx(a){var _=this
_.a=a
_.c=_.b=0
_.d=-1},
bS:function bS(a){this.a=a},
rf(a){return a},
iy:function iy(a){this.a=a},
ae(a){var s
if(typeof a=="function")throw A.d(A.bd("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d){return b(c,d,arguments.length)}}(A.tD,a)
s[$.no()]=a
return s},
tD(a,b,c){t.Y.a(a)
if(A.H(c)>=1)return a.$1(b)
return a.$0()},
pB(a,b,c){return c.a(a[b])},
p8(a,b){return a[b]},
cy(a,b){var s=new A.x($.w,b.h("x<0>")),r=new A.cg(s,b.h("cg<0>"))
a.then(A.d7(new A.lW(r,b),1),A.d7(new A.lX(r),1))
return s},
lW:function lW(a,b){this.a=a
this.b=b},
lX:function lX(a){this.a=a},
ru(){return $.np()},
h0:function h0(a){this.a=a},
qS(a,b,c){return J.eR(a,b,c)},
al(a){var s=a.BYTES_PER_ELEMENT,r=A.bO(0,null,B.a.a2(a.byteLength,s))
return J.eR(B.c.gN(a),a.byteOffset+0*s,r*s)},
Q(a,b,c){var s=a.BYTES_PER_ELEMENT
c=A.bO(b,c,B.a.a2(a.byteLength,s))
return J.ak(B.c.gN(a),a.byteOffset+b*s,(c-b)*s)},
fa:function fa(){},
dd:function dd(a,b){this.a=a
this.b=b},
nI(a,b,c){var s=new A.bc(a,420,B.a.t(Date.now(),1000),b,!0)
s.at=c
return s},
bc:function bc(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.e=c
_.f=$
_.ax=_.at=_.Q=_.y=_.w=null
_.ay=d
_.ch=e},
be:function be(a,b){this.a=a
this.b=b},
kY(a,b,c,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=a.length
if(d<5)return new A.d_(0,c,a0)
s=d-5
for(d=a.$flags|0,r=0;r<=s;){if((a[r]&254)!==232){++r
continue}q=b+r
p=q-a0
if(p>5)c=0
else for(o=0;o<p;++o)c=(c&119)<<1&255
n=r+4
m=a[n]
l=m!==0
if(!l||m===255){k=c>>>1
k=(23>>>(k&7)&1)!==0&&k<16}else k=!1
if(k){l=r+3
k=r+2
j=r+1
i=(m<<24|a[l]<<16|a[k]<<8|a[j])>>>0
for(h=c>>>1,g=c===0,f=q+5,e=null;;){e=i-f>>>0
if(g)break
if(!(h<8))return A.a(B.af,h)
o=B.af[h]
m=B.a.b3(e,24-o*8)&255
if(!(m===0||m===255))break
if(!(o<4))return A.a(B.ab,o)
i=(e^B.ab[o])>>>0}if(typeof e!=="number")return e.aJ()
d&2&&A.b(a)
a[n]=~((e>>>24&1)-1)&255
a[l]=e>>>16&255
a[k]=e>>>8&255
a[j]=e&255
r+=5
c=0}else{c=(c|1)>>>0
if(!l||m===255)c=(c|16)>>>0;++r}a0=q}return new A.d_(r,c,a0)},
hZ:function hZ(a,b){this.a=a
this.b=b
this.c=0},
eX:function eX(a,b,c,d){var _=this
_.b=a
_.c=b
_.d=c
_.e=0
_.a=d},
i1:function i1(a){var _=this
_.a=a
_.d=_.c=0
_.e=!1},
i2:function i2(a){this.a=a
this.b=0
this.c=8},
dh:function dh(a,b,c,d){var _=this
_.z=$
_.Q=a
_.as=!1
_.a=b
_.b=c
_.c=d
_.e=_.d=0
_.f=!1
_.r=null
_.w=0},
nK(){return new A.hx()},
hx:function hx(){var _=this
_.ax=_.at=_.as=_.Q=_.z=_.y=_.x=_.w=_.r=_.f=_.e=_.d=_.c=_.b=_.a=$
_.ay=0
_.ch=-1
_.cx=_.CW=0
_.fr=_.dy=_.dx=_.db=_.cy=$
_.fx=0},
hz:function hz(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
hy:function hy(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
ma(){return new A.hA()},
hA:function hA(){var _=this
_.b=-1
_.d=_.c=$
_.e=0
_.k1=_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.CW=_.ch=_.ay=_.ax=_.at=_.as=_.Q=_.z=_.y=_.x=_.w=_.r=_.f=$},
hX:function hX(a,b,c){this.a=a
this.b=b
this.c=c},
hY:function hY(a,b,c){this.a=a
this.b=b
this.c=c},
hW:function hW(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
hN:function hN(a,b){this.a=a
this.b=b},
hL:function hL(a,b,c){this.a=a
this.b=b
this.c=c},
hO:function hO(){},
hK:function hK(){},
hM:function hM(){},
hJ:function hJ(a,b,c){this.a=a
this.b=b
this.c=c},
hG:function hG(a){this.a=a},
hE:function hE(a){this.a=a},
hF:function hF(a){this.a=a},
hI:function hI(a){this.a=a},
hH:function hH(){},
hC:function hC(a,b,c){this.a=a
this.b=b
this.c=c},
hB:function hB(){},
hD:function hD(a){this.a=a},
hV:function hV(a){this.a=a},
hT:function hT(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
hP:function hP(){},
hU:function hU(a){this.a=a},
hQ:function hQ(){},
hR:function hR(a,b){this.a=a
this.b=b},
hS:function hS(a,b,c){this.a=a
this.b=b
this.c=c},
o9(){var s,r=new Uint8Array(0),q=t.gK,p=A.i([],q)
q=A.i([],q)
s=A.bM(768)
r=new A.is(new A.iE(r),p,q,s,B.a1,new Uint8Array(0))
r.ir()
return r},
oa(a,b){var s=a.gi(a),r=s<b?s:b,q=new Uint8Array(r),p=a.az(q,0,r)
return p===r?q:A.Q(q,0,p)},
is:function is(a,b,c,d,e,f){var _=this
_.a=a
_.b=2
_.c=0
_.d=3
_.e=5
_.f=0
_.r=b
_.x=_.w=$
_.y=c
_.Q=_.z=$
_.as=d
_.ay=_.ax=_.at=$
_.cy=_.cx=_.CW=_.ch=0
_.db=e
_.dx=f
_.fx=_.fr=_.dy=0
_.fy=!1
_.id=_.go=0},
aw:function aw(a,b){this.a=a
this.b=b},
h3:function h3(a,b){this.a=a
this.b=b},
ke:function ke(a,b){this.a=a
this.b=b},
bM(a){var s=new Uint16Array(a)
B.j.F(s,0,a,1024)
return new A.cM(s)},
cM:function cM(a){this.a=a},
iE:function iE(a){var _=this
_.a=4294967295
_.b=0
_.c=a
_.e=_.d=0},
ne(a){var s,r=A.i([],t.t)
for(s=a;s>=128;){B.b.m(r,s&127|128)
s=B.a.t(s,128)}B.b.m(r,s)
return new Uint8Array(A.N(r))},
e5:function e5(a,b,c,d,e,f){var _=this
_.z=$
_.as=_.Q=!1
_.ch=_.ay=_.ax=_.at=0
_.CW=a
_.cx=b
_.cy=c
_.a=d
_.b=e
_.c=f
_.e=_.d=0
_.f=!1
_.r=null
_.w=0},
h5:function h5(a,b){this.a=a
this.b=b},
iW:function iW(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=0
_.e=c
_.f=0
_.r=null
_.w=d
_.y=_.x=!0
_.Q=_.z=null
_.as=0
_.at=!1
_.ax=0
_.ay=e},
hg:function hg(a,b){this.a=a
this.b=b},
iZ:function iZ(a,b,c,d,e,f,g){var _=this
_.b=a
_.c=b
_.d=c
_.e=d
_.w=_.r=_.f=0
_.x=e
_.y=f
_.a=g},
rD(a,b){var s=null,r=a==null,q=r?"Invalid XZ archive":"Invalid XZ archive: "+a
if(!r&&B.e.bF(a,"LZMA dictionary size "))return new A.de(q,s,s)
r=B.cf.a9(0,a)
return r?new A.c0(q,s,s):new A.aP(q,s,s)},
iT:function iT(a,b){this.a=a
this.b=b},
iV:function iV(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
iU:function iU(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
pN(a){var s,r,q,p="Invalid dictionary size "
if(a===0)throw A.d(A.p(p+a))
if(a===4294967295)return 40
s=a
r=0
for(;;){q=s&1
if(!(q===0&&s>3))break
s=s>>>1;++r}if(s!==2&&s!==3||r<11||r>30)throw A.d(A.p(p+a))
return(r-11<<1|q)>>>0},
iS:function iS(a,b){this.a=a
this.b=b},
fH:function fH(){},
eF:function eF(a,b){this.a=a
this.b=b},
j8:function j8(a){var _=this
_.a=-1
_.r=_.f=_.e=0
_.x=a},
w0(a,b){var s=b*1032,r=a<s?a:s
if(r<=0)return null
return r<524288e3?r:524288e3},
rJ(a){var s,r,q,p,o,n
if(a==null)return!1
for(s=a.length,r=0;r+4<=s;){if(!(r>=0&&r<s))return A.a(a,r)
q=a[r]
p=r+1
if(!(p<s))return A.a(a,p)
p=a[p]
o=r+2
if(!(o<s))return A.a(a,o)
o=a[o]
n=r+3
if(!(n<s))return A.a(a,n)
n=a[n]
if((q|p<<8)>>>0===1)return!0
r+=4+((o|n<<8)>>>0)}return!1},
ji(a){return a.length<B.a.k(J.qA(B.c.gN(a)),1)?new Uint8Array(A.N(a)):a},
rI(a){var s,r,q,p
if(a instanceof A.a6)return A.I(a.B(),0)
s=a.d1(a.gA())
r=new Uint8Array(1048576)
for(q=0;;){p=s.az(r,0,1048576)
if(p<=0)return q
q=A.I(A.Q(r,0,p),q)}},
j5:function j5(a,b,c){this.a=a
this.c=b
this.d=c},
e7:function e7(a,b){this.a=a
this.b=b},
bT:function bT(a,b,c,d){var _=this
_.b=0
_.c=a
_.w=_.r=_.f=_.e=_.d=0
_.x=""
_.y=null
_.z=b
_.as=_.Q=!1
_.ax=_.at=null
_.ch=c
_.cx=_.CW=null
_.cy=d
_.db=!1},
jm:function jm(a,b){this.a=a
this.b=b},
jl:function jl(a,b){this.a=a
this.b=b},
jk:function jk(a){this.a=a},
je:function je(a){this.a=a},
jf:function jf(){},
jg:function jg(a){this.a=a},
jh:function jh(a,b,c){this.a=a
this.b=b
this.c=c},
jn:function jn(a,b,c){this.a=a
this.b=b
this.c=c},
jj:function jj(a){this.a=a},
eg:function eg(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=!1},
fU:function fU(a){this.a=a
this.b=0},
e8:function e8(){var _=this
_.as=_.Q=_.y=_.x=_.w=_.r=_.f=_.e=_.c=_.a=0
_.at=""
_.CW=_.ch=_.ax=null},
jd:function jd(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
ps(a){var s,r,q,p,o,n
if(a==null)return null
s=A.al(a)
for(r=a.length,q=0;p=q+4,p<=r;){o=s.getUint16(q,!0)
n=s.getUint16(q+2,!0)
if(o===21589&&n>=5&&q+9<=r){if(!(p>=0&&p<r))return A.a(a,p)
return(a[p]&1)!==0?s.getUint32(q+5,!0):null}q+=4+n}return null},
j6:function j6(){this.a=$},
j7:function j7(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g},
p1(a){var s
if(A.ca(a)<1980)s=A.mc(1980,1,1,0,0,0)
else s=A.ca(a)>2107?A.mc(2107,12,31,23,59,58):a
return s},
p9(a){var s
if(a==null)return null
s=A.p1(a)
return((A.mr(s)<<3|A.iC(s)>>>3)&255)<<8|((A.iC(s)&7)<<5|A.ms(s)/2|0)&255},
p7(a){var s
if(a==null)return null
s=A.p1(a)
return(((A.ca(s)-1980&127)<<1|A.iD(s)>>>3)&255)<<8|((A.iD(s)&7)<<5|A.mq(s))&255},
mA(a){return A.a8(a>=0&&a<32768?a+64:null)},
oq(a,b,c,d){var s=b.b,r=c.y==null?0:18,q=a.gA(),p=c.y
if(p==null)p=null
else p=new A.fM(b,p,new Uint8Array(16384),B.d)
return new A.jc(a,b,c,d,s-r,q,p)},
fT:function fT(){this.a=0},
eG:function eG(a){var _=this
_.a=$
_.r=_.f=_.e=_.d=_.c=_.b=0
_.y=_.x=_.w=null
_.z=6
_.as=_.Q=!1
_.at=a
_.ax=null
_.ay=1
_.ch=!1
_.CW=0
_.cx=""
_.dx=_.db=_.cy=0
_.dy=!0
_.fr=!1},
kP:function kP(a,b){var _=this
_.a=a
_.d=_.c=_.b=$
_.e=b},
j9:function j9(){var _=this
_.a=$
_.c=_.b=null
_.e=$
_.x=_.w=null},
jb:function jb(a,b,c){this.a=a
this.b=b
this.c=c},
ja:function ja(){},
jc:function jc(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=$
_.x=0
_.y=$
_.z=null
_.Q=!1
_.as=null},
fS:function fS(a,b,c){var _=this
_.b=a
_.d=_.c=0
_.e=b
_.a=c},
fM:function fM(a,b,c,d){var _=this
_.b=a
_.c=b
_.d=c
_.f=_.e=0
_.a=d},
mh(a,b){var s=new A.il()
s.iq(a,b)
return s},
il:function il(){this.a=$
this.b=0
this.c=2147483647},
vD(a){var s
if(a>=0&&a<8192)s=a<16?64:a*4
else s=null
return s},
j2:function j2(){},
kM:function kM(){},
kN:function kN(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
j4:function j4(){},
cR:function cR(a){this.a=a
this.c=this.b=0},
kO:function kO(){},
nT(a,b,c,d,e){var s=A.mI(),r=A.mI(),q=A.mI(),p=new Uint16Array(16),o=new Uint32Array(573),n=new Uint8Array(573)
s=new A.ii(a,d,s,r,q,p,o,n)
s.jA(c,b,e)
s.j4(B.L)
return s},
nU(a,b,c,d){var s,r=b*2,q=a.length
if(!(r>=0&&r<q))return A.a(a,r)
r=a[r]
s=c*2
if(!(s>=0&&s<q))return A.a(a,s)
s=a[s]
if(r>=s)if(r===s){if(!(b>=0&&b<573))return A.a(d,b)
r=d[b]
if(!(c>=0&&c<573))return A.a(d,c)
r=r<=d[c]}else r=!1
else r=!0
return r},
mI(){return new A.ks()},
t1(a,b,c){var s,r,q,p,o,n,m,l=new Uint16Array(16)
for(s=0,r=1;r<=15;++r){s=s+c[r-1]<<1>>>0
if(!(r<16))return A.a(l,r)
l[r]=s}for(q=a.length,p=0;p<=b;++p){o=p*2
n=o+1
if(!(n<q))return A.a(a,n)
m=a[n]
if(m===0)continue
if(!(m<16))return A.a(l,m)
n=l[m]
if(!(m<16))return A.a(l,m)
l[m]=n+1
n=A.t2(n,m)
a.$flags&2&&A.b(a)
if(!(o<q))return A.a(a,o)
a[o]=n}},
t2(a,b){var s,r=0
do{s=A.aB(a,1)
r=(r|a&1)<<1>>>0
if(--b,b>0){a=s
continue}else break}while(!0)
return A.aB(r,1)},
oE(a){var s,r
if(a<256){s=$.ns()
if(!(a>=0&&a<s.length))return A.a(s,a)
s=s[a]}else{s=$.ns()
r=256+A.aB(a,7)
if(!(r<s.length))return A.a(s,r)
r=s[r]
s=r}return s},
mK(a,b,c,d,e){return new A.kC(a,b,c,d,e)},
aB(a,b){if(a>=0)return B.a.aJ(a,b)
else return B.a.aJ(a,b)+B.a.q(2,(~b>>>0)+65536&65535)},
cX:function cX(a,b){this.a=a
this.b=b},
ii:function ii(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=b
_.c=null
_.e=_.d=0
_.x=_.w=_.r=_.f=$
_.y=2
_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.CW=_.ch=_.ay=_.ax=_.at=_.as=_.Q=$
_.k1=0
_.p3=_.p2=_.p1=_.ok=_.k4=_.k3=_.k2=$
_.p4=c
_.R8=d
_.RG=e
_.rx=f
_.ry=g
_.x1=_.to=$
_.x2=h
_.aw=_.av=_.c2=_.cH=_.by=_.aN=_.cG=_.y2=_.y1=_.xr=$},
aU:function aU(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
ks:function ks(){this.c=this.b=this.a=$},
kC:function kC(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
im:function im(a,b,c){var _=this
_.a=a
_.b=null
_.c=b
_.d=null
_.e=c
_.f=!1
_.w=_.r=0},
e6:function e6(){},
j3:function j3(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
e9:function e9(a){var _=this
_.c=_.b=_.a=0
_.d=a
_.f=_.e=0
_.r=!1
_.w=32},
rU(a,b,c,d,e){var s,r,q,p,o,n,m,l,k
for(s=a.length,r=a.$flags|0,q=b,p=c,o=d;o>0;){n=e-p
n=n<o?n:o
for(m=0;m<n;++m){l=q+m
k=p+m
if(!(k>=0&&k<s))return A.a(a,k)
k=a[k]
r&2&&A.b(a)
if(!(l>=0&&l<s))return A.a(a,l)
a[l]=k}q+=n
p+=n
o-=n
if(p===e)p=0}return q},
oC(a,b,c,d){var s,r,q
a.$flags&2&&A.b(a,11)
s=d
r=c
q=b
do{a.setUint32(q,a.getUint32(r,!0),!0)
a.setUint32(q+4,a.getUint32(r+4,!0),!0)
q+=8
r+=8
s-=8}while(s>0)},
fL:function fL(a,b,c,d,e,f,g,h,i,j,k){var _=this
_.x=a
_.y=b
_.z=c
_.Q=d
_.ay=_.ax=_.at=_.as=0
_.ch=e
_.a=f
_.b=g
_.c=h
_.d=i
_.e=j
_.f=k
_.w=_.r=$},
ea:function ea(a,b){var _=this
_.a=a
_.d=_.c=_.b=0
_.e=b},
ec(a){return new A.jt(a,null,null)},
tx(){return A.j(A.ec("Block header is truncated"))},
uy(){return A.j(A.ec("Raw block is truncated"))},
uG(){return A.j(A.ec("RLE block byte is missing"))},
tF(){return A.j(A.ec("Compressed block is truncated"))},
uF(){return A.j(A.ec("Reserved block type"))},
tz(a){return A.j(A.ec("Block of "+a+" bytes exceeds the block limit"))},
jt:function jt(a,b,c){this.a=a
this.b=b
this.c=c},
jr:function jr(a,b){this.a=a
this.b=b
this.c=!1},
or(d0,d1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5=d1.b,c6=A.rQ(d1.x,c5),c7=A.ov(),c8=A.ov(),c9=new Uint32Array(256)
c9=new A.jQ(c7,c8,c9,new Uint32Array(1024))
s=new Uint32Array(198)
r=new Uint32Array(3)
q=new Uint32Array(3)
p=new Uint32Array(3)
if(c6==null)o=null
else{o=B.a.a2(d0,c6.a)+1
n=new Uint32Array(o)
m=new Uint32Array(o)
o=new A.jN(n,m,new Uint32Array(o))}n=A.oz(d1)?B.a.q(1,d1.c):8
n=new Uint8Array(n)
m=$.dc()===B.B?0:7
l=new Uint32Array(4096)
k=new Uint32Array(4096)
j=new Uint32Array(3)
i=new Uint32Array(3)
h=new Int32Array(4099)
g=new Uint32Array(4099)
f=new Uint32Array(4099)
e=new Uint32Array(4099)
d=new Uint32Array(12297)
c=new Uint32Array(256)
b=new Uint32Array(36)
a=new Uint32Array(53)
a0=new Uint32Array(32)
a1=new Uint32Array(256)
a2=new Uint32Array(36)
a3=new Uint32Array(53)
a4=new Uint32Array(32)
a5=J.ht(B.c.gN(n))
a6=d1.a
a7=a6<2||a6>=4||A.jU(d1)?B.a.q(1,d1.c):1
a7=new Uint32Array(a7)
a8=a6===1||a6>=4||A.jU(d1)?B.a.p(1,d1.d):1
a8=new Uint32Array(a8)
a9=a6>=4
b0=a9?B.a.p(1,d1.d-1)-1:0
if(a9)a9=2
else a9=A.jU(d1)?1:0
b1=c5<17
b2=b1?c5:17
b3=d1.w
b4=b3===3
if(b4){b5=B.a.q(1,b1?c5:17)
b1=b5}else b1=1
b1=new Uint32Array(b1)
b5=b4?3:4
b6=A.rS(d1)
b7=d1.c
if(b3<4)b3=4
b8=A.cU(d1)
b9=B.a.q(1,A.cU(d1))
c0=B.a.q(1,A.cU(d1))
c1=B.a.q(1,B.a.q(1,A.cU(d1)))
c2=B.a.p(1,A.cU(d1)-3)
c3=A.cU(d1)
c4=A.oz(d1)?B.a.q(1,b7):1
n=new A.jS(d1,a7,a8,b6,64-b7,b3,b8,b9,c0-1,c1-1,c2,56-b7+c3,b0,a9,b5,b2,b1,new Uint32Array(c4),n,a5,m,l,k,j,i,h,g,f,e,d,new A.jW(c,b,a,a0,a1,a2,a3,a4),new A.jV())
m=b4?3:4
l=new Uint8Array(d0+32)
m=m===3?3:4
A.al(l)
m=B.a.a2(d0,m)
m=new Uint32Array((m+2)*4)
k=new Uint32Array(64)
j=new Uint32Array(32)
i=new Uint32Array(64)
h=new Int16Array(53)
g=new Uint8Array(512)
f=new Uint16Array(53)
e=new Uint32Array(54)
k=new A.k_(k,j,i,h,g,f,e,new Uint8Array(512),new A.ey(A.cS(9,36),A.cS(9,36)),new A.ey(A.cS(8,32),A.cS(8,32)),new A.ey(A.cS(9,53),A.cS(9,53)))
j=B.a.k(d0,1)
j=new Uint8Array(d0+j+1024)
i=a6===5
c5=i&&c5>=17
h=A.pP(d1)
k.Q=a6
c9.w=A.w3(d1)
c9.x=a6===0&&d1.f>0
c9.Q=A.pP(d1)
c9.as=a6<3
c8.c=c7.c=i&&d1.r>=2
n.a0()
return new A.js(c9,n,new A.jY(l,m),k,new A.jX(s),j,c6,o,c5,r,q,p,h,null)},
eb(a,b,c,d){var s=b?1:0,r=s|c<<1|d<<3
a.j(r&255)
a.j(r>>>8&255)
a.j(r>>>16&255)},
rK(a,b,c){var s,r,q=a.length
if(!(b>=0&&b<q))return A.a(a,b)
s=a[b]
for(r=b+1;r<c;++r){if(!(r<q))return A.a(a,r)
if(a[r]!==s)return!1}return!0},
js:function js(a,b,c,d,e,f,g,h,i,j,k,l,m,n){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i
_.y=j
_.z=k
_.Q=l
_.as=m
_.at=!0
_.ax=n},
os(){var s=new Uint32Array(1024),r=new Uint32Array(1024)
return new A.ju(s,r,new Uint32Array(1024))},
ju:function ju(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.e=_.d=0},
ed:function ed(a,b,c,d,e,f,g,h){var _=this
_.y=a
_.as=b
_.cx=_.CW=_.ch=_.ay=_.ax=_.at=$
_.cy=c
_.db=d
_.dx=e
_.dy=$
_.go=_.fy=_.fx=_.fr=0
_.id=!1
_.k1=0
_.k2=$
_.k3=!1
_.a=f
_.b=g
_.c=h
_.e=_.d=0
_.f=!1
_.r=null
_.w=0},
mB:function mB(a,b,c,d,e,f,g,h,i,j){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i
_.y=j},
ap(a){return new A.jA(a,null,null)},
uv(a){var s,r
for(s=1,r=0;r<a;++r)s*=2
return s},
vO(a,b,c,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d
if(b>=c)throw A.d(A.ap("Frame header is missing"))
s=a.length
if(!(b<s))return A.a(a,b)
r=a[b]
if((r&8)!==0)throw A.d(A.ap("Reserved bit is set in the frame header"))
q=b+1
p=(r&32)===0
o=!p
if(p){if(q>=c)throw A.d(A.ap("Window descriptor is missing"))
if(!(q<s))return A.a(a,q)
n=a[q];++q
m=A.uv(10+(n>>>3))
l=m+B.a.t(m,8)*(n&7)}else l=0
k=B.V[r&3]
j=q+k
if(j>c)throw A.d(A.ap("Dictionary id is truncated"))
for(i=0,h=0;h<k;++h){p=q+h
if(!(p<s))return A.a(a,p)
i=(i|B.a.q(a[p],h<<3>>>0))>>>0}g=r>>>6
if(g===0)f=o?1:0
else f=B.a.q(1,g)
q=j+f
if(q>c)throw A.d(A.ap("Frame content size is truncated"))
if(f>0){for(h=f-1,e=0;h>=0;--h){if(e>35184372088832)throw A.d(A.ap("Frame content size is too large to decode"))
p=j+h
if(!(p<s))return A.a(a,p)
e=e*256+a[p]}if(f===2)e+=256
d=e}else{q=j
d=null}if(o){d.toString
l=d}if(l>a0)throw A.d(A.hw("Window of "+l+" bytes is above the "+a0+" limit"))
return new A.jB(q-b,l,d,i,(r&4)!==0)},
rL(a,b){var s=b.c
if(s!=null&&a!==s)throw A.d(A.ap("Frame produced "+a+" bytes against the "+A.r(s)+" it declared"))},
mC(a,b,c,d,e){if(d===0)return
if(a.gi(a)<d)throw A.d(A.ap(e))
if(a.az(b,c,d)<d)throw A.d(A.ap(e))},
jA:function jA(a,b,c){this.a=a
this.b=b
this.c=c},
jB:function jB(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
jy:function jy(a,b,c){this.a=a
this.b=b
this.c=c},
ou(a,b,c,d,e,f){var s,r,q,p,o,n,m,l
if(c&&b<256)s=0
else if(b>=256&&b<65792)s=1
else s=b<4294967295?2:3
if(f===0)r=0
else if(f<256)r=1
else{q=f<65536?2:3
r=q}a.j(40)
a.j(181)
a.j(47)
a.j(253)
q=c?32:0
p=d?4:0
a.j((s<<6|q|p|r)>>>0)
if(!c)a.j(e-10<<3>>>0)
o=B.V[r]
for(n=0;n<o;++n)a.j(B.a.bb(f,n<<3>>>0)&255)
m=s===1?b-256:b
l=s===0?1:B.a.q(1,s)
for(n=0;n<l;++n){a.j(B.a.E(m,256))
m=B.a.t(m,256)}},
jz:function jz(a,b,c){this.a=a
this.b=b
this.c=c},
cT(a){return new A.jF(a,null,null)},
pJ(a0,a1,a2,a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a
if(a1>=a2)A.v0()
for(s=a3.$flags|0,r=a4;r>=0;--r){s&2&&A.b(a3)
if(!(r<a3.length))return A.a(a3,r)
a3[r]=0}q=A.al(a0)
if(!(a1<a0.length))return A.a(a0,a1)
p=(a0[a1]&15)+5
if(p>a5)A.tr(p,a5)
o=B.a.q(1,p)
n=o+1
m=p+1
s=a4+1
l=o
k=4
j=0
i=!1
for(;;){if(!(n>1&&j<=a4))break
if(i){for(h=0,g=3;g===3;){g=A.n_(q,a1,a2,k,2)
k+=2
h+=g}j+=h
if(j>s)A.vh()
if(j>a4)break}f=(l<<1>>>0)-1-n
e=m-1
d=A.n_(q,a1,a2,k,e)
if(d<f){k+=e
c=d}else{c=A.n_(q,a1,a2,k,m)
if(c>=l)c-=f
k+=m}b=c-1
n-=b<0?-b:b
if(n<0)A.ux()
a3.$flags&2&&A.b(a3)
if(!(j>=0&&j<a3.length))return A.a(a3,j)
a3[j]=b;++j
i=b===0
if(n<l){if(n<=1)break
m=B.a.gX(n)-1+1
l=B.a.p(1,m-1)}}if(n!==1)A.uw()
a=B.a.k(k+7,3)
if(a1+a>a2)A.v1()
return new A.jD(a3,j-1,p,a)},
vp(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k,j=B.a.q(1,d)
a.b=d
s=a.a
r=$.nz()
A.nj(b,c,j,e,f)
for(q=f.$flags|0,p=s.$flags|0,o=0;o<j;++o){if(!(o<64))return A.a(e,o)
n=e[o]
if(!(n<256))return A.a(f,n)
m=f[n]
q&2&&A.b(f)
if(!(n<256))return A.a(f,n)
f[n]=m+1
if(!(m>=0&&m<2048))return A.a(r,m)
l=d-r[m]
k=B.a.p(m,l)
p&2&&A.b(s)
if(!(o<s.length))return A.a(s,o)
s[o]=(n|l<<8|k-j<<16)>>>0}},
n_(a,b,c,d,e){var s,r,q,p
if(e===0)return 0
s=b+B.a.k(d,3)
if(s+4<=c)r=a.getUint32(s,!0)
else for(r=0,q=0;q<4;++q){p=s+q
if(p<c)r|=B.a.q(a.getUint8(p),q<<3>>>0)}return(r>>>(d&7)&B.a.p(1,e)-1)>>>0},
nj(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j=c-1
for(s=e.$flags|0,r=a.length,q=d.$flags|0,p=j,o=0;o<=b;++o){if(!(o<r))return A.a(a,o)
n=a[o]
if(n===-1){q&2&&A.b(d)
if(!(p>=0&&p<d.length))return A.a(d,p)
d[p]=o;--p
s&2&&A.b(e)
if(!(o<e.length))return A.a(e,o)
e[o]=1}else{s&2&&A.b(e)
if(!(o<e.length))return A.a(e,o)
e[o]=n}}m=(c>>>1)+(c>>>3)+3
for(l=0,o=0;o<=b;++o){if(!(o<r))return A.a(a,o)
n=a[o]
for(k=0;k<n;++k){q&2&&A.b(d)
if(!(l>=0&&l<d.length))return A.a(d,l)
d[l]=o
do l=(l+m&j)>>>0
while(l>p)}}if(l!==0)A.v3()},
v0(){return A.j(A.cT("Table description is empty"))},
vh(){return A.j(A.cT("Zero run runs past the last symbol"))},
ux(){return A.j(A.cT("Probabilities overshoot the table size"))},
uw(){return A.j(A.cT("Probabilities do not add up to the table size"))},
v1(){return A.j(A.cT("Table description is truncated"))},
v3(){return A.j(A.cT("Table spread did not return to its start"))},
tr(a,b){return A.j(A.cT("Accuracy log "+a+" exceeds the "+b+" allowed here"))},
jG:function jG(a){this.a=a
this.b=0},
jD:function jD(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
jF:function jF(a,b,c){this.a=a
this.b=b
this.c=c},
mD(a){return new A.jE(a,null,null)},
nh(a,b,c){var s,r,q,p
if(b<=1)return 5
s=B.a.gX(b-1)-1-2
r=s>=0&&s<a?s:a
s=B.a.gX(b)-1+1
q=B.a.gX(c)-1+2
p=s<q?s:q
if(p>r)r=p
if(r<5)r=5
return r>a?a:r},
ng(a1,a2,a3,a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=a6?-1:1,a0=B.a.aJ(a3,a5)
B.a.a2(0,a3)
B.a.p(1,62-a5-20)
s=B.a.p(1,20-a5)
r=new A.fK(a5,s)
r.fe(1048576,0,0,a3)
q=B.a.p(1,a5)
for(p=t.L,o=a2.length,n=21-a5,m=q,l=0,k=0,j=0;j<=a4;++j){if(!(j<o))return A.a(a2,j)
i=a2[j]
if(i===a3)return!1
if(i===0){a1.$flags&2&&A.b(a1)
if(!(j<a1.length))return A.a(a1,j)
a1[j]=0
continue}if(i<=a0){a1.$flags&2&&A.b(a1)
if(!(j<a1.length))return A.a(a1,j)
a1[j]=a;--m
continue}p.a(B.N)
r.fH(i)
h=r.f
g=B.a.a2(h,s)
if(g<8){f=h-g*s
if(!(g>=0&&g<B.N.length))return A.a(B.N,g)
e=B.N[g]
d=B.a.b3(e,a5)
c=B.a.p(e&q-1,n)
h=!0
if(f<=d)if(f===d){b=r.r
if(b<=c)h=b===c&&r.w!==0}else h=!1
if(h)++g}if(g>k){k=g
l=j}a1.$flags&2&&A.b(a1)
if(!(j<a1.length))return A.a(a1,j)
a1[j]=g
m-=g}if(!(l>=0&&l<a1.length))return A.a(a1,l)
s=a1[l]
if(-m>=B.a.k(s,1))A.uU(a1,a2,a3,a4,a5,a)
else{a1.$flags&2&&A.b(a1)
a1[l]=s+m}return!0},
uU(a2,a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=2097152,a0=B.a.aJ(a4,a6),a1=B.a.aJ(a4*3,a6+1)
for(s=a2.$flags|0,r=a3.length,q=a4,p=0,o=0;o<=a5;++o){if(!(o<r))return A.a(a3,o)
n=a3[o]
if(n===0){s&2&&A.b(a2)
if(!(o<a2.length))return A.a(a2,o)
a2[o]=0}else if(n<=a0){s&2&&A.b(a2)
if(!(o<a2.length))return A.a(a2,o)
a2[o]=a7;++p
q-=n}else if(n<=a1){s&2&&A.b(a2)
if(!(o<a2.length))return A.a(a2,o)
a2[o]=1;++p
q-=n}else{s&2&&A.b(a2)
if(!(o<a2.length))return A.a(a2,o)
a2[o]=-2}}m=B.a.p(1,a6)
l=m-p
if(l===0)return
if(B.a.a2(q,l)>a1){a1=B.a.a2(q*3,l*2)
for(k=a2.length,o=0;o<=a5;++o){if(!(o<k))return A.a(a2,o)
if(a2[o]===-2){if(!(o<r))return A.a(a3,o)
j=a3[o]<=a1}else j=!1
if(j){s&2&&A.b(a2)
a2[o]=1;++p
if(!(o<r))return A.a(a3,o)
q-=a3[o]}}l=m-p}m=a5+1
if(p===m){for(i=0,h=0,o=0;o<=a5;++o){if(!(o<r))return A.a(a3,o)
g=a3[o]
if(g>h){h=g
i=o}}if(!(i>=0&&i<a2.length))return A.a(a2,i)
r=a2[i]
s&2&&A.b(a2)
a2[i]=r+l
return}if(q===0){for(r=a2.length,o=0;l>0;){if(!(o>=0&&o<r))return A.a(a2,o)
k=a2[o]
if(k>0){--l
s&2&&A.b(a2)
a2[o]=k+1}o=B.a.E(o+1,m)}return}s=B.a.p(1,20-a6)
f=new A.fK(a6,s)
m=(s>>>1)-1
f.x=m
f.z=f.y=2097151
f.fe(l*s+m,2097151,2097151,q)
for(m=a2.length,o=0;o<=a5;++o){if(!(o<m))return A.a(a2,o)
if(a2[o]===-2){if(!(o<r))return A.a(a3,o)
k=a3[o]
e=B.a.a2(f.x,s)
f.fH(k)
d=f.z+f.w
c=f.y+f.r+B.a.t(d,a)
f.z=B.a.E(d,a)
f.y=B.a.E(c,a)
k=f.x+(f.f+B.a.t(c,a))
f.x=k
b=B.a.a2(k,s)-e
if(b<1)throw A.d(A.mD("Accuracy of "+a6+" is too small for "+a5+" symbols"))
a2.$flags&2&&A.b(a2)
a2[o]=b}}return},
lZ(a,a0,a1,a2,a3){var s,r,q,p,o,n,m,l=B.a.p(1,a3),k=a3-5,j=l+1,i=a3+1,h=a1.length,g=a.$flags|0,f=a0,e=l,d=4,c=0,b=!1
for(;;){if(!(c<=a2&&j>1))break
if(b){s=c
for(;;){if(s<=a2){if(!(s>=0&&s<h))return A.a(a1,s)
r=a1[s]===0}else r=!1
if(!r)break;++s}if(s>a2)break
for(q=c;p=q+24,s>=p;q=p){k|=B.a.p(65535,d)
o=f+1
g&2&&A.b(a)
r=a.length
if(!(f>=0&&f<r))return A.a(a,f)
a[f]=k&255
f=o+1
if(!(o>=0&&o<r))return A.a(a,o)
a[o]=k>>>8&255
k=k>>>16}for(;p=q+3,s>=p;q=p){k|=B.a.p(3,d)
d+=2}k|=B.a.p(s-q,d)
d+=2
if(d>16){o=f+1
g&2&&A.b(a)
r=a.length
if(!(f>=0&&f<r))return A.a(a,f)
a[f]=k&255
f=o+1
if(!(o>=0&&o<r))return A.a(a,o)
a[o]=k>>>8&255
k=k>>>16
d-=16}c=s}s=c+1
if(!(c>=0&&c<h))return A.a(a1,c)
n=a1[c]
m=(e<<1>>>0)-1-j
j-=n<0?-n:n;++n
if(n>=e)n+=m
k=(k|B.a.p(n,d))>>>0
d+=i
if(n<m)--d
b=n===1
if(j<1)throw A.d(A.mD("Probabilities overshoot the table size"))
while(j<e){--i
e=e>>>1}if(d>16){o=f+1
g&2&&A.b(a)
r=a.length
if(!(f>=0&&f<r))return A.a(a,f)
a[f]=k&255
f=o+1
if(!(o>=0&&o<r))return A.a(a,o)
a[o]=k>>>8&255
k=k>>>16
d-=16}c=s}if(j!==1)throw A.d(A.mD("Probabilities do not add up to the table"))
g&2&&A.b(a)
h=a.length
if(!(f>=0&&f<h))return A.a(a,f)
a[f]=k&255
g=f+1
r=B.a.k(k,8)
if(!(g<h))return A.a(a,g)
a[g]=r&255
return f+B.a.k(d+7,3)-a0},
cS(a,b){var s=B.a.p(1,a)
s=new Uint16Array(s)
return new A.jC(s,new Int32Array(b*2))},
jE:function jE(a,b,c){this.a=a
this.b=b
this.c=c},
jC:function jC(a,b){var _=this
_.a=a
_.b=b
_.c=0
_.d=-1},
ag(a){return new A.jJ(a,null,null)},
rM(){var s=new Uint8Array(256),r=new Int16Array(256),q=new Uint8Array(64),p=new Uint16Array(256),o=new Uint32Array(13),n=new Uint32Array(64)
return new A.jK(s,r,q,p,o,new A.jG(n),new A.e9(new DataView(new ArrayBuffer(0))))},
vP(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i
if(b>=c)A.v5()
s=a.length
if(!(b<s))return A.a(a,b)
r=a[b]
q=e.a
if(r>=128){p=r-127
o=B.a.k(p+1,1)
n=b+1
if(n+o>c)A.tO()
for(m=q.$flags|0,l=0;l<p;l+=2){k=n+(l>>>1)
if(!(k<s))return A.a(a,k)
j=a[k]
m&2&&A.b(q)
if(!(l<256))return A.a(q,l)
q[l]=j>>>4
k=l+1
if(k<p){if(!(k<256))return A.a(q,k)
q[k]=j&15}}i=1+o}else{s=b+1
if(s+r>c)A.tG()
p=A.uA(a,s,r,q,e)
i=1+r}A.tA(d,q,p,e.e)
return i},
uA(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j=A.pJ(a,b,b+c,e.b,255,6),i=e.f
A.vp(i,j.a,j.b,j.c,e.c,e.d)
s=e.r
r=j.d
if(!s.cY(a,b+r,c-r))A.v9()
q=i.a
p=i.b
o=s.aX(p)
n=s.aX(p)
if(s.r||s.b>s.w)A.va()
for(i=q.length,m=0;;){if(m+2>=256)A.pr()
if(!(o>=0&&o<i))return A.a(q,o)
l=q[o]
k=m+1
d.$flags&2&&A.b(d)
if(!(m<256))return A.a(d,m)
d[m]=l&255
o=(l>>>16)+s.aX(l>>>8&255)
s.es()
if(s.r||s.b>s.w){if(!(n>=0&&n<i))return A.a(q,n)
l=q[n]
m=k+1
d.$flags&2&&A.b(d)
if(!(k<256))return A.a(d,k)
d[k]=l&255
break}if(k+2>=256)A.pr()
if(!(n>=0&&n<i))return A.a(q,n)
l=q[n]
m=k+1
d.$flags&2&&A.b(d)
if(!(k<256))return A.a(d,k)
d[k]=l&255
n=(l>>>16)+s.aX(l>>>8&255)
s.es()
if(s.r||s.b>s.w){if(!(o<i))return A.a(q,o)
l=q[o]
k=m+1
d.$flags&2&&A.b(d)
if(!(m<256))return A.a(d,m)
d[m]=l&255
m=k
break}}return m},
tA(a,a0,a1,a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b
if(a1<1||a1>=256)A.vb(a1)
for(s=0,r=0;r<a1;++r){if(!(r<256))return A.a(a0,r)
q=a0[r]
if(q>11)A.vd(q)
if(q>0)s+=B.a.p(1,q-1)}if(s===0)A.tQ()
p=B.a.gX(s)-1+1
if(p>11)A.v2(p)
o=B.a.p(1,p)
n=o-s
if(n<=0||(n&n-1)>>>0!==0)A.ve()
m=B.a.gX(n)
a0.$flags&2&&A.b(a0)
if(!(a1>=0&&a1<256))return A.a(a0,a1)
a0[a1]=m-1+1
l=a.c=a1+1
for(m=a2.$flags|0,q=12;q>=0;--q){m&2&&A.b(a2)
if(!(q<13))return A.a(a2,q)
a2[q]=0}for(k=0;k<l;++k){if(!(k<256))return A.a(a0,k)
q=a0[k]
if(q>0){if(!(q<13))return A.a(a2,q)
j=a2[q]
i=B.a.p(1,q-1)
m&2&&A.b(a2)
if(!(q<13))return A.a(a2,q)
a2[q]=j+i}}h=a2[1]
if(h<2||(h&1)!==0)A.vc(h)
for(m=a2.$flags|0,g=0,q=1;q<=p;++q){if(!(q<13))return A.a(a2,q)
f=a2[q]
m&2&&A.b(a2)
if(!(q<13))return A.a(a2,q)
a2[q]=g
g+=f}if(g!==o)A.vf()
e=a.a
a.b=p
for(m=a2.$flags|0,j=e.$flags|0,i=p+1,k=0;k<l;++k){if(!(k<256))return A.a(a0,k)
q=a0[k]
if(q===0)continue
d=(k|i-q<<8)>>>0
f=B.a.p(1,q-1)
if(!(q<13))return A.a(a2,q)
c=a2[q]
for(r=0;r<f;++r){b=c+r
j&2&&A.b(e)
if(!(b<2048))return A.a(e,b)
e[b]=d}m&2&&A.b(a2)
if(!(q<13))return A.a(a2,q)
a2[q]=c+f}},
py(a,b,c,d,e,f,g){var s,r,q,p,o,n,m
if(g===0){s=new A.e9(new DataView(new ArrayBuffer(0)))
if(!s.cY(b,c,d)||!s.ghN())A.tP()
return}s=new A.e9(new DataView(new ArrayBuffer(0)))
if(!s.cY(b,c,d))A.uW()
r=a.a
for(q=32-a.b,p=0;p<g;++p){if(s.r||s.b>s.w)A.uX()
o=s.a
n=s.b
o=B.a.an(B.a.p(o,n),q)
if(!(o<2048))return A.a(r,o)
m=r[o]
o=f+p
e.$flags&2&&A.b(e)
if(!(o>=0&&o<e.length))return A.a(e,o)
e[o]=m&255
s.b=n+(m>>>8)
s.es()}if(!s.ghN())A.uY()},
v5(){return A.j(A.ag("Tree description is empty"))},
tO(){return A.j(A.ag("Direct weights are truncated"))},
tG(){return A.j(A.ag("Compressed weights are truncated"))},
v9(){return A.j(A.ag("Weight bitstream is empty or unterminated"))},
va(){return A.j(A.ag("Weight bitstream lacks its two initial states"))},
pr(){return A.j(A.ag("Too many weights"))},
tQ(){return A.j(A.ag("Every weight is zero"))},
ve(){return A.j(A.ag("Weights do not complete a Huffman tree"))},
vf(){return A.j(A.ag("Weights do not fill the table exactly"))},
uW(){return A.j(A.ag("Stream is empty or unterminated"))},
tP(){return A.j(A.ag("Stream owes no symbol but carries bits"))},
uX(){return A.j(A.ag("Stream is shorter than its literals"))},
uY(){return A.j(A.ag("Stream length does not match its literals"))},
vb(a){return A.j(A.ag("Weight count "+a+" is out of range"))},
vd(a){return A.j(A.ag("Weight "+a+" exceeds the longest code allowed"))},
vc(a){return A.j(A.ag("A complete tree needs an even count of two or more longest codes, not "+a))},
v2(a){return A.j(A.ag("Table log "+a+" is too large"))},
jL:function jL(a){this.a=a
this.c=this.b=0},
jJ:function jJ(a,b,c){this.a=a
this.b=b
this.c=c},
jK:function jK(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g},
ov(){var s=new Uint16Array(256),r=new Uint8Array(256),q=new Uint8Array(1024),p=new Uint32Array(256),o=new Uint32Array(514),n=new Uint16Array(514),m=new Uint8Array(514),l=new Uint16Array(514),k=new Uint32Array(192),j=new Uint32Array(192),i=new Uint32Array(14),h=new Uint16Array(12)
return new A.jH(s,r,q,p,o,n,m,l,k,j,i,h,new Uint16Array(12))},
jI:function jI(a,b,c){this.a=a
this.b=b
this.c=c},
jH:function jH(a,b,c,d,e,f,g,h,i,j,k,l,m){var _=this
_.a=a
_.b=b
_.c=!1
_.d=c
_.e=d
_.r=_.f=0
_.w=e
_.x=f
_.y=g
_.z=h
_.Q=i
_.as=j
_.at=k
_.ax=l
_.ay=m
_.ch=!1},
rQ(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f
if(a<7||b<27)return null
s=7-(a/3|0)
r=b-s
if(r<6)r=6
else if(r>30)r=30
q=a>=8?32:64
if(a<4)p=4
else p=a>8?8:a
if(p>r)p=r
o=r-p
n=A.rP(q,s)
m=A.iY()
l=new Int32Array(64)
k=new Int32Array(64)
j=new Uint32Array(64)
i=B.a.p(1,o+p)
h=new Uint32Array(i)
i=new Uint32Array(i)
g=B.a.p(1,o)
f=new A.jM(q,p,o,b,h,i,new Uint8Array(g),m,l,k,j,n)
f.ax=A.ow(q,s,32)
return f},
rP(a,b){return A.ow(a,b,0)},
ow(a,b,c){var s,r,q,p,o=a<64?a:64,n=b>0&&b<=o?o-b:0
for(s=n+b,r=c+32,q=n,p=0;q<s;++q)if(q>=c&&q<r)p=(p|B.a.p(1,q-c))>>>0
return p},
rN(a,b,c,d,e){return A.nk(a,b,c,d,e)},
rO(a,b,c,d,e){var s,r,q,p=a.length,o=0
for(;;){s=b-o
r=!1
if(s>c){q=d-o
if(q>e){--s
if(!(s>=0&&s<p))return A.a(a,s)
s=a[s];--q
if(!(q>=0&&q<p))return A.a(a,q)
q=s===a[q]
s=q}else s=r}else s=r
if(!s)break;++o}return o},
jN:function jN(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.f=_.e=_.d=0},
jV:function jV(){var _=this
_.a=null
_.f=_.e=_.d=_.c=_.b=0},
jM:function jM(a,b,c,d,e,f,g,h,i,j,k,l){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.x=h
_.y=i
_.z=j
_.Q=k
_.as=0
_.at=l
_.ch=_.ay=_.ax=0
_.CW=1},
pO(a){if(a<-131072)return-131072
if(a===0)return 3
return a>22?22:a},
pP(a){return a.a===5&&a.r>=2?a.r+5:6},
w3(a){var s
if(a.a!==5)return 64
s=a.r
if(s===0)s=32
else s=s===2?16:8
return s},
ni(a,b){var s,r,q,p,o,n,m,l,k,j,i=A.pO(a),h=b<=262144?1:0,g=b<=131072?1:0,f=b<=16384?1:0,e=B.bR[h+g+f]
h=i<0
s=(h?0:i)*7
g=s+6
if(!(g>=0&&g<161))return A.a(e,g)
r=e[g]
if(!(s>=0&&s<161))return A.a(e,s)
q=e[s]
g=s+1
if(!(g<161))return A.a(e,g)
p=e[g]
g=s+2
if(!(g<161))return A.a(e,g)
o=e[g]
n=6
for(;;){if(!(n<31&&B.a.q(1,n)<b))break;++n}if(q>n)q=n
m=q+1
if(o>m)o=m
l=p-(r>=5?1:0)
if(l>q)p-=l-q
if(q<10)q=10
if(!(r<9))return A.a(B.ai,r)
g=B.ai[r]
f=s+3
if(!(f<161))return A.a(e,f)
f=e[f]
if(h)h=-i
else{h=s+5
if(!(h<161))return A.a(e,h)
h=e[h]}k=B.bH[r]
j=s+4
if(!(j<161))return A.a(e,j)
return new A.jO(g,q,o,p,f,h,k,e[j],r+1)},
jO:function jO(a,b,c,d,e,f,g,h,i){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i},
b4(a){return new A.jR(a,null,null)},
ui(){return A.j(A.b4("Literals section is empty"))},
mZ(){return A.j(A.b4("Literals header is truncated"))},
pe(){return A.j(A.b4("Literals are larger than a block"))},
uH(){return A.j(A.b4("RLE literal byte is missing"))},
uz(){return A.j(A.b4("Raw literals are truncated"))},
tE(){return A.j(A.b4("Coded literals are truncated"))},
v6(){return A.j(A.b4("Treeless literals without an earlier tree"))},
uh(){return A.j(A.b4("Literal streams are missing"))},
tT(){return A.j(A.b4("Four streams need at least ten bytes"))},
tU(){return A.j(A.b4("Four streams need at least six literals"))},
uf(){return A.j(A.b4("Jump table declares an empty stream"))},
ug(){return A.j(A.b4("Jump table overruns the streams"))},
jR:function jR(a,b,c){this.a=a
this.b=b
this.c=c},
jP:function jP(a,b,c,d,e){var _=this
_.a=a
_.c=_.b=0
_.d=b
_.e=c
_.f=d
_.r=e
_.w=!1},
ox(a,b){var s=b<256?0:6,r=b>=1024?1:0,q=b>=16384?1:0
return a+s+3+r+q},
bu(a,b,c,d,e,f){var s,r,q=e>31?1:0,p=e>4095?1:0,o=1+q+p
if(o===1){a.$flags&2&&A.b(a)
if(!(b<a.length))return A.a(a,b)
a[b]=(f|e<<3)>>>0}else{s=f|(o===2?1:3)<<2|e<<4
for(q=a.$flags|0,r=0;r<o;++r){p=b+r
q&2&&A.b(a)
if(!(p<a.length))return A.a(a,p)
a[p]=s&255
s=s>>>8}}if(f===1){q=b+o
if(!(d>=0&&d<c.length))return A.a(c,d)
p=c[d]
a.$flags&2&&A.b(a)
if(!(q<a.length))return A.a(a,q)
a[q]=p
return o+1}if(e>0){q=b+o
B.c.H(a,q,q+e,c,d)}return o+e},
oy(a,b,c,d,e,f,g){var s,r,q,p,o,n,m,l
if(e===3){s=c<256||g?0:1
r=10}else if(e===4){s=2
r=14}else{s=3
r=18}for(q=4+r,p=1,o=0;o<q;++o)p*=2
n=f+(s<<2>>>0)+c*16+d*p
for(q=a.$flags|0,o=0;o<e;++o){m=b+o
l=B.a.E(n,256)
q&2&&A.b(a)
if(!(m<a.length))return A.a(a,m)
a[m]=l
n=B.a.t(n,256)}},
jQ:function jQ(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.r=_.f=_.e=!1
_.w=64
_.z=_.y=_.x=!1
_.Q=6
_.as=!1},
jU(a){var s=a.a
return(s===2||s===3)&&a.b<=14},
oz(a){var s=a.a
return(s===2||s===3)&&a.b>14},
cU(a){var s=a.e
if(s<4)return 4
return s>6?6:s},
rS(a){var s,r=B.a.q(1,a.e)
if(a.a>=4)return r
s=B.a.q(1,A.cU(a))
return r<s?r:s},
cf(a,b){var s,r,q,p,o
for(s=a.length,r=a.$flags|0,q=0;q<s;++q){p=a[q]
o=p<=b?0:p-b
r&2&&A.b(a)
a[q]=o}},
jT(a,b){var s,r,q,p,o,n
for(s=a.length,r=a.$flags|0,q=b+2,p=0;p<s;++p){o=a[p]
if(o===1)continue
n=o<q?0:o-b
r&2&&A.b(a)
a[p]=n}},
rR(a,b,c,d,e){var s,r,q,p=a.length,o=0
for(;;){s=b-o
r=!1
if(s>d){q=c-o
if(q>e){--s
if(!(s>=0&&s<p))return A.a(a,s)
s=a[s];--q
if(!(q>=0&&q<p))return A.a(a,q)
q=s===a[q]
s=q}else s=r}else s=r
if(!s)break;++o}return o},
jS:function jS(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i
_.y=j
_.z=k
_.Q=l
_.as=m
_.at=n
_.ax=o
_.ay=p
_.ch=q
_.CW=0
_.cx=r
_.cy=s
_.db=a0
_.dx=a1
_.dy=a2
_.fr=a3
_.fx=a4
_.fy=a5
_.go=a6
_.id=a7
_.k1=a8
_.k2=a9
_.k3=b0
_.k4=b1
_.ok=b2
_.p1=null
_.R8=_.p4=_.p3=_.p2=0
_.rx=_.RG=!1},
mE(a,b,c){var s,r,q,p,o,n,m,l
for(s=a.$flags|0,r=b==null,q=0,p=0;p<c;++p){if(r)o=0
else{n=b.b
m=p*2
if(!(m<n.length))return A.a(n,m)
o=B.a.k(n[m]+65536-1,16)}l=o!==0?B.a.p(1,10-o):1
s&2&&A.b(a)
if(!(p<a.length))return A.a(a,p)
a[p]=l
q+=l}return q},
mF(a){var s,r,q
for(s=a.length,r=0,q=0;q<s;++q)r+=a[q]
return r},
jW:function jW(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.w=_.r=_.f=_.e=0
_.x=e
_.y=f
_.z=g
_.Q=h
_.ch=_.ay=_.ax=_.at=_.as=0
_.CW=!1
_.dx=_.db=_.cy=_.cx=null},
pR(a,b,c){var s,r,q
if(b>3){s=a[1]
a.$flags&2&&A.b(a)
a[2]=s
a[1]=a[0]
a[0]=b-3
return}s=c?1:0
r=b-1+s
if(r===0)return
if(r===3)q=a[0]-1
else{if(!(r>=0&&r<3))return A.a(a,r)
q=a[r]}if(r>=2){s=a[1]
a.$flags&2&&A.b(a)
a[2]=s}s=a[0]
a.$flags&2&&A.b(a)
a[1]=s
a[0]=q},
w4(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j=c.f
for(s=j.length,r=d;r<e;++r){q=r<<2>>>0
p=q+2
if(!(p<s))return A.a(j,p)
o=j[p]
if(!(q<s))return A.a(j,q)
n=j[q]===0
if(o<=3){m=o-1
l=m+(n?1:0)
if(l===3)k=b[0]-1
else{if(!(l>=0&&l<3))return A.a(b,l)
k=b[l]}l=m+(n?1:0)
if(l===3)m=a[0]-1
else{if(!(l>=0&&l<3))return A.a(a,l)
m=a[l]}if(m!==k){j.$flags&2&&A.b(j)
j[p]=k+3}}A.pR(a,j[p],n)
A.pR(b,o,n)}},
jX:function jX(a){var _=this
_.a=a
_.b=0
_.f=_.e=_.d=_.c=$},
ah(a){return new A.k1(a,null,null)},
uQ(){return A.j(A.ah("Sequences section is empty"))},
pn(){return A.j(A.ah("Sequence count is truncated"))},
tS(){return A.j(A.ah("Extraneous data present in the sequences section"))},
tH(){return A.j(A.ah("Compression modes byte is missing"))},
uE(){return A.j(A.ah("Reserved bits in the compression modes"))},
uP(){return A.j(A.ah("Sequence bitstream is missing"))},
ty(){return A.j(A.ah("Block output is larger than a block"))},
uJ(){return A.j(A.ah("RLE table symbol is missing"))},
uD(){return A.j(A.ah("Repeat mode with no table to repeat"))},
up(a){return A.j(A.ah("Sequences reach outside the block: "+a.n(0)))},
uI(a){return A.j(A.ah("RLE table symbol "+a+" is too large"))},
k1:function k1(a,b,c){this.a=a
this.b=b
this.c=c},
jZ:function jZ(){},
pQ(a){var s
if(a<64){s=$.nA()
if(!(a>=0&&a<s.length))return A.a(s,a)
s=s[a]}else s=A.db(a)+19
return s},
nf(a){var s
if(a<128){s=$.nB()
if(!(a>=0&&a<s.length))return A.a(s,a)
s=s[a]}else s=A.db(a)+36
return s},
mG(a,b,c,d,e,f,g,h){var s,r,q,p,o,n,m,l
for(s=b.length,r=0,q=0;q<=c;++q){if(!(q<s))return A.a(b,q)
if(b[q]!==0)r=q}if(a===1)p=0
else if(a===0)p=A.oB(e,f,b,r)
else{o=A.oA(d.r?d.b:d.a,b,r)
if(o<0)return h*10
p=B.a.k(o,8)}for(n=g==null,q=0;q<=r;++q){if(!(q<s))return A.a(b,q)
m=b[q]
if(m!==0){if(n)l=q
else{if(!(q<g.length))return A.a(g,q)
l=g[q]}p+=m*l}}return p>>>3},
oB(a,b,c,d){var s,r,q,p,o,n,m,l,k=8-b
for(s=a.length,r=c.length,q=0,p=0;p<=d;++p){if(!(p<s))return A.a(a,p)
o=a[p]
if(!(p<r))return A.a(c,p)
n=c[p]
m=$.ny()
l=B.a.p(o!==-1?o:1,k)
if(!(l<m.length))return A.a(m,l)
q+=n*m[l]}return q>>>8},
rT(a,b,c){var s,r,q,p,o,n
for(s=a.length,r=0,q=0;q<=b;++q){if(!(q<s))return A.a(a,q)
p=a[q]
o=B.a.a2(256*p,c)
if(p!==0&&o===0)o=1
n=$.ny()
if(!(o>=0&&o<n.length))return A.a(n,o)
r+=p*n[o]}return r>>>8},
oA(a,b,c){var s,r,q,p,o,n,m,l,k,j,i
if(a.d<c)return-1
s=a.c
r=s+1<<8>>>0
for(q=a.b,p=q.length,o=b.length,n=0,m=0;m<=c;++m){if(!(m<o))return A.a(b,m)
l=b[m]
if(l===0)continue
k=m*2
if(!(k<p))return A.a(q,k)
j=q[k]
k=B.a.k(j,16)+1
i=(k<<8>>>0)-B.a.b3((k<<16>>>0)-(j+B.a.p(1,s))<<8>>>0,s)
if(i>=r)return-1
n+=l*i}return n},
k0:function k0(a,b,c){this.a=a
this.b=b
this.c=c},
jY:function jY(a,b){var _=this
_.a=a
_.e=0
_.f=b
_.r=0},
ey:function ey(a,b){var _=this
_.a=a
_.b=b
_.r=_.f=_.e=_.d=_.c=!1},
k_:function k_(a,b,c,d,e,f,g,h,i,j,k){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i
_.y=j
_.z=k
_.Q=3
_.ax=_.at=_.as=0},
nl(a,b){var s
if(b===0)s=a
else{s=32-b
if(!(s>=0&&s<33))return A.a(B.I,s)
s=B.I[s]
if(!(b>=0&&b<33))return A.a(B.I,b)
s=((a&s-1)>>>0)*B.I[b]}return s},
q(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i,h,g=a.getUint32(b,!0),f=a.getUint32(b+4,!0),e=c===4?2654435761:3474701532
if(!(c<9))return A.a(B.am,c)
s=B.am[c]
r=g&65535
q=g>>>16
p=f&65535
o=s&65535
n=s>>>16
m=e&65535
l=r*o
k=B.a.t(l,65536)+r*n+q*o
j=B.a.t(k,65536)+r*m+q*n+p*o
i=(j&65535)+(B.a.t(j,65536)+r*(e>>>16)+q*m+p*n+(f>>>16)*o&65535)*65536
if(d>=32)return B.a.an(i,d-32)
h=32-d
if(!(h<33))return A.a(B.I,h)
return i*B.I[h]+B.a.an((l&65535)+(k&65535)*65536,d)},
w5(a,b){var s=a&65535,r=b&65535
return s*r+((a>>>16)*r+s*(b>>>16)&65535)*65536>>>0},
nk(a,b,c,d,e){var s,r,q,p=0
for(;;){s=c+p
if(!(s+4<=e&&b.getUint32(s,!0)===b.getUint32(d+p,!0)))break
p+=4}s=a.length
for(;;){r=c+p
if(r<e){if(!(r>=0&&r<s))return A.a(a,r)
r=a[r]
q=d+p
if(!(q>=0&&q<s))return A.a(a,q)
q=r===a[q]
r=q}else r=!1
if(!r)break;++p}return p},
fK:function fK(a,b){var _=this
_.a=a
_.b=b
_.z=_.y=_.x=_.w=_.r=_.f=_.e=_.d=_.c=0},
k2:function k2(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.y=_.x=_.w=_.r=_.f=_.e=_.d=0
_.z=!1},
ot(a,b){var s,r,q,p,o=a.length
if(!(b<o))return A.a(a,b)
s=a[b]
r=b+1
if(!(r<o))return A.a(a,r)
r=a[r]
q=b+2
if(!(q<o))return A.a(a,q)
q=a[q]
p=b+3
if(!(p<o))return A.a(a,p)
return(s|r<<8|q<<16|a[p]<<24)>>>0},
jv:function jv(a,b){this.a=a
this.b=b},
jx:function jx(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
jw:function jw(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
fJ:function fJ(a,b){this.a=a
this.b=b},
oY(a){var s,r,q,p,o,n,m=new Uint32Array(256)
for(s=0;s<256;++s){for(r=s,q=0,p=0;p<8;++p){o=(r>>>1|(q&1)<<31)>>>0
q=q>>>1
if((r&1)!==0){r=(o^3615952706)>>>0
q=(q^3379320725)>>>0}else r=o}n=a?q:r
if(!(s<256))return A.a(m,s)
m[s]=n}return m},
oX(a){var s,r,q,p,o,n,m,l,k,j,i=new Uint32Array(2048)
B.f.V(i,0,256,$.m2())
s=new Uint32Array(2048)
B.f.V(s,0,256,$.m1())
for(r=1;r<8;++r)for(q=(r-1)*256,p=r*256,o=0;o<256;++o){n=q+o
if(!(n>=0&&n<2048))return A.a(i,n)
m=i[n]
l=s[n]
k=m&255
n=p+o
j=$.m2()[k]
if(!(n<2048))return A.a(i,n)
i[n]=((m>>>8|(l&255)<<24)^j)>>>0
j=$.m1()[k]
if(!(n<2048))return A.a(s,n)
s[n]=(l>>>8^j)>>>0}return a?s:i},
f5:function f5(){this.b=this.a=0},
eO(a,b,c){var s,r,q,p="The decoded data is larger than the "
if(b==null)return c.$1(a)
s=new A.dG(a,b,a.a)
r=null
try{r=c.$1(s)}catch(q){if(s.e)throw A.d(A.hw(p+A.r(b)+" bytes allowed"))
throw q}if(s.e)throw A.d(A.hw(p+A.r(b)+" bytes allowed"))
return r},
dG:function dG(a,b,c){var _=this
_.b=a
_.c=b
_.d=0
_.e=!1
_.a=c},
te(a,b){return new A.by(a,b)},
pf(a,b){var s=a&65535,r=b&65535
return s*r+((a>>>16)*r+s*(b>>>16)<<16>>>0)>>>0},
iY(){var s=new A.iX(0,0,new A.by(0,0),new A.by(0,0),new A.by(0,0),new A.by(0,0),new A.by(0,0),new Uint8Array(32))
s.a0()
return s},
rE(a,b,c){var s=$.ho()
s.a=b
s.b=c
s.aa(3266489917,668265295)
a.W(0,s.a,s.b)
a.aI(31)
a.aa(2654435761,2246822535)},
by:function by(a,b){this.a=a
this.b=b},
iX:function iX(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.x=_.w=0
_.y=h
_.z=$},
p_(a,b){var s,r
try{s=a.hx(b)
return s}catch(r){if(A.G(r) instanceof A.ay)return null
else throw r}},
w1(a,b,c){var s=A.p_(B.T,a)
s=s
if(s==null){s=A.ar(a)
s=A.cb(new A.av(a,s.h("e(o.E)").a(new A.lY()),s.h("av<o.E,e>")),0,null)}return s},
w2(a,b){var s
if(b.gi(b)<5||b.G()!==1||b.J()!==A.I(a,0))return null
s=A.p_(B.T,b.B())
return s==null||s.length===0?null:s},
lY:function lY(){},
iR(a,b){var s,r,q,p=a.length,o=b.length
if(p!==o)return!1
for(s=0,r=0;r<p;++r){q=a[r]
if(!(r<o))return A.a(b,r)
s|=q^b[r]}return s===0},
nH(a,b,c,d){var s,r,q,p=new A.hu(a,d),o=new Uint8Array(16)
o[0]=1
s=new Uint8Array(16)
r=new Uint8Array(32)
q=A.qJ(a)
B.c.ab(s,0,o)
p.d=new A.hv(q,(a.length/4|0)+6,!0,s,r)
p.e=A.nV(b)
return p},
hu:function hu(a,b){var _=this
_.a=a
_.c=b
_.f=_.e=_.d=$},
qJ(a){var s,r,q,p,o,n,m,l,k,j,i=a.length,h=i/4|0
if(i!==16&&i!==24&&i!==32)throw A.d(A.aZ(i,"key","Must be 16, 24 or 32 bytes"))
s=4*(h+7)
r=new Uint32Array(s)
for(q=0;q<h;++q){p=4*q
if(!(p<i))return A.a(a,p)
o=a[p]
n=p+1
if(!(n<i))return A.a(a,n)
n=a[n]
m=p+2
if(!(m<i))return A.a(a,m)
m=a[m]
p+=3
if(!(p<i))return A.a(a,p)
p=a[p]
if(!(q<s))return A.a(r,q)
r[q]=(o<<24|n<<16|m<<8|p)>>>0}for(i=h===8,q=h,l=1;q<s;++q){p=q-1
if(!(p>=0))return A.a(r,p)
k=r[p]
p=B.a.E(q,h)
if(p===0){p=B.h[k>>>16&255]
o=B.h[k>>>8&255]
n=B.h[k&255]
m=k>>>24
if(!(m<256))return A.a(B.h,m)
k=(p<<24|o<<16|n<<8|B.h[m])^l<<24
j=l<<1
l=(l&128)!==0?j^283:j}else if(i&&p===4){p=k>>>24
if(!(p<256))return A.a(B.h,p)
k=B.h[p]<<24|B.h[k>>>16&255]<<16|B.h[k>>>8&255]<<8|B.h[k&255]}p=q-h
if(!(p>=0))return A.a(r,p)
r[q]=(r[p]^k)>>>0}return r},
hv:function hv(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=32},
p(a){return new A.aP(a,null,null)},
qK(a){return new A.c0(a,null,null)},
nJ(a){return new A.df(a,null,null)},
hw(a){return new A.de(a,null,null)},
qL(a){return new A.dg(a,null,null)},
aP:function aP(a,b,c){this.a=a
this.b=b
this.c=c},
c0:function c0(a,b,c){this.a=a
this.b=b
this.c=c},
df:function df(a,b,c){this.a=a
this.b=b
this.c=c},
de:function de(a,b,c){this.a=a
this.b=b
this.c=c},
dg:function dg(a,b,c){this.a=a
this.b=b
this.c=c},
dk:function dk(a,b){this.a=a
this.b=b},
f_:function f_(){},
bQ:function bQ(a,b,c){var _=this
_.b=a
_.c=0
_.e=b
_.f=0
_.a=c},
f4:function f4(a){this.a=a},
d8(a,b,c,d){var s,r,q,p=c,o=new A.kd($.mO)
$.mO=o
try{if(d.$0())return!0
if(p){r=A.p("Invalid "+a+" data")
throw A.d(r)}return!1}catch(q){s=A.G(q)
A.pD(s)
if(s instanceof A.i3)A.me(s.a,s.b)
if(!A.hn(s))throw q
if(s instanceof A.dg||s instanceof A.df||s instanceof A.de)throw q
if(s instanceof A.c0){if(b&&c)throw q
if(c){r=A.p(s.a)
throw A.d(r)}return!1}if(s instanceof A.aP){if(p)throw q
return!1}if(p){r=A.p("Invalid "+a+" data: "+A.r(s))
throw A.d(r)}return!1}finally{$.mO=o.a}},
pD(a){return!1},
hn(a){return a instanceof A.aP||a instanceof A.c0||a instanceof A.ay||t.b8.b(a)||t.eK.b(a)},
kd:function kd(a){this.a=a},
i3:function i3(){},
dw:function dw(){},
bH:function bH(a){this.a=a},
nX(a){return new A.cE(new A.fX(a,0,new Uint8Array(65536),B.d),0,null,B.d)},
nY(a,b,c){return new A.cE(a.b,a.c+b,c,a.a)},
cE:function cE(a,b,c,d){var _=this
_.b=a
_.c=b
_.d=c
_.e=0
_.a=d},
fX:function fX(a,b,c,d){var _=this
_.b=a
_.c=b
_.d=c
_.r=_.f=_.e=0
_.w=!1
_.a=d},
U(a,b,c,d){var s,r,q,p,o=new A.a6(b)
if(d==null)d=0
A.bN(d,"offset")
if(d<0)d=0
else{s=a.length
if(d>s)d=s}r=a.length-d
if(c==null)c=r
if(c<0||c>r)c=r
q=t.p.b(a)?a:new Uint8Array(A.N(a))
p=J.ak(B.c.gN(q),q.byteOffset+d,c)
o.b=p
o.d=p.length
return o},
a6:function a6(a){var _=this
_.b=null
_.c=0
_.d=$
_.a=a},
cF:function cF(){},
io:function io(a){this.a=a},
a8(a){var s=a==null?32768:a
return new A.bg(new Uint8Array(s),B.d)},
bg:function bg(a,b){this.b=0
this.c=a
this.a=b},
aI:function aI(){},
nV(a){var s,r=new Uint32Array(5),q=new Uint32Array(80)
r=new A.iH(r,q,new Uint8Array(64))
r.a0()
q=new Uint32Array(5)
s=new Uint32Array(5)
r=new A.ik(r,q,s,new Uint8Array(20))
r.ip(a)
return r},
pG(a5,a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4
if(a7<1)throw A.d(A.aZ(a7,"iterations","Must be positive"))
s=A.nV(a5)
r=s.a
q=r.b
p=r.a
o=s.b
n=[o,s.c]
m=new Uint8Array(a8)
l=new Uint8Array(4)
k=new Uint8Array(20)
j=new Uint32Array(5)
i=new Uint32Array(5)
for(h=a6.length,g=q.$flags|0,f=1,e=0;e<a8;++f,e+=20){l[0]=f>>>24
l[1]=f>>>16&255
l[2]=f>>>8&255
l[3]=f&255
r.ag(a6,0,h)
r.ag(l,0,4)
s.bg(k,0)
for(d=0;d<5;++d){c=4*d
if(!(c<20))return A.a(k,c)
b=k[c]
a=c+1
if(!(a<20))return A.a(k,a)
a=k[a]
a0=c+2
if(!(a0<20))return A.a(k,a0)
a0=k[a0]
a1=c+3
if(!(a1<20))return A.a(k,a1)
j[d]=(b<<24|a<<16|a0<<8|k[a1])>>>0
i[d]=j[d]}for(a2=1;a2<a7;++a2){for(b=n.length,a3=0;a3<b;++a3){a4=n[a3]
B.f.ab(q,0,j)
g&2&&A.b(q)
q[5]=2147483648
B.f.F(q,6,15,0)
q[15]=672
B.f.ab(p,0,a4)
r.eZ()
B.f.ab(j,0,p)}for(d=0;d<5;++d)i[d]=(i[d]^j[d])>>>0}B.f.ab(p,0,o)
d=r.d=0
r.e=64
for(;;){if(!(d<20&&e+d<a8))break
b=e+d
a=d>>>2
if(!(a<5))return A.a(i,a)
a=B.a.an(i[a],24-8*(d&3))
if(!(b<a8))return A.a(m,b)
m[b]=a&255;++d}}return m},
iH:function iH(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.e=_.d=0},
ik:function ik(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
ol(){var s=new Uint32Array(8),r=new Uint32Array(64)
s=new A.iI(s,r,new Uint8Array(64))
s.a0()
return s},
iI:function iI(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.e=_.d=0},
eJ(a){var s,r,q,p,o="0123456789abcdef",n=a.length,m=n*2,l=new Uint8Array(m)
for(s=0,r=0;s<n;++s){q=a[s]
p=r+1
if(!(r<m))return A.a(l,r)
l[r]=o.charCodeAt(q>>>4&15)
r=p+1
if(!(p<m))return A.a(l,p)
l[p]=o.charCodeAt(q&15)}return A.cb(l,0,null)},
aR:function aR(a){this.a=a},
f9:function f9(){this.a=null},
fc:function fc(){},
fd:function fd(){},
h6:function h6(){},
h7:function h7(a,b,c,d,e,f,g,h){var _=this
_.y=a
_.z=b
_.a=c
_.b=d
_.c=e
_.d=f
_.e=0
_.f=g
_.r=0
_.w=!1
_.x=h},
oI(a){var s=new Uint32Array(A.N(A.i([1779033703,3144134277,1013904242,2773480762,1359893119,2600822924,528734635,1541459225],t.t))),r=new Uint32Array(64),q=new Uint8Array(64),p=new Uint32Array(16)
return new A.ew(s,r,a,B.J,J.hs(B.c.gN(q)),q,p,8)},
h8:function h8(){},
h9:function h9(){},
ew:function ew(a,b,c,d,e,f,g,h){var _=this
_.y=a
_.z=b
_.a=c
_.b=d
_.c=e
_.d=f
_.e=0
_.f=g
_.r=0
_.w=!1
_.x=h},
eY:function eY(a,b,c){this.c=a
this.d=b
this.a=c},
qQ(){var s=$.m3()
return s},
i_:function i_(a){this.a=a},
c_:function c_(){},
i6:function i6(){},
ia:function ia(){},
dK:function dK(a){this.a=a},
iF:function iF(){},
it:function it(){},
cO:function cO(a,b,c){this.a=a
this.b=b
this.c=c},
mx:function mx(){},
b9(a){return((a&255)<<24|(a>>>8&255)<<16&16777215|(a>>>16&255)<<8&65535|a>>>24&255)>>>0},
f7(a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=new DataView(new ArrayBuffer(16))
a3.setUint32(0,0,!1)
a3.setUint32(4,0,!1)
a3.setUint32(8,0,!1)
a3.setUint32(12,0,!1)
s=A.b9(a4[0])
r=A.b9(a4[1])
q=A.b9(a4[2])
p=A.b9(a4[3])
o=a5[0]
n=a5[1]
m=a5[2]
l=a5[3]
for(k=0;j=a6.length,k<j;k=i,p=b,q=c,r=d,s=e){i=k+16
if(i<=j)for(h=0;h<16;++h){j=k+h
if(!(j<a6.length))return A.a(a6,j)
a3.setUint8(h,a6[j])}else{a3.setUint32(0,0,!1)
a3.setUint32(4,0,!1)
a3.setUint32(8,0,!1)
a3.setUint32(12,0,!1)
g=B.a.E(a6.length,16)
for(h=0;h<g;++h){j=k+h
if(!(j<a6.length))return A.a(a6,j)
a3.setUint8(h,a6[j])}}s^=a3.getUint32(0,!1)
r^=a3.getUint32(4,!1)
q^=a3.getUint32(8,!1)
p^=a3.getUint32(12,!1)
for(f=o,e=0,d=0,c=0,b=0,k=0;k<128;++k,p=a2,q=a1,r=a0){j=B.a.E(k,32)
if(j===0&&k!==0)if(k===32)f=n
else f=k===64?m:l
if((f&B.a.p(1,31-j))>>>0!==0){e=(e^s)>>>0
d=(d^r)>>>0
c=(c^q)>>>0
b=(b^p)>>>0}a=s>>>1|0
a0=(s&1)<<31|r>>>1
a1=(r&1)<<31|q>>>1
a2=(q&1)<<31|p>>>1
s=(p&1)<<31>>>0!==0?a^3774873600:a}}j=A.b9(s)
a4.$flags&2&&A.b(a4)
if(0>=4)return A.a(a4,0)
a4[0]=j
j=A.b9(r)
a4.$flags&2&&A.b(a4)
if(1>=4)return A.a(a4,1)
a4[1]=j
j=A.b9(q)
a4.$flags&2&&A.b(a4)
if(2>=4)return A.a(a4,2)
a4[2]=j
j=A.b9(p)
a4.$flags&2&&A.b(a4)
if(3>=4)return A.a(a4,3)
a4[3]=j},
r_(a,b){var s,r,q,p,o,n=4294967296,m=b.length
if(m===12){s=new Uint8Array(16)
B.c.ab(s,0,b)
s[15]=1
return s}r=new DataView(new ArrayBuffer(16))
q=8*m
r.setUint32(8,B.a.t(q,n),!1)
r.setUint32(12,B.a.E(q,n),!1)
p=J.ak(B.K.gN(r),0,null)
o=new Uint32Array(4)
A.f7(o,a,b)
A.f7(o,a,p)
return J.ak(B.f.gN(o),0,null)},
f6:function f6(a,b,c){this.c=a
this.d=b
this.a=c},
ic:function ic(){},
fV:function fV(){},
fW:function fW(){},
n6(b0,b1,b2,b3,b4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9=b2.length
if(!(b3<a9))return A.a(b2,b3)
s=b2[b3]
r=b3+1
if(!(r<a9))return A.a(b2,r)
q=b2[r]
r=b3+2
if(!(r<a9))return A.a(b2,r)
p=b2[r]
r=b3+3
if(!(r<a9))return A.a(b2,r)
o=b2[r]
if($.dc()===B.B){s=A.ct(s)
q=A.ct(q)
p=A.ct(p)
o=A.ct(o)}a9=b4.length
if(0>=a9)return A.a(b4,0)
s^=b4[0]
if(1>=a9)return A.a(b4,1)
q^=b4[1]
if(2>=a9)return A.a(b4,2)
p^=b4[2]
if(3>=a9)return A.a(b4,3)
o^=b4[3]
n=(a9/4|0)-1
for(m=4,l=1;l<n;++l,o=k,p=r,q=f,s=h){r=B.i[s>>>24&255]
k=B.p[q>>>16&255]
j=B.q[p>>>8&255]
i=B.r[o&255]
if(!(m<a9))return A.a(b4,m)
h=r^k^j^i^b4[m]
i=B.i[q>>>24&255]
j=B.p[p>>>16&255]
k=B.q[o>>>8&255]
r=B.r[s&255]
g=m+1
if(!(g<a9))return A.a(b4,g)
f=i^j^k^r^b4[g]
g=B.i[p>>>24&255]
r=B.p[o>>>16&255]
k=B.q[s>>>8&255]
j=B.r[q&255]
i=m+2
if(!(i<a9))return A.a(b4,i)
r=g^r^k^j^b4[i]
i=B.i[o>>>24&255]
j=B.p[s>>>16&255]
k=B.q[q>>>8&255]
g=B.r[p&255]
e=m+3
if(!(e<a9))return A.a(b4,e)
k=i^j^k^g^b4[e]
m+=4}r=B.h[s>>>24&255]
k=B.h[q>>>16&255]
j=B.h[p>>>8&255]
i=B.h[o&255]
g=B.h[q>>>24&255]
e=B.h[p>>>16&255]
d=B.h[o>>>8&255]
c=B.h[s&255]
f=B.h[p>>>24&255]
b=B.h[o>>>16&255]
a=B.h[s>>>8&255]
a0=B.h[q&255]
a1=B.h[o>>>24&255]
a2=B.h[s>>>16&255]
a3=B.h[q>>>8&255]
a4=B.h[p&255]
if(!(m<a9))return A.a(b4,m)
a5=(((r&255)<<24|(k&255)<<16|(j&255)<<8|i&255)^b4[m])>>>0
i=m+1
if(!(i<a9))return A.a(b4,i)
a6=(((g&255)<<24|(e&255)<<16|(d&255)<<8|c&255)^b4[i])>>>0
i=m+2
if(!(i<a9))return A.a(b4,i)
a7=(((f&255)<<24|(b&255)<<16|(a&255)<<8|a0&255)^b4[i])>>>0
i=m+3
if(!(i<a9))return A.a(b4,i)
a8=(((a1&255)<<24|(a2&255)<<16|(a3&255)<<8|a4&255)^b4[i])>>>0
if($.dc()===B.B){a5=A.ct(a5)
a6=A.ct(a6)
a7=A.ct(a7)
a8=A.ct(a8)}b0.$flags&2&&A.b(b0)
a9=b0.length
if(!(b1<a9))return A.a(b0,b1)
b0[b1]=a5
r=b1+1
if(!(r<a9))return A.a(b0,r)
b0[r]=a6
r=b1+2
if(!(r<a9))return A.a(b0,r)
b0[r]=a7
r=b1+3
if(!(r<a9))return A.a(b0,r)
b0[r]=a8},
vi(a){var s,r,q,p,o,n,m,l,k,j,i=a.gbv(),h=B.c6.l(0,i.gi(0))
if(h==null)throw A.d(A.bd("Invalid key length",null))
s=(h+1)*4
r=new Uint32Array(s)
q=J.eR(B.f.gN(r),r.byteOffset,i.gi(0))
p=i.a
o=q.$flags|0
n=J.aj(p)
m=0
for(;;){if(!(m<n.gi(p)))break
l=n.l(p,m)
o&2&&A.b(q,9)
q.setUint8(m,l);++m}k=B.a.t(i.gi(0),4)
if($.dc()===B.B)for(m=0;m<k;++m){o=q.getUint32(4*m,!1)
if(!(m<s))return A.a(r,m)
r[m]=o}for(o=k>6,m=k;m<s;++m){n=m-1
if(!(n>=0))return A.a(r,n)
j=r[n]
n=B.a.E(m,k)
if(n===0){j=A.pp((j<<8|j>>>24)>>>0)
n=B.a.a2(m,k)-1
if(!(n>=0&&n<30))return A.a(B.ad,n)
j^=B.ad[n]<<24}else if(o&&n===4)j=A.pp(j)
n=m-k
if(!(n<s))return A.a(r,n)
n=r[n]
if(!(m>=0&&m<s))return A.a(r,m)
r[m]=(j^n)>>>0}return r},
pp(a){return(B.h[a>>>24&255]<<24|B.h[a>>>16&255]<<16|B.h[a>>>8&255]<<8|B.h[a&255])>>>0},
ct(a){return((a&255)<<24|(a>>>8&255)<<16&16777215|(a>>>16&255)<<8&65535|a>>>24&255)>>>0},
ib:function ib(){},
r0(a){return new A.dq(a)},
dq:function dq(a){this.a=a},
id:function id(){},
kc:function kc(){},
eM(c1,c2,c3){var s=0,r=A.a3(t.h),q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0
var $async$eM=A.a4(function(c4,c5){if(c4===1)return A.a0(c5,r)
for(;;)switch(s){case 0:b8=Date.now()
b9=c1.e
c0=b9.length
if(c0===0)throw A.d(B.b5)
for(p=0,o=0;o<b9.length;b9.length===c0||(0,A.O)(b9),++o){n=b9[o]
m=n.c
p+=B.t.a4(m).length
l=$.nx().b
if(l.test(m))throw A.d(B.b0)
if(l.test(n.d))throw A.d(B.b_)}if(p>33554432)throw A.d(B.b6)
k=A.v4(c1.b)
c0=c1.c
j="\u7531\u9c7c\u8005\u6587\u79bb\u7ebf\u5bf9\u8bdd\u8f6c\u6362\u5668 \u4ece "+c0+" \u5bfc\u5165\u3002\u6e90\u5bf9\u8bdd\u6ca1\u6709\u63d0\u4f9b\u5b8c\u6574\u4e16\u754c\u8bbe\u5b9a\uff1b\u4e16\u754c\u80cc\u666f\u3001\u5730\u70b9\u3001NPC\u3001\u89c4\u5219\u548c\u8bb0\u5fc6\u672a\u7531\u8f6c\u6362\u5668\u7f16\u9020\uff0c\u5f53\u524d\u4fdd\u6301\u672a\u8bbe\u5b9a\u3002"
i="converter-"+A.p0(c1,b9)
h="conversation-"+i
g="converter-job-"+i
f="checkpoint-"+i
e=B.a.t(b8,1000)
m=c1.r
d=A.tK(m)
if(d==null)d=b8
c=B.a.t(d,1000)
l=c1.d
b=t.N
a=t.X
a0=t.I
a1=t.z
a2=A.z(["id",i,"schemaVersion",1,"title",k,"description",j,"genreTags",B.by,"era",null,"calendarSystem",null,"worldDateTime",null,"startingLocation",null,"playerProfile",null,"worldRules",B.F,"characterProfiles",B.F,"locationProfiles",B.F,"relationships",B.F,"narrativePreferences",null,"openingScene",null,"customFields",A.z(["converter",A.z(["name","\u9c7c\u8005\u6587\u79bb\u7ebf\u5bf9\u8bdd\u8f6c\u6362\u5668","version","1.2.1","sourceFormat",c0,"sourceFile",l,"sourceSessionId",c1.a,"sourceModel",c1.f,"sourceCreatedAt",m,"generatedDefaults",B.bF,"note","\u4e16\u754c/NPC/\u8bb0\u5fc6\u672a\u7531\u8f6c\u6362\u5668\u7f16\u9020\uff1b\u53ea\u4fdd\u7559\u539f\u59cb\u5bf9\u8bdd\u6d88\u606f\u3002"],b,a)],b,a0),"createdAt",new A.aF(A.md(d,0),0,!1).i7().ev(),"updatedAt",new A.aF(b8,0,!1).i7().ev()],b,a1)
m=A.r1(1970).ev()
a3=t.K
a4=A.z(["conversationId",h,"nodeId",B.b.gbB(b9).a,"factCount",0,"unknownCount",0],b,a3)
a5=t.gE
a6=A.i([],a5)
a7=A.F(b9)
a8=a7.h("K(1)")
a7=a7.h("aT<1>")
a9=a7.h("h.E")
b0=A.aS(new A.aT(b9,a8.a(new A.ls()),a7),a9)
b1=A.F(b0).h("b0<1>")
b2=t.S
b1=A.aK(new A.b0(b0,b1),0,A.ba(6,"count",b2),b1.h("P.E")).i4(0)
b0=A.F(b1).h("b0<1>")
b1=new A.b0(b1,b0)
b1=new A.au(b1,b1.gi(0),b0.h("au<P.E>"))
b0=b0.h("P.E")
while(b1.u()){b3=b1.d
if(b3==null)b3=b0.a(b3)
a6.push(A.z(["id",b3.a,"role",b3.b,"content",b3.c],b,b))}a5=A.i([],a5)
a7=A.aS(new A.aT(b9,a8.a(new A.lt()),a7),a9)
a8=A.F(a7).h("b0<1>")
a8=A.aK(new A.b0(a7,a8),0,A.ba(4,"count",b2),a8.h("P.E")).i4(0)
b2=A.F(a8).h("b0<1>")
a8=new A.b0(a8,b2)
a8=new A.au(a8,a8.gi(0),b2.h("au<P.E>"))
b2=b2.h("P.E")
while(a8.u()){a7=a8.d
if(a7==null)a7=b2.a(a7)
a5.push(A.z(["id",a7.a,"role",a7.b,"text",a7.c],b,b))}b4=A.z(["worldId",i,"revision",0,"definitionVersion",1,"definitionSnapshot",a2,"currentTime",m,"elapsedMinutes",0,"worldDateTimeLabel",null,"calendarSystem",null,"currentLocation","","playerLocation","","playerProfile",null,"characters",B.F,"presentCharacters",B.P,"knownLocations",A.c7(b,t.x),"knownItems",A.c7(b,a1),"importantEvents",B.P,"activePlotThreads",B.P,"worldRules",B.F,"openingScene",null,"recovery",a4,"recoveredFacts",B.F,"importedRecent",a6,"importedRecentPublic",!0,"importedStoryExcerpt",a5],b,a1)
m=A.i([A.z(["primary",i],b,a),A.z(["table","worlds","row",A.z(["id",i,"title",k,"genre","\u5bfc\u5165\u5bf9\u8bdd","summary",j,"created_at",c],b,a3)],b,a),A.z(["table","pending_imports","row",A.z(["id",g,"fingerprint",A.p0(c1,b9),"payload",B.m.aL(A.z(["id",g,"source","converter","receivedAt",b8,"text","","mime","text/plain","files",B.an,"error",null],b,a),null),"state","saved","safe_error",null,"received_at",e],b,a)],b,a),A.z(["table","imported_conversations","row",A.z(["id",h,"job_id",g,"title",k,"source","converter","world_id",i,"current_message_id",B.b.gbB(b9).a,"created_at",c],b,a3)],b,a)],t.d)
for(a1=t.G,a4=A.nW(b9,0,a1),a5=J.aO(a4.a),a6=a4.b,a4=new A.bl(a5,a6,A.y(a4).h("bl<1>"));a4.u();){a7=a4.c
b5=a7>=0?new A.cn(a6+a7,a5.gC()):A.j(A.cG())
a7=b5.b
a8=b5.a
m.push(A.z(["table","imported_messages","row",A.z(["conversation_id",h,"message_id",a7.a,"parent_id",A.uq(b9,a8),"role",a7.b,"body",a7.c,"raw_json",A.uM(a7.d),"ordinal",a8],b,a)],b,a))}a4=c1.w
m.push(A.z(["table","derived_import_results","row",A.z(["id",1,"conversation_id",h,"derived_json",B.m.aL(A.z(["type","converter-v1","converter","\u9c7c\u8005\u6587\u79bb\u7ebf\u5bf9\u8bdd\u8f6c\u6362\u5668","version","1.2.1","sourceFormat",c0,"sourceFile",l,"warnings",a4],b,a3),null),"created_at",e],b,a3)],b,a))
m.push(A.z(["table","roleplay_saves","row",A.z(["world_id",i,"revision",0,"payload",B.m.aL(b4,null)],b,a3)],b,a))
m.push(A.z(["table","world_definitions","row",A.z(["world_id",i,"version",1,"payload",B.m.aL(a2,null),"saved_at",e],b,a3)],b,a))
m.push(A.z(["table","story_checkpoints","row",A.z(["id",f,"world_id",i,"revision",0,"payload",B.m.aL(A.z(["state",b4,"memories",B.an],b,a3),null),"source_conversation",h,"source_message_id",B.b.gbB(b9).a,"created_at",e],b,a3)],b,a))
m.push(A.z(["table","story_branches","row",A.z(["world_id",i,"parent_world_id",null,"checkpoint_id",f,"source_conversation",h,"source_message_id",B.b.gbB(b9).a],b,t.dk)],b,a))
for(c0=A.nW(b9,0,a1),l=J.aO(c0.a),a1=c0.b,c0=new A.bl(l,a1,A.y(c0).h("bl<1>")),a5=t.s,a6=i+"-source-";c0.u();){a7=c0.c
b5=a7>=0?new A.cn(a1+a7,l.gC()):A.j(A.cG())
a7=b5.a
a8=B.e.cN(B.a.n(a7),6,"0")
a9=A.c7(b,a)
a9.D(0,"category","source")
a9.D(0,"kind","record")
b0=b5.b
a9.D(0,"sourceRole",b0.b)
a9.D(0,"text",b0.c)
b1=b0.f
if(b1!=null)a9.D(0,"sourceTimestamp",b1)
a9.D(0,"sourceMessageIds",A.i([b0.a],a5))
a9.D(0,"sourceOrdinal",a7)
a9.D(0,"converter","\u9c7c\u8005\u6587\u79bb\u7ebf\u5bf9\u8bdd\u8f6c\u6362\u5668")
m.push(A.z(["table","timeline_entries","row",A.z(["id",a6+a8,"world_id",i,"revision",0,"payload",B.m.aL(a9,null)],b,a3)],b,a))}s=3
return A.A(A.ce(A.om(m,a0),c3),$async$eM)
case 3:b6=c5
b7=A.p4(k)
c0=b9.length
m=A.aS(a4,b)
q=new A.dp(b6,b7+".yuzhe",k,c0,m)
s=1
break
case 1:return A.a1(q,r)}})
return A.a2($async$eM,r)},
lq(a){var s=0,r=A.a3(t.gJ),q,p,o,n,m,l,k,j,i,h,g
var $async$lq=A.a4(function(b,c){if(b===1)return A.a0(c,r)
for(;;)switch(s){case 0:if(a.length===0)throw A.d(B.a9)
p=t.N
o=new A.dd(A.i([],t.V),A.c7(p,t.S))
n=A.o8(p)
m=A.i([],t.s)
p=a.length,l=0
case 3:if(!(l<a.length)){s=5
break}s=6
return A.A(A.eM(a[l],null,null),$async$lq)
case 6:k=c
j=k.b
for(i=k.c,h=2;!n.m(0,j);){j=A.p4(i)+"-"+h+".yuzhe";++h}i=k.a
g=new A.bc(j,420,B.a.t(Date.now(),1000),i.length,!0)
g.ax=new A.bH(i)
g.at=new A.bH(i)
o.m(0,g)
i=k.e
g=A.F(i)
B.b.af(m,new A.av(i,g.h("l(1)").a(new A.lr(k)),g.h("av<1,l>")))
case 4:a.length===p||(0,A.O)(a),++l
s=3
break
case 5:p=new Uint8Array(A.N(new A.j9().lq(o,!1,null,1,null,null)))
i=a.length
q=new A.fp(p,"\u9c7c\u8005\u6587\u6e38-\u8f6c\u6362\u7ed3\u679c-"+i+"\u4e2a\u4f1a\u8bdd.zip",i)
s=1
break
case 1:return A.a1(q,r)}})
return A.a2($async$lq,r)},
eN(a1){var s=0,r=A.a3(t.h),q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0
var $async$eN=A.a4(function(a2,a3){if(a2===1)return A.a0(a3,r)
for(;;)switch(s){case 0:if(a1.length===0)throw A.d(B.a9)
p=t.N
o=A.c7(p,t.aS)
n=A.i([],t.s)
m=a1.length,l=t.d,k=null,j=0,i=0
case 3:if(!(i<a1.length)){s=5
break}s=6
return A.A(A.eM(a1[i],null,null),$async$eN)
case 6:h=a3
j+=h.d
g=h.e
f=A.F(g)
B.b.af(n,new A.av(g,f.h("l(1)").a(new A.ln(h)),f.h("av<1,l>")))
e=A.i([],l)
s=7
return A.A(A.j0(h.a,new A.lo(e),null),$async$eN)
case 7:for(g=e.length,d=0;d<e.length;e.length===g||(0,A.O)(e),++d){c=e[d]
b=c.l(0,"primary")
if(typeof b=="string"){if(k==null)k=b
continue}a=c.l(0,"table")
if(typeof a!="string"||!B.b.a9(B.al,a))throw A.d(B.aY)
J.hr(o.lS(a,new A.lp()),c)}case 4:a1.length===m||(0,A.O)(a1),++i
s=3
break
case 5:if(k==null)throw A.d(B.b7)
p=A.i([A.z(["primary",k],p,t.X)],l)
for(i=0;i<14;++i){m=o.l(0,B.al[i])
if(m!=null)B.b.af(p,m)}a0=A
s=8
return A.A(A.ce(A.om(p,t.I),null),$async$eN)
case 8:q=new a0.dp(a3,"\u9c7c\u8005\u6587\u6e38-\u591a\u4f1a\u8bdd\u5408\u5e76-"+a1.length+"\u4e2a\u4f1a\u8bdd.yuzhe","\u591a\u4f1a\u8bdd\u5408\u5e76",j,n)
s=1
break
case 1:return A.a1(q,r)}})
return A.a2($async$eN,r)},
uq(a,b){var s,r,q,p
if(b===0)return null
if(!(b>=0&&b<a.length))return A.a(a,b)
s=a[b].e
if(s!=null)for(r=A.aK(a,0,A.ba(b,"count",t.S),A.F(a).c),q=r.$ti,r=new A.au(r,r.gi(0),q.h("au<P.E>")),q=q.h("P.E");r.u();){p=r.d
if(p==null)p=q.a(p)
if(p.w===s)return p.a}r=b-1
if(!(r>=0&&r<a.length))return A.a(a,r)
return a[r].a},
v4(a){var s,r=A.an("[\\r\\n\\t]+",!0),q=B.e.ad(A.bB(a,r," "))
if(q.length===0)return"Chatbox \u5bf9\u8bdd"
s=A.aS(new A.cN(q),t.al.h("h.E"))
return A.cb(A.aK(s,0,A.ba(100,"count",t.S),A.F(s).c),0,null)},
p4(a){var s,r,q,p=A.an('[\\\\/:*?"<>|\\r\\n\\t]',!0)
p=A.bB(a,p,"_")
s=A.an("\\s+",!0)
r=B.e.ad(A.bB(p,s," "))
if(r.length===0)return"\u9c7c\u8005\u6587\u6e38-\u5bf9\u8bdd\u5bfc\u5165"
q=A.aS(new A.cN(r),t.al.h("h.E"))
return A.cb(A.aK(q,0,A.ba(80,"count",t.S),A.F(q).c),0,null)},
p0(a,b){var s=b.length,r=s===0?"":B.b.gc3(b).c,q=b.length===0?"":B.b.gbB(b).c
return B.e.aS(A.eJ(B.aO.a4(B.t.a4(B.b.bi(A.i([a.d,a.a,a.b,s,r,q],t.J),"\x00"))).a),0,16)},
tK(a){var s,r
if(a==null)return null
s=A.r5(a)
if(s!=null)return s.a
r=A.oh(a,null)
if(r==null)return null
return r>1e11?r:r*1000},
uM(a){var s,r,q
try{s=B.m.cB(a,null)
r=B.m.aL(A.n3(s),null)
return r}catch(q){return a}},
n3(a){var s,r,q,p,o,n
if(t.f.b(a)){s=A.c7(t.z,t.X)
for(r=a.gbx(),r=r.gI(r);r.u();){q=r.gC()
p=q.a
o=J.aY(p)
n=A.an("[_-]",!0)
if(!B.ce.a9(0,A.bB(o.toLowerCase(),n,"")))s.D(0,p,A.n3(q.b))}return s}if(t.j.b(a)){s=J.qE(a,A.vj(),t.X)
s=A.aS(s,s.$ti.h("P.E"))
return s}return a},
dp:function dp(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
fp:function fp(a,b,c){this.a=a
this.b=b
this.c=c},
ls:function ls(){},
lt:function lt(){},
lr:function lr(a){this.a=a},
ln:function ln(a){this.a=a},
lo:function lo(a){this.a=a},
lp:function lp(){},
nR(a,b,c,d,e,f,g,h){return new A.bj(c,g,b,f,d,e,a,h)},
bE:function bE(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.w=g},
bj:function bj(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h},
i9:function i9(){},
i7:function i7(){},
i8:function i8(){},
dU:function dU(a,b,c){this.a=a
this.b=b
this.c=c},
M:function M(a){this.a=a},
pE(a){var s=a==null?null:B.e.ad(J.aY(a)).toLowerCase(),r=B.c7.l(0,s==null?"":s)
return r==null?"unknown":r},
vN(a,b){var s,r,q=b.length
if(q===0)throw A.d(B.b3)
if(q>33554432)throw A.d(B.aU)
if(q>=4&&b[0]===80&&b[1]===75)return A.uu(a,b)
s=A.tL(b)
r=B.e.i8(s)
if(B.e.bF(r,"{")||B.e.bF(r,"["))return A.us(a,s)
return A.ut(a,s)},
tL(a){var s,r,q
try{s=B.T.hx(a)
if(J.qF(s,"\ufeff"))s=J.qH(s,1)
r=s
return r}catch(q){if(A.G(q) instanceof A.ay)throw A.d(B.aW)
else throw q}},
us(a,b){var s,r,q,p,o,n,m,l,k=null
try{k=B.m.cB(b,null)}catch(s){if(A.G(s) instanceof A.ay)throw A.d(B.b2)
else throw s}r=t.b
q=A.i([],r)
p=A.i([],t.s)
A.kU(k,a,q,p,0)
if(q.length===0)throw A.d(B.b1)
o=A.ue(k)
r=A.i([],r)
for(n=q.length,m=0;m<q.length;q.length===n||(0,A.O)(q),++m){l=q[m]
r.push(new A.bj(l.a,l.b,o,l.d,l.e,l.f,l.r,l.w))}return new A.dU(o,r,p)},
ue(a){var s="Chatbox JSON"
if(t.f.b(a)){if(J.T(a.l(0,"format"),"chatbox-backup"))return"Chatbox \u5907\u4efd JSON"
if(a.a3("chat-sessions-list"))return"Chatbox JSON\uff08\u65e7\u7248\uff09"
if(a.a3("sessions"))return s
if(a.a3("chats"))return s
if(a.a3("conversations"))return"JSON \u5bf9\u8bdd"}return"JSON \u5bf9\u8bdd"},
kU(a,b,c,d,e){var s,r,q,p,o,n,m,l="messages"
if(a==null||e>6)return
s=t.j
if(s.b(a)){s=J.aj(a)
if(s.gY(a))return
if(s.ef(a,new A.kV())){for(s=s.gI(a),r=t.f;s.u();)A.kQ(r.a(s.gC()),b,c,d)
return}if(s.ef(a,new A.kW())){s=t.z
A.kQ(A.z(["messages",a],s,s),b,c,d)
return}for(s=s.gI(a),r=e+1;s.u();)A.kU(s.gC(),b,c,d,r)
return}r=t.f
if(!r.b(a))return
if(s.b(a.l(0,l))){A.kQ(a,b,c,d)
return}for(q=e+1,p=!1,o=0;o<8;++o){n=B.c5[o]
if(a.a3(n)){A.kU(a.l(0,n),b,c,d,q)
p=!0}}if(!p)for(q=a.gbk(),q=q.gI(q);q.u();){m=q.gC()
if(r.b(m)&&s.b(m.l(0,l)))A.kQ(m,b,c,d)}},
kQ(b4,b5,b6,b7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2="messages",b3=null
if(b6.length>=200)throw A.d(B.aR)
s=t.N
r=t.z
q=b4.cz(0,s,r)
p=q.a
o=q.$ti.h("4?")
n=o.a(p.l(0,b2))
m=t.j
if(!m.b(n))return
l=A.mR(q,B.bZ)
k=l==null?b3:B.e.ad(l)
j=A.mR(q,B.bQ)
if(j==null)j=A.eJ(B.a6.a4(B.t.a4(b5+"|"+b6.length+"|"+A.r(k))).a)
i=A.mR(q,B.ap)
if(i==null)i=A.ul(o.a(p.l(0,"settings")),"model")
h=A.p5(q,B.c3)
g=A.i([],t.s)
f=A.i([],t.e)
for(l=J.aj(n),e=t.f,d=0;d<l.gi(n);++d){if(d>=5e4)throw A.d(B.aT)
c=l.l(n,d)
if(!e.b(c)){B.b.m(g,"\u7b2c "+(d+1)+" \u6761\u6d88\u606f\u4e0d\u662f\u5bf9\u8c61\uff0c\u5df2\u8df3\u8fc7\uff1b\u539f\u59cb\u6587\u4ef6\u672a\u4fee\u6539\u3002")
continue}b=c.cz(0,s,r)
a=A.pE(A.eI(b,B.bY))
if(a==="unknown")B.b.m(g,"\u7b2c "+(d+1)+" \u6761\u6d88\u606f\u7f3a\u5c11\u53ef\u8bc6\u522b\u89d2\u8272\uff0c\u5df2\u6807\u8bb0\u4e3a unknown\u3002")
a0=A.tI(b,d,g)
a1=a0.a
if(a1.length>2097152)throw A.d(new A.M("\u7b2c "+(d+1)+" \u6761\u6d88\u606f\u8d85\u8fc7 2 MiB\uff0c\u672a\u8f6c\u6362\u3002"))
a2=$.nx()
if(a2.b.test(a1))throw A.d(B.b8)
a3=A.eI(b,B.bP)
a4=typeof a3=="string"&&B.e.ad(a3).length!==0?a3:b3
a3=A.eI(b,B.bX)
a5=typeof a3=="string"&&B.e.ad(a3).length!==0?a3:b3
a2=d+1
a6=B.e.cN(B.a.n(a2),6,"0")
a7=B.m.aL(b,b3)
a8=A.p5(b,B.bV)
a3=A.eI(b,B.ap)
if(typeof a3=="string")B.e.ad(a3)
B.b.m(f,new A.bE("m-"+a6,a,a1,a7,a5,a8,a4))
a1=a0.b
if(a1>0)B.b.m(g,"\u7b2c "+a2+" \u6761\u6d88\u606f\u542b "+a1+" \u4e2a\u56fe\u7247/\u9644\u4ef6\uff0c\u8f6c\u6362\u5668\u4e0d\u5305\u542b\u4e8c\u8fdb\u5236\u5185\u5bb9\u3002")
if(a0.c)B.b.m(g,"\u7b2c "+a2+" \u6761\u6d88\u606f\u7684 reasoning/thinking \u672a\u52a0\u5165\u6b63\u6587\uff08\u4e0d\u662f\u5bf9\u8bdd\u6b63\u6587\uff09\u3002")
if(a0.d)B.b.m(g,"\u7b2c "+a2+" \u6761\u6d88\u606f\u542b\u5de5\u5177\u8c03\u7528\uff1b\u5de5\u5177\u53c2\u6570\u672a\u8f6c\u6362\uff0c\u6d88\u606f\u4fdd\u7559\u4e3a\u7a7a\u6b63\u6587\u3002")}if(f.length===0){B.b.m(b7,"\u5df2\u8df3\u8fc7\u7a7a\u4f1a\u8bdd\uff1a"+(k==null?"\u672a\u547d\u540d":k))
return}a9=o.a(p.l(0,"threads"))
if(m.b(a9)&&J.m8(a9)){for(s=J.bb(a9),r=s.gI(a9),b0=0;r.u();){b1=r.gC()
if(e.b(b1)&&m.b(b1.l(0,b2)))b0+=J.B(m.a(b1.l(0,b2)))}B.b.m(g,"\u4f1a\u8bdd\u542b "+s.gi(a9)+" \u4e2a\u5386\u53f2\u7ebf\u7a0b\u3001"+b0+" \u6761\u5386\u53f2\u6d88\u606f\uff1b\u8f6c\u6362\u5668\u53ea\u4fdd\u7559\u5f53\u524d\u6d88\u606f\u65f6\u95f4\u7ebf\uff0c\u672a\u5408\u5e76\u5386\u53f2\u5206\u652f\uff08\u907f\u514d\u9519\u8bef\u6392\u5e8f\uff09\u3002")}s=k!=null
if(!s||k.length===0)B.b.m(g,"\u4f1a\u8bdd\u6ca1\u6709\u6807\u9898\uff0c\u4f7f\u7528\u201cChatbox \u5bf9\u8bdd\u201d\u4f5c\u4e3a\u9ed8\u8ba4\u6807\u9898\u3002")
B.b.m(b6,A.nR(h,"Chatbox JSON",j,f,i,b5,!s||B.e.ad(k).length===0?"Chatbox \u5bf9\u8bdd":k,g))},
tI(a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b="reasoning",a="tool_calls",a0="toolCalls",a1="text",a2="type"
for(s=t.j,r=a3.a,q=a3.$ti.h("4?"),p=0,o=0;o<4;++o){n=q.a(r.l(0,B.bK[o]))
if(s.b(n))p+=J.B(n)}m=typeof q.a(r.l(0,b))=="string"&&B.e.ad(A.a9(q.a(r.l(0,b)))).length!==0
if(!(s.b(q.a(r.l(0,a)))&&J.m8(s.a(q.a(r.l(0,a))))))l=s.b(q.a(r.l(0,a0)))&&J.m8(s.a(q.a(r.l(0,a0))))
else l=!0
k=q.a(r.l(0,"content"))
j=k==null?q.a(r.l(0,a1)):k
if(j==null)j=q.a(r.l(0,"body"))
if(typeof j=="string")return new A.bU(j,p,m,l)
i=q.a(r.l(0,"contentParts"))
if(s.b(i)){h=A.i([],t.s)
for(s=J.aO(i),r=t.f;s.u();){g=s.gC()
if(typeof g=="string")B.b.m(h,g)
else if(r.b(g)){q=g.l(0,a2)
f=q==null?null:J.aY(q)
if(B.b.a9(B.ar,f)){e=g.l(0,a1)
if(typeof e=="string")B.b.m(h,e)}else if(f==="image"||f==="image_url")++p
else if(f==="file"||f==="link")++p
else if(f==="tool_use"||f==="tool_result")l=!0}}return new A.bU(B.b.bi(h,"\n"),p,m,l)}if(s.b(j)){h=A.i([],t.s)
for(s=J.aO(j),r=t.f;s.u();){g=s.gC()
if(typeof g=="string")B.b.m(h,g)
else if(r.b(g)){q=g.l(0,a2)
f=q==null?null:J.aY(q)
if(B.b.a9(B.ar,f)){e=g.l(0,a1)
if(typeof e=="string")B.b.m(h,e)}else if(f==="image"||f==="image_url")++p
else if(f==="tool_use"||f==="tool_result")l=!0}}return new A.bU(B.b.bi(h,"\n"),p,m,l)}k=t.f
if(k.b(j)&&typeof j.l(0,a1)=="string")return new A.bU(A.a9(j.l(0,a1)),p,m,l)
d=q.a(r.l(0,"fragments"))
if(s.b(d)){h=A.i([],t.s)
for(s=J.aO(d);s.u();){c=s.gC()
if(!k.b(c))continue
r=c.l(0,a2)
f=r==null?null:J.aY(r)
if(f==="REQUEST"||f==="RESPONSE"){e=c.l(0,"content")
if(e==null)e=c.l(0,a1)
if(typeof e=="string")B.b.m(h,e)}else if(f==="THINK"||f==="REASONING")m=!0
else if(f==="FILE")++p}return new A.bU(B.b.bi(h,"\n"),p,m,l)}B.b.m(a5,"\u7b2c "+(a4+1)+" \u6761\u6d88\u606f\u6ca1\u6709\u53ef\u8bfb\u6b63\u6587\u3002")
return new A.bU("",p,m,l)},
eI(a,b){var s,r,q,p,o
for(s=b.length,r=a.a,q=a.$ti.h("4?"),p=0;p<s;++p){o=b[p]
if(r.a3(o)&&q.a(r.l(0,o))!=null)return q.a(r.l(0,o))}return null},
mR(a,b){var s=A.eI(a,b)
return typeof s=="string"&&B.e.ad(s).length!==0?s:null},
p5(a,b){var s=A.eI(a,b)
if(s==null)return null
if(typeof s=="string")return s
if(typeof s=="number")return B.w.n(s)
return J.aY(s)},
ul(a,b){if(t.f.b(a)&&typeof a.l(0,b)=="string")return A.a9(a.l(0,b))
return null},
uu(a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=null,a3=A.mH()
try{a3.b=new A.j6().lh(A.U(t.L.a(a5),B.d,a2,a2),a2,a2,a2,!0)}catch(q){throw A.d(B.aP)}if(a3.dO().a.length>5000)throw A.d(B.aQ)
p=A.i([],t.b)
o=A.i([],t.s)
n=t.d1
m=A.c7(t.N,n)
for(l=t.gm,k=new A.e2(a3.dO().a,l),k=new A.au(k,k.gi(0),l.h("au<o.E>")),j=t.f,i=t.L,l=l.h("o.E"),h=!1,g=!1,f=0;k.u();){e=k.d
if(e==null)e=l.a(e)
if(!e.ch||!B.e.c1(e.a.toLowerCase(),".json"))continue
if(e.ay>8388608){B.b.m(o,"\u8df3\u8fc7\u8d85\u8fc7 8 MiB \u7684 JSON\uff1a"+e.a)
continue}if(e.ax==null)e.hC()
d=e.ax
if(d==null)c=a2
else{d=d.a
if(d==null)d=new Uint8Array(0)
c=new A.a6(B.d)
c.bn(d,B.d,a2,a2)}s=c==null?a2:c.B()
if(s==null)continue
f+=s.length
if(f>67108864)throw A.d(B.aV)
r=null
try{d=i.a(s)
r=B.m.cB(new A.eE(!1).dh(d,0,a2,!0),a2)}catch(q){continue}if(n.b(r))m.D(0,e.a,r)
if(j.b(r)&&J.T(r.l(0,"format"),"chatbox-backup"))g=!0
if(j.b(r)&&J.T(r.l(0,"export_format_version"),3))h=!0}for(n=new A.c6(m,m.$ti.h("c6<1,2>")).gI(0);n.u();){b=n.d
l=b.a
if(l==="manifest.json"||B.e.c1(l,"index.json"))continue
A.kU(b.b,a4,p,o,0)}if(p.length===0)throw A.d(B.aX)
if(h)a="DeepSeek \u5b98\u65b9\u5bfc\u51fa ZIP"
else a=g?"Chatbox \u5907\u4efd ZIP":"ZIP JSON \u5bf9\u8bdd"
for(a0=0;a0<p.length;++a0){a1=p[a0]
B.b.D(p,a0,new A.bj(a1.a,a1.b,a,a4,a1.e,a1.f,a1.r,a1.w))}return new A.dU(a,p,o)},
ut(b2,b3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7="^(\u7528\u6237|\u73a9\u5bb6|\u6211|User|Human|You|Assistant|AI|Bot|ChatGPT|DeepSeek|\u52a9\u624b|\u6a21\u578b|System|\u7cfb\u7edf)$",a8={},a9=A.bB(b3,"\r\n","\n"),b0=A.bB(a9,"\r","\n").split("\n"),b1=A.i([],t.b)
a9=t.s
s=A.i([],a9)
r=B.b.gbB(A.bB(b2,"\\","/").split("/"))
q=B.e.lE(r,".")
p=q>0?B.e.aS(r,0,q):r
a8.a=p
a8.b=!0
a8.c=A.i([],t.e)
a8.d=a8.e=null
a8.f=0
o=A.i([],a9)
n=new A.l2(a8)
m=new A.l3(a8,n,b1,b2)
l=new A.l4()
k=new A.l5()
j=A.z([1,A.i([],a9),2,A.i([],a9)],t.S,t.x)
for(a9=b0.length,i=0;i<a9;++i){h=b0[i]
g=A.an("^\\s{0,3}(#{1,4})\\s+(.+?)\\s*$",!0).bA(h)
if(g==null)continue
f=g.b
e=f.length
if(1>=e)return A.a(f,1)
d=f[1].length
if(d>2)continue
if(2>=e)return A.a(f,2)
f=f[2]
f.toString
c=B.e.ad(f)
if(c.length===0||l.$2$allowHeading(h,!1)!=null)continue
f=A.an(a7,!1)
e=A.an("[*_`]",!0)
e=B.e.ad(A.bB(c,e,""))
if(f.b.test(e))continue
f=j.l(0,d)
f.toString
B.b.m(f,c)}a9=j.l(0,1)
a9.toString
f=j.l(0,2)
f.toString
a9=a9.length
if(a9>=2)b=1
else{f=f.length
if(f!==0)b=2
else b=a9===1?1:0}a=b===0?null:A.an("^\\s{0,3}#{"+b+"}\\s+(.+?)\\s*$",!0)
for(a9=a==null,a0=!1,a1=!1,a2=0;a2<b0.length;a2=a3){h=b0[a2]
a3=a2+1
a8.f=a3
if(B.e.bF(B.e.i8(h),"```"))a0=!a0
f=!a0
if(f){g=a9?null:a.bA(h)
if(g!=null&&l.$2$allowHeading(h,!1)==null){e=g.b
if(1>=e.length)return A.a(e,1)
e=e[1]
e.toString
c=B.e.ad(e)
if(c.length!==0){e=A.an(a7,!1)
a4=A.an("[*_`]",!0)
a4=B.e.ad(A.bB(c,a4,""))
e=!e.b.test(a4)}else e=!1
if(e){m.$0()
a8.a=c
a8.b=!1
continue}}a5=l.$1(h)
if(a5!=null){n.$0()
a8.e=A.pE(a5)
a8.d=new A.bS("")
a6=k.$1(h)
if(a6.length!==0)a8.d.a+=a6+"\n"
f=o.length
if(f!==0&&!a1){B.b.m(s,"\u9996\u4e2a\u89d2\u8272\u6807\u8bb0\u524d\u7684 "+f+" \u884c\u6587\u672c\u672a\u7eb3\u5165\u5bf9\u8bdd\uff08\u53ef\u80fd\u662f\u6807\u9898/\u8bf4\u660e\uff09\u3002")
a1=!0}continue}}if(a8.e!=null)a8.d.a+=h+"\n"
else if(f&&B.e.ad(h).length!==0)B.b.m(o,h)}m.$0()
if(b1.length===0)throw A.d(B.aS)
return new A.dU("Chatbox Markdown",b1,s)},
kV:function kV(){},
kW:function kW(){},
bU:function bU(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
l2:function l2(a){this.a=a},
l3:function l3(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
l4:function l4(){},
l5:function l5(){},
ce(a,b){return A.rH(a,b)},
rH(a,b){var s=0,r=A.a3(t.p),q,p=2,o=[],n=[],m,l,k,j,i,h,g,f
var $async$ce=A.a4(function(c,d){if(c===1){o.push(d)
s=p}for(;;)switch(s){case 0:f={}
$.np()
k=A.aS($.nq(),t.S)
k.push(1)
k.push(0)
j=new Uint8Array(A.N(k))
i=new A.ei()
h=A.oI(t.E.a(i))
g=new A.ka(A.i([],t.a))
f.a=j.length
f.b=0
g.m(0,j)
m=new A.j1(f,h,null,j,g)
k=new A.co(A.ba(a,"stream",t.K),t.eQ)
p=3
case 6:s=8
return A.A(k.u(),$async$ce)
case 8:if(!d){s=7
break}l=k.gC()
s=9
return A.A(m.$1(l),$async$ce)
case 9:s=6
break
case 7:n.push(5)
s=4
break
case 3:n=[2]
case 4:p=2
s=10
return A.A(k.hu(),$async$ce)
case 10:s=n.pop()
break
case 5:h.al()
k=i.a
k===$&&A.c()
s=11
return A.A(m.$2$last(A.z(["end",A.eJ(k.a)],t.N,t.X),!0),$async$ce)
case 11:q=g.m1()
s=1
break
case 1:return A.a1(q,r)
case 2:return A.a0(o.at(-1),r)}})
return A.a2($async$ce,r)},
j0(a,b,c){var s=!1
return A.rG(a,b,c)},
rG(a,b,c){var s=0,r=A.a3(t.N),q,p=2,o=[],n,m,l,k
var $async$j0=A.a4(function(d,e){if(d===1){o.push(e)
s=p}for(;;)switch(s){case 0:l=!1
p=4
s=7
return A.A(A.cd(a,b,c,l),$async$j0)
case 7:n=e
q=n
s=1
break
p=2
s=6
break
case 4:p=3
k=o.pop()
n=A.G(k)
if(n instanceof A.iF)throw A.d(B.cw)
else if(n instanceof A.ay)throw A.d(B.cE)
else throw k
s=6
break
case 3:s=2
break
case 6:case 1:return A.a1(q,r)
case 2:return A.a0(o.at(-1),r)}})
return A.a2($async$j0,r)},
cd(a,b,a0,a1){var s=0,r=A.a3(t.N),q,p,o,n,m,l,k,j,i,h,g,f,e,d,c
var $async$cd=A.a4(function(a2,a3){if(a2===1)return A.a0(a3,r)
for(;;)switch(s){case 0:e=new A.ky(a)
d=a.length
if(d>67108864)throw A.d(B.ax)
s=3
return A.A(A.fI(e),$async$cd)
case 3:p=a3.length
if(p>7)throw A.d(B.cy)
o=new A.ei()
n=A.oI(t.E.a(o))
p=t.L,m=t.I,l=1
case 4:if(!(l<=1e5)){s=6
break}c=A
s=7
return A.A(A.cQ(e,4),$async$cd)
case 7:k=c.al(a3).getUint32(0,!1)
if(k<2||k>8388608||k>d-e.b)throw A.d(B.cu)
s=8
return A.A(A.cQ(e,k),$async$cd)
case 8:j=a3
p.a(j)
i=B.m.cB(new A.eE(!1).dh(j,0,null,!0),null)
if(!m.b(i))throw A.d(B.cC)
s=i.a3("end")?9:10
break
case 9:n.al()
p=o.a
p===$&&A.c()
h=A.eJ(p.a)
c=i.gi(i)!==1
if(c)a3=c
else{s=11
break}s=12
break
case 11:c=h!==i.l(0,"end")
if(c)a3=c
else{s=13
break}s=14
break
case 13:c=e.b!==d
if(c)a3=c
else{s=15
break}s=16
break
case 15:c=J
s=17
return A.A(e.aX(1),$async$cd)
case 17:a3=c.B(a3)!==0
case 16:case 14:case 12:if(a3)throw A.d(B.cA)
q=h
s=1
break
case 10:g=j.length
f=new DataView(new ArrayBuffer(4))
f.setUint32(0,g,!1)
f=p.a(J.ht(B.K.gN(f)))
if(n.w)A.j(A.az("Hash.add() called after close()."))
g=f.length
n.r=n.r+g
n.d3(f,0,g)
if(n.w)A.j(A.az("Hash.add() called after close()."))
n.r=n.r+j.length
n.d3(j,0,j.length)
s=18
return A.A(b.$1(i),$async$cd)
case 18:case 5:++l
s=4
break
case 6:throw A.d(B.cB)
case 1:return A.a1(q,r)}})
return A.a2($async$cd,r)},
fI(a){var s=0,r=A.a3(t.p),q,p,o,n,m,l,k
var $async$fI=A.a4(function(b,c){if(b===1)return A.a0(c,r)
for(;;)A:switch(s){case 0:s=3
return A.A(A.cQ(a,7),$async$fI)
case 3:m=c
for(p=m.length,o=0;n=$.nq(),o<n.length;++o){if(!(o<p)){q=A.a(m,o)
s=1
break A}if(m[o]!==n[o])throw A.d(B.cD)}if(5>=p){q=A.a(m,5)
s=1
break}if(m[5]===1){if(6>=p){q=A.a(m,6)
s=1
break}n=m[6]>1}else n=!0
if(n)throw A.d(B.cx)
if(6>=p){q=A.a(m,6)
s=1
break}s=m[6]===0?4:6
break
case 4:p=m
s=5
break
case 6:p=A.aS(m,t.S)
l=B.b
k=p
s=7
return A.A(A.cQ(a,16),$async$fI)
case 7:l.af(k,c)
p=new Uint8Array(A.N(p))
case 5:q=p
s=1
break
case 1:return A.a1(q,r)}})
return A.a2($async$fI,r)},
cQ(a,b){var s=0,r=A.a3(t.p),q,p
var $async$cQ=A.a4(function(c,d){if(c===1)return A.a0(d,r)
for(;;)switch(s){case 0:s=3
return A.A(a.aX(b),$async$cQ)
case 3:p=d
if(p.length!==b)throw A.d(B.cz)
q=p
s=1
break
case 1:return A.a1(q,r)}})
return A.a2($async$cQ,r)},
j_(a){var s=new DataView(new ArrayBuffer(4))
s.setUint32(0,a,!1)
return J.ht(B.K.gN(s))},
rF(a,b){var s=A.aS(B.c.aZ(a,7,15),t.S)
B.b.af(s,A.j_(b))
return s},
aA:function aA(a){this.a=a},
j1:function j1(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
ei:function ei(){this.a=$},
ky:function ky(a){this.a=a
this.b=0},
vL(){var s,r=v.G,q=A.v(A.f(r.document).querySelector("#file")),p=A.v(A.f(r.document).querySelector("#drop"))
if(q==null||p==null)return
q.addEventListener("change",A.ae(new A.lG(q)))
p.addEventListener("dragover",A.ae(new A.lH(p)))
p.addEventListener("dragleave",A.ae(new A.lI(p)))
p.addEventListener("drop",A.ae(new A.lM(p)))
s=A.v(A.f(r.document).querySelector("#exportOne"))
if(s!=null)s.addEventListener("click",A.ae(new A.lN()))
s=A.v(A.f(r.document).querySelector("#exportZip"))
if(s!=null)s.addEventListener("click",A.ae(new A.lO()))
s=A.v(A.f(r.document).querySelector("#exportBundle"))
if(s!=null)s.addEventListener("click",A.ae(new A.lP()))
s=A.v(A.f(r.document).querySelector("#saveResult"))
if(s!=null)s.addEventListener("click",A.ae(new A.lQ()))
s=A.v(A.f(r.document).querySelector("#openYuzhe"))
if(s!=null)s.addEventListener("click",A.ae(new A.lR()))
s=A.v(A.f(r.document).querySelector("#showGuide"))
if(s!=null)s.addEventListener("click",A.ae(new A.lS()))
s=A.v(A.f(r.document).querySelector("#guideDone"))
if(s!=null)s.addEventListener("click",A.ae(new A.lT()))
s=A.v(A.f(r.document).querySelector("#guideClose"))
if(s!=null)s.addEventListener("click",A.ae(new A.lJ()))
A.f(r.window).addEventListener("online",A.ae(new A.lK()))
A.f(r.window).addEventListener("offline",A.ae(new A.lL()))
A.hj()
A.uR()
A.bX()},
mX(){var s=v.G,r=A.a9(A.f(A.f(s.window).navigator).userAgent),q=A.an("iPhone|iPad|iPod",!0)
if(!q.b.test(r))s=B.e.a9(r,"Macintosh")&&A.H(A.f(A.f(s.window).navigator).maxTouchPoints)>1
else s=!0
return s},
mP(){var s,r
try{s=A.v(v.G.FishAndroid)
return s}catch(r){return null}},
uo(){var s,r,q=null,p=A.mP()
if(p==null){A.aM("\u8bf7\u624b\u52a8\u6253\u5f00\u9c7c\u8005\u6587\u6e38 \u2192 \u5b8c\u6574\u6545\u4e8b\u5907\u4efd \u2192 \u4ece .yuzhe \u5907\u4efd\u6062\u590d\u3002\u4e0d\u8981\u4f7f\u7528\u300cDeepSeek \u5bf9\u8bdd\u5bfc\u5165\u300d\u3002",!1)
return}try{s=A.d2(A.o2(p,"openYuzhe",q,q,q,q))
if(!s)A.aM("\u6ca1\u6709\u627e\u5230\u5df2\u5b89\u88c5\u7684\u9c7c\u8005\u6587\u6e38\u3002\u8bf7\u5148\u5b89\u88c5\u539f\u7248\u5ba2\u6237\u7aef\uff0c\u518d\u624b\u52a8\u6253\u5f00\u5e76\u6062\u590d\u3002",!0)}catch(r){A.aM("\u6253\u5f00\u9c7c\u8005\u6587\u6e38\u5931\u8d25\uff0c\u8bf7\u624b\u52a8\u6253\u5f00\u5e76\u6062\u590d\u3002",!0)}},
uR(){var s,r=!1
try{r=A.mQ(A.f(A.f(v.G.window).localStorage).getItem("fish_converter_guide_v1"))==="1"}catch(s){}if(!r)A.pg()},
pg(){var s=A.v(A.f(v.G.document).querySelector("#onboarding"))
if(s!=null)A.ai(s,!1)},
oZ(){var s,r
try{A.f(A.f(v.G.window).localStorage).setItem("fish_converter_guide_v1","1")}catch(s){}r=A.v(A.f(v.G.document).querySelector("#onboarding"))
if(r!=null)A.ai(r,!0)},
bX(){var s=0,r=A.a3(t.H),q,p=2,o=[],n,m,l,k,j,i,h,g,f
var $async$bX=A.a4(function(a,b){if(a===1){o.push(b)
s=p}for(;;)switch(s){case 0:i=v.G
h=A.v(A.f(i.document).querySelector("#offlineState"))
if(h==null){s=1
break}if(A.a9(A.f(A.f(i.window).location).protocol)==="file:"){h.textContent="\u672c\u5730\u6587\u4ef6\u6a21\u5f0f\uff1a\u65e0\u9700\u7f13\u5b58\uff0c\u65ad\u7f51\u4e5f\u53ef\u4ee5\u76f4\u63a5\u8f6c\u6362\u548c\u4fdd\u5b58\u3002"
h.className="offline-state"
A.ai(h,!1)
s=1
break}n=!1
m=null
p=4
s=7
return A.A(A.cy(A.f(A.f(A.f(i.window).caches).has("fish-converter-v1.2.1-mobile")),t.y),$async$bX)
case 7:n=b
p=2
s=6
break
case 4:p=3
g=o.pop()
s=6
break
case 3:s=2
break
case 6:p=9
s=12
return A.A(A.cy(A.f(A.f(A.f(A.f(i.window).navigator).storage).persisted()),t.y),$async$bX)
case 12:m=b
p=2
s=11
break
case 9:p=8
f=o.pop()
s=11
break
case 8:s=2
break
case 11:k=!1
if(!A.d2(A.f(A.f(i.window).navigator).onLine))if(n)j="\u5f53\u524d\u79bb\u7ebf\uff1a\u6587\u4ef6\u9009\u62e9\u3001\u8f6c\u6362\u548c\u4fdd\u5b58\u90fd\u5728\u672c\u673a\u5b8c\u6210\u3002"
else{j="\u5f53\u524d\u79bb\u7ebf\uff0c\u4e14\u6ca1\u6709\u627e\u5230\u5b8c\u6574\u7f13\u5b58\u3002\u8bf7\u8054\u7f51\u91cd\u65b0\u6253\u5f00\u4e00\u6b21\u8f6c\u6362\u5668\uff0c\u518d\u65ad\u7f51\u4f7f\u7528\u3002"
k=!0}else if(!n)j="\u6b63\u5728\u51c6\u5907\u79bb\u7ebf\u7f13\u5b58\uff1b\u9996\u6b21\u52a0\u8f7d\u5b8c\u6210\u540e\u5373\u53ef\u65ad\u7f51\u8f6c\u6362\u3002"
else{k=J.T(m,!1)
j=k?"\u79bb\u7ebf\u8d44\u6e90\u5df2\u7f13\u5b58\u3002\u6d4f\u89c8\u5668\u53ef\u80fd\u5728\u7a7a\u95f4\u4e0d\u8db3\u65f6\u6e05\u7406\u7f13\u5b58\uff1b\u82e5\u65ad\u7f51\u6253\u4e0d\u5f00\uff0c\u8bf7\u8054\u7f51\u91cd\u65b0\u6253\u5f00\u4e00\u6b21\u3002":"\u79bb\u7ebf\u8d44\u6e90\u5df2\u7f13\u5b58\uff0c\u53ef\u4ee5\u65ad\u7f51\u8f6c\u6362\u548c\u4fdd\u5b58\u3002"}h.textContent=j
i=k?"offline-state warn":"offline-state"
h.className=i
A.ai(h,!1)
case 1:return A.a1(q,r)
case 2:return A.a0(o.at(-1),r)}})
return A.a2($async$bX,r)},
hj(){var s=0,r=A.a3(t.H),q=1,p=[],o,n,m,l,k,j,i,h,g
var $async$hj=A.a4(function(a,b){if(a===1){p.push(b)
s=q}for(;;)switch(s){case 0:q=3
o=A.f(A.f(A.f(v.G.window).navigator).serviceWorker)
s=6
return A.A(A.cy(A.f(o.register("service_worker.js")),t.m),$async$hj)
case 6:n=b
m=A.cy(A.f(n.update()),t.X)
l=new A.l9(n)
k=m.$ti
j=$.w
i=new A.x(j,k)
if(j!==B.n)l=A.ph(l,j)
m.bJ(new A.b5(i,2,null,l,k.h("b5<1,1>")))
s=7
return A.A(i,$async$hj)
case 7:A.bX()
q=1
s=5
break
case 3:q=2
g=p.pop()
s=5
break
case 2:s=1
break
case 5:return A.a1(null,r)
case 1:return A.a0(p.at(-1),r)}})
return A.a2($async$hj,r)},
hi(a){return A.uj(a)},
uj(a3){var s=0,r=A.a3(t.H),q,p=2,o=[],n=[],m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
var $async$hi=A.a4(function(a5,a6){if(a5===1){o.push(a6)
s=p}for(;;)A:switch(s){case 0:A.hl(null)
A.aM(null,!1)
A.kT()
try{m=A.f(A.f(A.f(v.G.window).navigator).storage)
l=null
l=m
A.cy(A.f(l.persist()),t.y).cS(new A.l_(),new A.l0(),t.P)}catch(a4){}if(A.H(a3.size)>67108864){A.hl("\u6587\u4ef6\u8d85\u8fc7 64 MiB\uff0c\u8f6c\u6362\u5668\u4e0d\u652f\u6301\u8fd9\u4e48\u5927\u7684\u5355\u6587\u4ef6\u3002")
A.pk()
s=1
break}k=A.v(A.f(v.G.document).querySelector("#fileInfo"))
if(k!=null){k.textContent="\u6b63\u5728\u8bfb\u53d6\uff1a"+A.a9(a3.name)+"\uff08"+A.ll(A.H(a3.size))+"\uff09\u2026"
A.ai(k,!1)}p=4
s=7
return A.A(A.n0(a3),$async$hi)
case 7:j=a6
i=A.vN(A.a9(a3.name),j)
$.n1=i
$.bA.bw(0)
h=i.b.length
a=t.S
g=J.nZ(h,a)
f=0
for(;;){a0=f
a1=h
if(typeof a0!=="number"){q=a0.ar()
n=[1]
s=5
break A}if(typeof a1!=="number"){q=A.Z(a1)
n=[1]
s=5
break A}if(!(a0<a1))break
e=f
J.qv(g,f,e)
a0=f
if(typeof a0!=="number"){q=a0.R()
n=[1]
s=5
break A}f=a0+1}$.bA.af(0,g)
$.l6=0
if(k!=null)k.textContent="\u5df2\u8bc6\u522b\uff1a"+A.a9(a3.name)+" \xb7 "+A.ll(A.H(a3.size))+" \xb7 "+i.a+" \xb7 "+i.b.length+" \u4e2a\u4f1a\u8bdd \xb7 "+B.b.cI(i.b,0,new A.l1(),a)+" \u6761\u6d88\u606f"
A.uC(i)
A.pj(i)
A.pi(i)
A.la(i)
A.lk("#step-preview",!0)
A.lk("#step-export",!0)
A.bX()
n.push(6)
s=5
break
case 4:p=3
a2=o.pop()
a=A.G(a2)
if(a instanceof A.M){d=a
A.p3(d.a,k)}else{c=a
A.p3("\u8f6c\u6362\u5668\u65e0\u6cd5\u8bfb\u53d6\u8fd9\u4e2a\u6587\u4ef6\uff1a"+A.r(c),k)}n.push(6)
s=5
break
case 3:n=[2]
case 5:p=2
A.pk()
s=n.pop()
break
case 6:case 1:return A.a1(q,r)
case 2:return A.a0(o.at(-1),r)}})
return A.a2($async$hi,r)},
pk(){var s=A.v(A.f(v.G.document).querySelector("#file"))
if(s!=null)s.value=""},
n0(a){var s=0,r=A.a3(t.p),q,p,o,n
var $async$n0=A.a4(function(b,c){if(b===1)return A.a0(c,r)
for(;;)switch(s){case 0:p=A.f(new v.G.FileReader())
o=new A.x($.w,t.fg)
n=new A.cg(o,t.gz)
p.onload=A.ae(new A.l7(p,n))
p.onerror=A.ae(new A.l8(n))
p.readAsArrayBuffer(a)
q=o
s=1
break
case 1:return A.a1(q,r)}})
return A.a2($async$n0,r)},
p3(a,b){$.n1=null
$.bA.bw(0)
A.kT()
if(b!=null)A.ai(b,!0)
A.hl(a)
A.lk("#step-preview",!1)
A.lk("#step-export",!1)},
uC(a){var s,r,q,p=A.v(A.f(v.G.document).querySelector("#summary"))
if(p==null)return
p.textContent=""
s=A.mg()
s.textContent="\u8bc6\u522b\u683c\u5f0f\uff1a"+a.a
p.append(s)
s=a.b
r=s.length
s=B.b.cI(s,0,new A.lc(),t.S)
q=A.mg()
q.textContent="\u5171 "+r+" \u4e2a\u4f1a\u8bdd\uff0c"+s+" \u6761\u6d88\u606f\u3002\u52fe\u9009\u8981\u5bfc\u51fa\u7684\u4f1a\u8bdd\uff1b\u9ed8\u8ba4\u5168\u9009\u3002"
p.append(q)
s=a.c
if(s.length!==0)p.append(A.pt(s))},
pj(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=v.G,e=A.v(A.f(f.document).querySelector("#sessions"))
if(e==null)return
e.textContent=""
for(s=a.b,r=0;r<s.length;++r){q=s[r]
p=r===$.l6?" active":""
o=A.f(A.f(f.document).createElement("div"))
o.className="session"+p
n=A.f(A.f(f.document).createElement("input"))
n.type="checkbox"
n.checked=$.bA.a9(0,r)
n.addEventListener("change",A.ae(new A.ld(n,r,a)))
n.addEventListener("click",A.ae(new A.le()))
m=A.f(A.f(f.document).createElement("div"))
m.className="session-main"
l=A.f(A.f(f.document).createElement("div"))
l.className="session-title"
l.textContent=q.b
m.append(l)
l=A.f(A.f(f.document).createElement("div"))
l.className="session-meta"
p=q.e
k=p.length
j=q.gey()
i=q.ge7()
h=q.gd2()
p=p.length-q.gey()-q.ge7()-q.gd2()>0?" \xb7 \u5176\u4ed6 "+(p.length-q.gey()-q.ge7()-q.gd2()):""
g=q.f
g=g==null?"":" \xb7 "+g
l.textContent=""+k+" \u6761 \xb7 \u7528\u6237 "+j+" \xb7 AI "+i+" \xb7 \u7cfb\u7edf "+h+p+g
m.append(l)
p=q.w
if(p.length!==0){l=A.f(A.f(f.document).createElement("div"))
l.className="session-warn"
l.textContent=""+p.length+" \u6761\u63d0\u793a\uff1a"+B.b.gc3(p)
m.append(l)}o.append(n)
o.append(m)
o.addEventListener("click",A.ae(new A.lf(r,a)))
e.append(o)}},
pi(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=v.G,f=A.v(A.f(g.document).querySelector("#preview"))
if(f==null||a.b.length===0)return
f.textContent=""
s=a.b
r=$.l6
if(!(r<s.length))return A.a(s,r)
q=s[r]
p=A.mf()
p.className="preview-head"
p.append(A.po(q.b,"strong"))
s=q.e
r=s.length
p.append(A.po("\u9884\u89c8\u524d "+(r>200?200:r)+"/"+r+" \u6761 \xb7 \u5168\u90e8\u6d88\u606f\u90fd\u4f1a\u5bfc\u51fa",null))
f.append(p)
o=A.mf()
o.className="messages"
n=s.length
if(n>200)n=200
for(m=0;m<n;){if(!(m<s.length))return A.a(s,m)
l=s[m]
k=A.f(A.f(g.document).createElement("div"))
k.className="msg"
j=A.f(A.f(g.document).createElement("div"))
j.className="msg-head"
r=l.b
i=A.uK(r)
h=A.f(A.f(g.document).createElement("span"))
h.textContent=i
h.className="role "+r
j.append(h);++m
h=A.f(A.f(g.document).createElement("span"))
h.textContent="#"+m
h.className="msg-no"
j.append(h)
k.append(j)
r=l.c
if(B.e.ad(r).length===0){j=A.f(A.f(g.document).createElement("div"))
j.className="msg-body empty-body"
j.textContent="\uff08\u7a7a\u6b63\u6587\uff1b\u8bf7\u67e5\u770b\u63d0\u793a\uff09"
k.append(j)}else{j=A.f(A.f(g.document).createElement("div"))
j.className="msg-body"
j.textContent=r
k.append(j)}o.append(k)}f.append(o)
g=s.length
if(g>200){s=A.mg()
s.textContent="\u4ec5\u9884\u89c8\u524d 200 \u6761\uff1b\u5bfc\u51fa\u4f1a\u5305\u542b\u5168\u90e8 "+g+" \u6761\u3002"
f.append(s)}g=q.w
if(g.length!==0)f.append(A.pt(g))},
la(a){var s,r,q,p,o,n,m=v.G,l=A.v(A.f(m.document).querySelector("#exportInfo"))
if(l==null)return
s=$.bA.a
r=$.bA.cI(0,0,new A.lb(a),t.S)
if(s===0)q="\u8bf7\u81f3\u5c11\u52fe\u9009\u4e00\u4e2a\u4f1a\u8bdd\u3002"
else{q=s===1?"\u751f\u6210\u4e00\u4e2a .yuzhe \u6587\u4ef6\u3002":"\u53ef\u5408\u5e76\u4e3a\u4e00\u4e2a .yuzhe\uff0c\u6216\u751f\u6210\u5305\u542b\u591a\u4e2a .yuzhe \u7684 ZIP\u3002"
q="\u5c06\u5bfc\u51fa "+s+" \u4e2a\u4f1a\u8bdd\uff0c\u5171 "+r+" \u6761\u6d88\u606f\u3002"+q}l.textContent=q
p=A.v(A.f(m.document).querySelector("#exportOne"))
o=A.v(A.f(m.document).querySelector("#exportZip"))
n=A.v(A.f(m.document).querySelector("#exportBundle"))
if(p!=null){m=s!==1
A.ai(p,m)
m=$.eH||m
p.disabled=m}if(o!=null){m=s<=1
A.ai(o,m)
m=$.eH||m
o.disabled=m}if(n!=null){m=s<=1
A.ai(n,m)
m=$.eH||m
n.disabled=m}},
cr(a,b){return A.tR(a,b)},
tR(a3,a4){var s=0,r=A.a3(t.H),q,p=2,o=[],n=[],m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
var $async$cr=A.a4(function(a5,a6){if(a5===1){o.push(a6)
s=p}for(;;)switch(s){case 0:a1=$.n1
if(a1==null||$.eH){s=1
break}c=A.aS($.bA,$.bA.$ti.c)
B.b.il(c)
m=c
if(J.B(m)===0){A.hl("\u8bf7\u81f3\u5c11\u52fe\u9009\u4e00\u4e2a\u4f1a\u8bdd\u3002")
s=1
break}if(a4&&J.B(m)!==1){A.hl("\u8bf7\u53ea\u52fe\u9009\u4e00\u4e2a\u4f1a\u8bdd\uff0c\u6216\u4f7f\u7528\u201c\u751f\u6210\u591a\u4f1a\u8bdd ZIP\u201d\u3002")
s=1
break}$.eH=!0
A.kT()
A.la(a1)
A.aM("\u6b63\u5728\u672c\u5730\u751f\u6210\u5f52\u6863\u2026",!1)
p=4
s=J.B(m)===1?7:9
break
case 7:k=a1.b
h=J.qC(m)
if(!(h>=0&&h<k.length)){q=A.a(k,h)
n=[1]
s=5
break}s=10
return A.A(A.eM(k[h],null,null),$async$cr)
case 10:l=a6
A.n4(l.a,l.b,"application/vnd.yuzhe.story",l.d,l.e,1)
s=8
break
case 9:b=t.b
s=a3?11:13
break
case 11:k=A.i([],b)
for(h=m,b=h.length,a=0;a<h.length;h.length===b||(0,A.O)(h),++a){j=h[a]
J.hr(k,B.b.l(a1.b,j))}s=14
return A.A(A.eN(k),$async$cr)
case 14:i=a6
A.n4(i.a,i.b,"application/vnd.yuzhe.story",i.d,i.e,1)
s=12
break
case 13:h=A.i([],b)
for(k=m,b=k.length,a=0;a<k.length;k.length===b||(0,A.O)(k),++a){g=k[a]
J.hr(h,B.b.l(a1.b,g))}s=15
return A.A(A.lq(h),$async$cr)
case 15:f=a6
A.n4(f.a,f.b,"application/zip",null,B.P,f.c)
case 12:case 8:n.push(6)
s=5
break
case 4:p=3
a2=o.pop()
k=A.G(a2)
if(k instanceof A.M){e=k
A.aM("\u672a\u751f\u6210\u5f52\u6863\uff1a"+e.a,!0)}else{d=k
A.aM("\u751f\u6210\u5931\u8d25\uff0c\u539f\u59cb\u6587\u4ef6\u672a\u4fee\u6539\uff1a"+A.r(d),!0)}n.push(6)
s=5
break
case 3:n=[2]
case 5:p=2
$.eH=!1
A.la(a1)
s=n.pop()
break
case 6:case 1:return A.a1(q,r)
case 2:return A.a0(o.at(-1),r)}})
return A.a2($async$cr,r)},
n4(a,b,c,d,e,f){var s,r,q,p,o,n,m,l
$.mS=a
$.mU=b
$.mT=c
s=v.G
r=A.v(A.f(s.document).querySelector("#resultPanel"))
q=A.v(A.f(s.document).querySelector("#resultTitle"))
p=A.v(A.f(s.document).querySelector("#resultMeta"))
o=A.v(A.f(s.document).querySelector("#saveHint"))
if(q!=null){n=f===1?"\u5df2\u751f\u6210 1 \u4e2a .yuzhe":"\u5df2\u751f\u6210 "+f+" \u4e2a .yuzhe"
q.textContent=n}if(p!=null){n=A.ll(a.length)
m=d==null?"":" \xb7 "+A.r(d)+" \u6761\u6d88\u606f"
p.textContent=b+" \xb7 "+n+m+" \xb7 \u5c1a\u672a\u4fdd\u5b58"}if(o!=null){n=A.mX()?"\u70b9\u4e0b\u9762\u6309\u94ae \u2192 \u5728\u5206\u4eab\u9762\u677f\u9009\u62e9\u201c\u5b58\u50a8\u5230\u6587\u4ef6\u201d\u3002\u4e0d\u8981\u5173\u95ed\u9875\u9762\uff0c\u6587\u4ef6\u8fd8\u5728\u5185\u5b58\u4e2d\u3002":"\u70b9\u4e0b\u9762\u6309\u94ae\u4fdd\u5b58\u5230\u624b\u673a\u7684\u4e0b\u8f7d\u76ee\u5f55\uff0c\u7136\u540e\u5230\u9c7c\u8005\u6587\u6e38\u4e2d\u6062\u590d\u3002"
o.textContent=n}if(r!=null)A.ai(r,!1)
l=A.v(A.f(s.document).querySelector("#openYuzhe"))
if(l!=null)A.ai(l,!1)
s=e.length
A.aM("\u5f52\u6863\u5df2\u751f\u6210\uff0c\u8bf7\u70b9\u201c\u4fdd\u5b58 / \u5206\u4eab\u6587\u4ef6\u201d\u3002"+(s===0?"":" \u9884\u89c8\u4e2d\u6709 "+s+" \u6761\u63d0\u793a\u3002"),!1)},
lj(){var s=0,r=A.a3(t.H),q,p,o,n,m,l,k
var $async$lj=A.a4(function(a,b){if(a===1)return A.a0(b,r)
for(;;)switch(s){case 0:m=$.mS
l=$.mU
k=$.mT
if(m==null||l==null||k==null){A.aM("\u8bf7\u5148\u751f\u6210\u5f52\u6863\u3002",!0)
s=1
break}A.aM("\u6b63\u5728\u6253\u5f00\u4fdd\u5b58/\u5206\u4eab\u9762\u677f\u2026",!1)
s=3
return A.A(A.lh(m,l,k),$async$lj)
case 3:if(!b){A.aM(A.mX()?"\u6ca1\u6709\u5b8c\u6210\u4fdd\u5b58\u3002\u53ef\u4ee5\u518d\u70b9\u4e00\u6b21\u201c\u4fdd\u5b58 / \u5206\u4eab\u6587\u4ef6\u201d\uff0c\u6216\u9009\u62e9\u201c\u5b58\u50a8\u5230\u6587\u4ef6\u201d\u3002":"\u6d4f\u89c8\u5668\u6ca1\u6709\u5b8c\u6210\u4e0b\u8f7d\u3002\u8bf7\u518d\u70b9\u4e00\u6b21\u4fdd\u5b58\uff0c\u6216\u68c0\u67e5\u4e0b\u8f7d\u6743\u9650\u3002",!0)
s=1
break}if(A.mP()!=null){A.aM("\u5df2\u6253\u5f00 Android \u7cfb\u7edf\u4fdd\u5b58\u754c\u9762\u3002\u9009\u62e9\u4f4d\u7f6e\u5e76\u786e\u8ba4\u540e\uff0c\u6587\u4ef6\u624d\u4f1a\u771f\u6b63\u5199\u5165\u3002\u5b8c\u6210\u540e\u53ef\u70b9\u201c\u6253\u5f00\u9c7c\u8005\u6587\u6e38\u201d\u3002",!1)
s=1
break}p=v.G
o=A.v(A.f(p.document).querySelector("#resultTitle"))
if(o!=null)o.textContent="\u5df2\u4fdd\u5b58"
n=A.v(A.f(p.document).querySelector("#resultMeta"))
if(n!=null)n.textContent=l+" \xb7 "+A.ll(m.length)
A.aM("\u5df2\u4fdd\u5b58 "+l+"\u3002\u73b0\u5728\u6253\u5f00\u9c7c\u8005\u6587\u6e38 \u2192 \u5b8c\u6574\u6545\u4e8b\u5907\u4efd \u2192 \u4ece .yuzhe \u5907\u4efd\u6062\u590d\u3002\u4e0d\u8981\u4f7f\u7528\u300cDeepSeek \u5bf9\u8bdd\u5bfc\u5165\u300d\u3002",!1)
case 1:return A.a1(q,r)}})
return A.a2($async$lj,r)},
kT(){var s,r,q
$.mT=$.mU=$.mS=null
s=v.G
r=A.v(A.f(s.document).querySelector("#resultPanel"))
if(r!=null)A.ai(r,!0)
q=A.v(A.f(s.document).querySelector("#openYuzhe"))
if(q!=null)A.ai(q,!0)},
lh(a,b,c){return A.uN(a,b,c)},
uN(a,a0,a1){var s=0,r=A.a3(t.y),q,p=2,o=[],n,m,l,k,j,i,h,g,f,e,d,c,b
var $async$lh=A.a4(function(a3,a4){if(a3===1){o.push(a4)
s=p}for(;;)switch(s){case 0:d=A.mP()
if(d!=null)try{t.bB.h("aD.S").a(a)
n=B.aD.ged().a4(a)
m=A.d2(A.o2(d,"saveFile",a0,a1,n,null))
q=m
s=1
break}catch(a2){q=!1
s=1
break}s=A.mX()?3:4
break
case 3:p=6
f=v.G
l=A.f(new f.File(A.i([a],t.J),a0,{type:a1}))
k={files:A.i([l],t.eO),title:a0,text:"\u9c7c\u8005\u6587\u6e38 .yuzhe \u5907\u4efd"}
s=A.d2(A.f(A.f(f.window).navigator).canShare(k))?9:10
break
case 9:p=12
s=15
return A.A(A.cy(A.f(A.f(A.f(f.window).navigator).share(k)),t.X),$async$lh)
case 15:q=!0
s=1
break
p=6
s=14
break
case 12:p=11
c=o.pop()
q=!1
s=1
break
s=14
break
case 11:s=6
break
case 14:case 10:p=2
s=8
break
case 6:p=5
b=o.pop()
s=8
break
case 5:s=2
break
case 8:case 4:try{f=v.G
j=A.f(new f.Blob(A.i([a],t.J),{type:a1}))
i=A.a9(f.URL.createObjectURL(j))
e=A.f(A.f(f.document).createElement("a"))
e.href=i
e.download=a0
e.rel="noopener"
A.f(e.style).display="none"
h=e
f=A.v(A.f(f.document).body)
if(f!=null)A.f(f.appendChild(h))
h.click()
h.remove()
A.r9(B.ba,new A.li(i),t.H)
q=!0
s=1
break}catch(a2){q=!1
s=1
break}case 1:return A.a1(q,r)
case 2:return A.a0(o.at(-1),r)}})
return A.a2($async$lh,r)},
hl(a){var s=A.v(A.f(v.G.document).querySelector("#error"))
if(s==null)return
if(a==null){A.ai(s,!0)
s.textContent=""}else{A.ai(s,!1)
s.textContent=a}},
aM(a,b){var s,r=A.v(A.f(v.G.document).querySelector("#exportStatus"))
if(r==null)return
if(a==null){A.ai(r,!0)
r.textContent=""
r.className="status"}else{A.ai(r,!1)
r.textContent=a
s=b?"status bad":"status"
r.className=s}},
ai(a,b){if(b)a.setAttribute("hidden","")
else a.removeAttribute("hidden")},
lk(a,b){var s=A.v(A.f(v.G.document).querySelector(a))
if(s!=null)A.ai(s,!b)},
ll(a){if(a<1024)return""+a+" B"
if(a<1048576)return B.w.i6(a/1024,1)+" KB"
return B.w.i6(a/1048576,1)+" MB"},
uK(a){var s
switch(a){case"user":s="\u7528\u6237"
break
case"assistant":s="AI"
break
case"system":s="\u7cfb\u7edf"
break
case"tool":s="\u5de5\u5177"
break
default:s="\u672a\u77e5"
break}return s},
po(a,b){var s=A.f(A.f(v.G.document).createElement("span"))
s.textContent=a
if(b!=null)s.className=b
return s},
pt(a){var s,r,q,p,o,n,m=A.mf()
m.className="warn-list"
s=v.G
r=A.f(A.f(s.document).createElement("ul"))
for(q=a.length,p=0;p<a.length;a.length===q||(0,A.O)(a),++p){o=a[p]
n=A.f(A.f(s.document).createElement("li"))
n.textContent=o
r.append(n)}m.append(r)
return m},
lG:function lG(a){this.a=a},
lH:function lH(a){this.a=a},
lI:function lI(a){this.a=a},
lM:function lM(a){this.a=a},
lN:function lN(){},
lO:function lO(){},
lP:function lP(){},
lQ:function lQ(){},
lR:function lR(){},
lS:function lS(){},
lT:function lT(){},
lJ:function lJ(){},
lK:function lK(){},
lL:function lL(){},
l9:function l9(a){this.a=a},
l_:function l_(){},
l0:function l0(){},
l1:function l1(){},
l7:function l7(a,b){this.a=a
this.b=b},
l8:function l8(a){this.a=a},
lc:function lc(){},
ld:function ld(a,b,c){this.a=a
this.b=b
this.c=c},
le:function le(){},
lf:function lf(a,b){this.a=a
this.b=b},
lb:function lb(a){this.a=a},
li:function li(a){this.a=a},
pL(a){return v.mangledGlobalNames[a]},
o2(a,b,c,d,e,f){var s
if(c==null)return a[b]()
else if(d==null)return a[b](c)
else if(e==null)return a[b](c,d)
else{s=a[b](c,d,e)
return s}},
qN(a,b){var s=b>>>24&255^a&255
if(!(s<256))return A.a(B.o,s)
return(b<<8^B.o[s])>>>0},
qM(a){var s,r,q=a.length,p=0
for(;;){if(!(p<q&&p<4))break
if(p<3){if(!(p<q))return A.a(a,p)
s=a[p]===B.ae[p]}else{if(!(p<q))return A.a(a,p)
r=a[p]
s=r>48&&r<=57}if(!s)return!0;++p}return!1},
w_(a){if(a===0)return 0
else if(a<=3)return 4
else if(a<=6)return 8
else if(a<=9)return 16
else if(a<=12)return 32
return 64},
vv(a,b,c,d,e,f,g,h){var s,r,q,p,o=g-3*h
if(o<0||o>h)throw A.d(A.ag("Stream split does not add up"))
for(s=0;s<4;++s){r=c[s]
q=d[s]
p=s===3?o:h
A.py(a,b,r,q,e,f+s*h,p)}},
tB(){var s,r,q=new Uint8Array(2048)
for(s=1;s<2048;++s){r=B.a.gX(s)
if(!(s<2048))return A.a(q,s)
q[s]=r-1}return q},
db(a){return B.a.gX(a)-1},
vZ(a,b,c,d,e){var s,r,q,p=A.ni(c,1099511627776)
if(d===0)s=0
else if(d<256)s=1
else{r=d<65536?2:3
s=r}a.j(40)
a.j(181)
a.j(47)
a.j(253)
r=e?32:0
a.j(r|s|4)
if(!e)a.j(p.b-10<<3>>>0)
for(q=0;q<B.V[s];++q)a.j(B.a.bb(d,q<<3>>>0)&255)
if(e)a.j(0)},
vg(a,b){a.j(b&255)
a.j(b>>>8&255)
a.j(b>>>16&255)
a.j(b>>>24&255)},
vt(a,b){var s,r,q,p,o=a.gA()
try{s=a.gi(a)
p=s
if(typeof p!=="number")return p.bD()
if(p<=0)return
p=s
if(typeof p!=="number")return p.ar()
p=p<65536?s:65536
r=new Uint8Array(p)
while(!a.gP()){q=a.az(r,0,J.B(r))
p=q
if(typeof p!=="number")return p.bD()
if(p<=0)break
b.ah(r,q)}}finally{a.S(o)}},
vA(a){var s,r,q,p
if(a instanceof A.a6)return A.vz(a.K(a.gi(0)).B(),1)
s=a.gi(a)
for(r=1,q=0;s>0;){p=3800>s?s:3800
s-=p
while(--p,p>=0){r+=a.G()
q+=r}r=B.a.E(r,65521)
q=B.a.E(q,65521)}return(q<<16|r)>>>0},
vz(a,b){var s=A.ts(a,b)
return s},
ts(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=b&65535,e=b>>>16,d=a.length
for(s=d,r=0;s>0;){q=s<3800?s:3800
s-=q
p=r+q
o=p-8
for(;r<=o;f=g){if(!(r>=0&&r<d))return A.a(a,r)
f+=a[r]
n=r+1
if(!(n<d))return A.a(a,n)
m=f+a[n]
n=r+2
if(!(n<d))return A.a(a,n)
l=m+a[n]
n=r+3
if(!(n<d))return A.a(a,n)
k=l+a[n]
n=r+4
if(!(n<d))return A.a(a,n)
j=k+a[n]
n=r+5
if(!(n<d))return A.a(a,n)
i=j+a[n]
n=r+6
if(!(n<d))return A.a(a,n)
h=i+a[n]
n=r+7
if(!(n<d))return A.a(a,n)
g=h+a[n]
e=e+f+m+l+k+j+i+h+g
r+=8}for(;r<p;++r){if(!(r>=0&&r<d))return A.a(a,r)
f+=a[r]
e+=f}f=B.a.E(f,65521)
e=B.a.E(e,65521)}return(e<<16|f)>>>0},
pA(a,b){return(B.v[(a^b)&255]^a>>>8)>>>0},
I(a,b){var s,r,q,p=a.length
if(p>=32)return A.tJ(a,b)
b^=4294967295
for(s=p,r=0;s>=8;){q=r+1
if(!(r<p))return A.a(a,r)
b=B.v[(b^a[r])&255]^b>>>8
r=q+1
if(!(q<p))return A.a(a,q)
b=B.v[(b^a[q])&255]^b>>>8
q=r+1
if(!(r<p))return A.a(a,r)
b=B.v[(b^a[r])&255]^b>>>8
r=q+1
if(!(q<p))return A.a(a,q)
b=B.v[(b^a[q])&255]^b>>>8
q=r+1
if(!(r<p))return A.a(a,r)
b=B.v[(b^a[r])&255]^b>>>8
r=q+1
if(!(q<p))return A.a(a,q)
b=B.v[(b^a[q])&255]^b>>>8
q=r+1
if(!(r<p))return A.a(a,r)
b=B.v[(b^a[r])&255]^b>>>8
r=q+1
if(!(q<p))return A.a(a,q)
b=B.v[(b^a[q])&255]^b>>>8
s-=8}if(s>0)do{q=r+1
if(!(r<p))return A.a(a,r)
b=B.v[(b^a[r])&255]^b>>>8
if(--s,s>0){r=q
continue}else break}while(!0)
return(b^4294967295)>>>0},
tC(a){var s,r,q,p,o,n,m,l=new Uint32Array(8192)
for(s=0;s<256;++s){r=a[s]
if(!(s<8192))return A.a(l,s)
l[s]=r}for(q=1;q<32;++q)for(r=(q-1)*256,p=q*256,s=0;s<256;++s){o=r+s
if(!(o>=0&&o<8192))return A.a(l,o)
n=l[o]
o=p+s
m=l[n&255]
if(!(o<8192))return A.a(l,o)
l[o]=(n>>>8^m)>>>0}return l},
tJ(c8,c9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7=$.pq
if(c7==null)c7=$.pq=A.tC(B.v)
s=c8.length
r=J.eR(B.c.gN(c8),c8.byteOffset,s)
q=c9^4294967295
p=s-32
for(o=0;o<=p;){n=q^r.getUint32(o,!0)
m=r.getUint32(o+4,!0)
l=r.getUint32(o+8,!0)
k=r.getUint32(o+12,!0)
j=r.getUint32(o+16,!0)
i=r.getUint32(o+20,!0)
h=r.getUint32(o+24,!0)
g=r.getUint32(o+28,!0)
f=c7[7936+(n&255)]
e=c7[7680+(n>>>8&255)]
d=c7[7424+(n>>>16&255)]
c=7168+(n>>>24)
if(!(c<8192))return A.a(c7,c)
c=c7[c]
b=c7[6912+(m&255)]
a=c7[6656+(m>>>8&255)]
a0=c7[6400+(m>>>16&255)]
a1=6144+(m>>>24)
if(!(a1<8192))return A.a(c7,a1)
a1=c7[a1]
a2=c7[5888+(l&255)]
a3=c7[5632+(l>>>8&255)]
a4=c7[5376+(l>>>16&255)]
a5=5120+(l>>>24)
if(!(a5<8192))return A.a(c7,a5)
a5=c7[a5]
a6=c7[4864+(k&255)]
a7=c7[4608+(k>>>8&255)]
a8=c7[4352+(k>>>16&255)]
a9=4096+(k>>>24)
if(!(a9<8192))return A.a(c7,a9)
a9=c7[a9]
b0=c7[3840+(j&255)]
b1=c7[3584+(j>>>8&255)]
b2=c7[3328+(j>>>16&255)]
b3=3072+(j>>>24)
if(!(b3<8192))return A.a(c7,b3)
b3=c7[b3]
b4=c7[2816+(i&255)]
b5=c7[2560+(i>>>8&255)]
b6=c7[2304+(i>>>16&255)]
b7=2048+(i>>>24)
if(!(b7<8192))return A.a(c7,b7)
b7=c7[b7]
b8=c7[1792+(h&255)]
b9=c7[1536+(h>>>8&255)]
c0=c7[1280+(h>>>16&255)]
c1=1024+(h>>>24)
if(!(c1<8192))return A.a(c7,c1)
c1=c7[c1]
c2=c7[768+(g&255)]
c3=c7[512+(g>>>8&255)]
c4=c7[256+(g>>>16&255)]
c5=g>>>24
if(!(c5<8192))return A.a(c7,c5)
q=f^e^d^c^b^a^a0^a1^a2^a3^a4^a5^a6^a7^a8^a9^b0^b1^b2^b3^b4^b5^b6^b7^b8^b9^c0^c1^c2^c3^c4^c7[c5]
o+=32}for(;o<s;o=c6){c6=o+1
q=c7[(q^c8[o])&255]^q>>>8}return(q^4294967295)>>>0},
lw(a,b,c){var s=0,r=A.a3(t.dI),q
var $async$lw=A.a4(function(d,e){if(d===1)return A.a0(e,r)
for(;;)switch(s){case 0:s=3
return A.A(A.cy(A.f(v.G.crypto.subtle.encrypt(a,b,c)),t.e9),$async$lw)
case 3:q=e
s=1
break
case 1:return A.a1(q,r)}})
return A.a2($async$lw,r)},
lA(a,b,c,d){var s=0,r=A.a3(t.m),q,p
var $async$lA=A.a4(function(e,f){if(e===1)return A.a0(f,r)
for(;;)switch(s){case 0:p=v.G.crypto.subtle
s=3
return A.A(A.cy(A.f(p.importKey.apply(p,["raw",a,b,c,d])),t.m),$async$lA)
case 3:q=f
s=1
break
case 1:return A.a1(q,r)}})
return A.a2($async$lA,r)},
lF(a){if(t.p.b(a))return a
return new Uint8Array(A.N(a))},
i0(a,b,c,d,e,f){var s=0,r=A.a3(t.m),q,p,o,n,m
var $async$i0=A.a4(function(g,h){if(g===1)return A.a0(h,r)
for(;;)switch(s){case 0:s=3
return A.A(a.ma(),$async$i0)
case 3:n=h
m=J.B(n)
if(m!==e)throw A.d(A.qR(m,e))
p=A.lF(n)
o=A.i([],t.s)
if(c)o.push("encrypt")
if(b)o.push("decrypt")
q=A.lA(p,f,!1,o)
s=1
break
case 1:return A.a1(q,r)}})
return A.a2($async$i0,r)},
qR(a,b){return new A.aQ(!1,null,null,"Secret key is "+a*8+" bits, expected "+b*8+" bits.")},
pw(a,b){var s,r=a.length,q=r-1,p=a.$flags|0
for(;;){if(!(b!==0&&q>=0))break
if(!(q>=0))return A.a(a,q)
s=a[q]+b
p&2&&A.b(a)
a[q]=s&255
b=s/256|0;--q}},
vy(a,b){var s,r,q,p,o,n,m=$.m3()
if(m){v.G.window.crypto.getRandomValues(a)
return}b=$.q0()
for(m=a.length,s=a.$flags|0,r=0;r<m;){q=r+3
p=r+1
if(q<m){o=b.hV(4294967296)
s&2&&A.b(a)
a[r]=o>>>24
if(!(p<m))return A.a(a,p)
a[p]=o>>>16&255
n=r+2
if(!(n<m))return A.a(a,n)
a[n]=o>>>8&255
a[q]=o&255
r+=4}else{q=b.hV(256)
s&2&&A.b(a)
a[r]=q
r=p}}},
mg(){return A.f(A.f(v.G.document).createElement("p"))},
mf(){return A.f(A.f(v.G.document).createElement("div"))}},B={}
var w=[A,J,B]
var $={}
A.mk.prototype={}
J.fh.prototype={
aC(a,b){return a===b},
ga1(a){return A.dV(a)},
n(a){return"Instance of '"+A.fw(a)+"'"},
gae(a){return A.cu(A.mV(this))}}
J.dz.prototype={
n(a){return String(a)},
ih(a,b){return b||a},
ga1(a){return a?519018:218159},
gae(a){return A.cu(t.y)},
$iE:1,
$iK:1}
J.dB.prototype={
aC(a,b){return null==b},
n(a){return"null"},
ga1(a){return 0},
$iE:1,
$iW:1}
J.dD.prototype={$iJ:1}
J.bJ.prototype={
ga1(a){return 0},
n(a){return String(a)}}
J.fv.prototype={}
J.cc.prototype={}
J.bm.prototype={
n(a){var s=a[$.pW()]
if(s==null)s=a[$.no()]
if(s==null)return this.io(a)
return"JavaScript function for "+J.aY(s)},
$ic3:1}
J.cI.prototype={
ga1(a){return 0},
n(a){return String(a)}}
J.cJ.prototype={
ga1(a){return 0},
n(a){return String(a)}}
J.u.prototype={
m(a,b){A.F(a).c.a(b)
a.$flags&1&&A.b(a,29)
a.push(b)},
af(a,b){var s
A.F(a).h("h<1>").a(b)
a.$flags&1&&A.b(a,"addAll",2)
if(Array.isArray(b)){this.iv(a,b)
return}for(s=J.aO(b);s.u();)a.push(s.gC())},
iv(a,b){var s,r
t.o.a(b)
s=b.length
if(s===0)return
if(a===b)throw A.d(A.ax(a))
for(r=0;r<s;++r)a.push(b[r])},
bw(a){a.$flags&1&&A.b(a,"clear","clear")
a.length=0},
bC(a,b,c){var s=A.F(a)
return new A.av(a,s.M(c).h("1(2)").a(b),s.h("@<1>").M(c).h("av<1,2>"))},
bi(a,b){var s,r=A.b_(a.length,"",!1,t.N)
for(s=0;s<a.length;++s)this.D(r,s,A.r(a[s]))
return r.join(b)},
cR(a,b){return A.aK(a,0,A.ba(b,"count",t.S),A.F(a).c)},
a5(a,b){return A.aK(a,b,null,A.F(a).c)},
cI(a,b,c,d){var s,r,q
d.a(b)
A.F(a).M(d).h("1(1,2)").a(c)
s=a.length
for(r=b,q=0;q<s;++q){r=c.$2(r,a[q])
if(a.length!==s)throw A.d(A.ax(a))}return r},
au(a,b){if(!(b>=0&&b<a.length))return A.a(a,b)
return a[b]},
aZ(a,b,c){var s=a.length
if(b>s)throw A.d(A.ac(b,0,s,"start",null))
if(c==null)c=s
else if(c<b||c>s)throw A.d(A.ac(c,b,s,"end",null))
if(b===c)return A.i([],A.F(a))
return A.i(a.slice(b,c),A.F(a))},
gc3(a){if(a.length>0)return a[0]
throw A.d(A.cG())},
gbB(a){var s=a.length
if(s>0)return a[s-1]
throw A.d(A.cG())},
gij(a){var s=a.length
if(s===1){if(0>=s)return A.a(a,0)
return a[0]}if(s===0)throw A.d(A.cG())
throw A.d(A.rc())},
ef(a,b){var s,r
A.F(a).h("K(1)").a(b)
s=a.length
for(r=0;r<s;++r){if(!b.$1(a[r]))return!1
if(a.length!==s)throw A.d(A.ax(a))}return!0},
il(a){var s,r,q,p,o,n
a.$flags&2&&A.b(a,"sort")
s=a.length
if(s<2)return
if(s===2){r=a[0]
q=a[1]
p=J.o1(r,q)
if(typeof p!=="number")return p.eC()
if(p>0){a[0]=q
a[1]=r}return}o=0
if(A.F(a).c.b(null))for(n=0;n<a.length;++n)if(a[n]===void 0){a[n]=null;++o}a.sort(A.d7(J.u1(),2))
if(o>0)this.kp(a,o)},
kp(a,b){var s,r=a.length
for(;s=r-1,r>0;r=s)if(a[s]===null){a[s]=void 0;--b
if(b===0)break}},
a9(a,b){var s
for(s=0;s<a.length;++s)if(J.T(a[s],b))return!0
return!1},
gY(a){return a.length===0},
gek(a){return a.length!==0},
n(a){return A.mj(a,"[","]")},
gI(a){return new J.at(a,a.length,A.F(a).h("at<1>"))},
ga1(a){return A.dV(a)},
gi(a){return a.length},
l(a,b){if(!(b>=0&&b<a.length))throw A.d(A.lu(a,b))
return a[b]},
D(a,b,c){A.F(a).c.a(c)
a.$flags&2&&A.b(a)
if(!(b>=0&&b<a.length))throw A.d(A.lu(a,b))
a[b]=c},
$iaf:1,
$in:1,
$ih:1,
$ik:1}
J.fi.prototype={
m3(a){var s,r,q
if(!Array.isArray(a))return null
s=a.$flags|0
if((s&4)!==0)r="const, "
else if((s&2)!==0)r="unmodifiable, "
else r=(s&1)!==0?"fixed, ":""
q="Instance of '"+A.fw(a)+"'"
if(r==="")return q
return q+" ("+r+"length: "+a.length+")"}}
J.ip.prototype={}
J.at.prototype={
gC(){var s=this.d
return s==null?this.$ti.c.a(s):s},
u(){var s,r=this,q=r.a,p=q.length
if(r.b!==p){q=A.O(q)
throw A.d(q)}s=r.c
if(s>=p){r.d=null
return!1}r.d=q[s]
r.c=s+1
return!0},
$iC:1}
J.cH.prototype={
be(a,b){var s
A.oV(b)
if(a<b)return-1
else if(a>b)return 1
else if(a===b){if(a===0){s=this.gcL(b)
if(this.gcL(a)===s)return 0
if(this.gcL(a))return-1
return 1}return 0}else if(isNaN(a)){if(isNaN(b))return 0
return 1}else return-1},
gcL(a){return a===0?1/a<0:a<0},
i6(a,b){var s
if(b>20)throw A.d(A.ac(b,0,20,"fractionDigits",null))
s=a.toFixed(b)
if(a===0&&this.gcL(a))return"-"+s
return s},
m2(a,b){var s,r,q,p,o
if(b<2||b>36)throw A.d(A.ac(b,2,36,"radix",null))
s=a.toString(b)
r=s.length
q=r-1
if(!(q>=0))return A.a(s,q)
if(s.charCodeAt(q)!==41)return s
p=/^([\da-z]+)(?:\.([\da-z]+))?\(e\+(\d+)\)$/.exec(s)
if(p==null)A.j(A.ao("Unexpected toString result: "+s))
r=p.length
if(1>=r)return A.a(p,1)
s=p[1]
if(3>=r)return A.a(p,3)
o=+p[3]
r=p[2]
if(r!=null){s+=r
o-=r.length}return s+B.e.b7("0",o)},
n(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
ga1(a){var s,r,q,p,o=a|0
if(a===o)return o&536870911
s=Math.abs(a)
r=Math.log(s)/0.6931471805599453|0
q=Math.pow(2,r)
p=s<1?s/q:q/s
return((p*9007199254740992|0)+(p*3542243181176521|0))*599197+r*1259&536870911},
E(a,b){var s=a%b
if(s===0)return 0
if(s>0)return s
if(b<0)return s-b
else return s+b},
a2(a,b){if((a|0)===a)if(b>=1||b<-1)return a/b|0
return this.h5(a,b)},
t(a,b){return(a|0)===a?a/b|0:this.h5(a,b)},
h5(a,b){var s=a/b
if(s>=-2147483648&&s<=2147483647)return s|0
if(s>0){if(s!==1/0)return Math.floor(s)}else if(s>-1/0)return Math.ceil(s)
throw A.d(A.ao("Result of truncating division is "+A.r(s)+": "+A.r(a)+" ~/ "+b))},
p(a,b){if(b<0)throw A.d(A.bY(b))
return b>31?0:a<<b>>>0},
q(a,b){return b>31?0:a<<b>>>0},
aJ(a,b){var s
if(b<0)throw A.d(A.bY(b))
if(a>0)s=this.ba(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
k(a,b){var s
if(a>0)s=this.ba(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
b3(a,b){if(0>b)throw A.d(A.bY(b))
return this.ba(a,b)},
ba(a,b){return b>31?0:a>>>b},
an(a,b){if(b<0)throw A.d(A.bY(b))
return this.bb(a,b)},
bb(a,b){if(b>31)return 0
return a>>>b},
gae(a){return A.cu(t.q)},
$iaE:1,
$it:1,
$iaC:1}
J.dA.prototype={
gX(a){var s,r=a<0?-a-1:a,q=r
for(s=32;q>=4294967296;){q=this.t(q,4294967296)
s+=32}return s-Math.clz32(q)},
gae(a){return A.cu(t.S)},
$iE:1,
$ie:1}
J.fj.prototype={
gae(a){return A.cu(t.i)},
$iE:1}
J.bI.prototype={
e6(a,b,c){var s=b.length
if(c>s)throw A.d(A.ac(c,0,s,null,null))
return new A.ha(b,a,c)},
hl(a,b){return this.e6(a,b,0)},
c1(a,b){var s=b.length,r=a.length
if(s>r)return!1
return b===this.eH(a,r-s)},
bF(a,b){var s=b.length
if(s>a.length)return!1
return b===a.substring(0,s)},
aS(a,b,c){return a.substring(b,A.bO(b,c,a.length))},
eH(a,b){return this.aS(a,b,null)},
ad(a){var s,r,q,p=a.trim(),o=p.length
if(o===0)return p
if(0>=o)return A.a(p,0)
if(p.charCodeAt(0)===133){s=J.o4(p,1)
if(s===o)return""}else s=0
r=o-1
if(!(r>=0))return A.a(p,r)
q=p.charCodeAt(r)===133?J.rg(p,r):o
if(s===0&&q===o)return p
return p.substring(s,q)},
i8(a){var s=a.trimStart(),r=s.length
if(r===0)return s
if(0>=r)return A.a(s,0)
if(s.charCodeAt(0)!==133)return s
return s.substring(J.o4(s,1))},
b7(a,b){var s,r
if(0>=b)return""
if(b===1||a.length===0)return a
if(b!==b>>>0)throw A.d(B.aN)
for(s=a,r="";;){if((b&1)===1)r=s+r
b=b>>>1
if(b===0)break
s+=s}return r},
cN(a,b,c){var s=b-a.length
if(s<=0)return a
return this.b7(c,s)+a},
lE(a,b){var s=a.length,r=b.length
if(s+r>s)s-=r
return a.lastIndexOf(b,s)},
a9(a,b){return A.vR(a,b,0)},
be(a,b){var s
A.a9(b)
if(a===b)s=0
else s=a<b?-1:1
return s},
n(a){return a},
ga1(a){var s,r,q
for(s=a.length,r=0,q=0;q<s;++q){r=r+a.charCodeAt(q)&536870911
r=r+((r&524287)<<10)&536870911
r^=r>>6}r=r+((r&67108863)<<3)&536870911
r^=r>>11
return r+((r&16383)<<15)&536870911},
gae(a){return A.cu(t.N)},
gi(a){return a.length},
$iaf:1,
$iE:1,
$iaE:1,
$iiB:1,
$il:1}
A.ka.prototype={
m(a,b){var s
t.L.a(b)
s=t.p.b(b)?b:new Uint8Array(A.N(b))
B.b.m(this.b,s)
this.a=this.a+s.length},
m1(){var s,r,q,p,o,n,m,l=this,k=l.a
if(k===0)return $.qd()
s=l.b
r=s.length
if(r===1){if(0>=r)return A.a(s,0)
q=s[0]
l.a=0
B.b.bw(s)
return q}q=new Uint8Array(k)
for(p=0,o=0;o<s.length;s.length===r||(0,A.O)(s),++o,p=m){n=s[o]
m=p+n.length
B.c.V(q,p,m,n)}l.a=0
B.b.bw(s)
return q},
gi(a){return this.a}}
A.cW.prototype={
gI(a){var s=this.a
return new A.dl(s.gI(s),A.y(this).h("dl<1,2>"))},
gi(a){var s=this.a
return s.gi(s)},
gY(a){var s=this.a
return s.gY(s)},
a9(a,b){return this.a.a9(0,b)},
n(a){return this.a.n(0)}}
A.dl.prototype={
u(){return this.a.u()},
gC(){return this.$ti.y[1].a(this.a.gC())},
$iC:1}
A.c1.prototype={}
A.ej.prototype={$in:1}
A.c2.prototype={
cz(a,b,c){return new A.c2(this.a,this.$ti.h("@<1,2>").M(b).M(c).h("c2<1,2,3,4>"))},
a3(a){return this.a.a3(a)},
l(a,b){return this.$ti.h("4?").a(this.a.l(0,b))},
aO(a,b){this.a.aO(0,new A.i5(this,this.$ti.h("~(3,4)").a(b)))},
gap(){var s=this.$ti
return A.nP(this.a.gap(),s.c,s.y[2])},
gbk(){var s=this.$ti
return A.nP(this.a.gbk(),s.y[1],s.y[3])},
gi(a){var s=this.a
return s.gi(s)},
gY(a){var s=this.a
return s.gY(s)},
gbx(){return this.a.gbx().bC(0,new A.i4(this),this.$ti.h("a7<3,4>"))}}
A.i5.prototype={
$2(a,b){var s=this.a.$ti
s.c.a(a)
s.y[1].a(b)
this.b.$2(s.y[2].a(a),s.y[3].a(b))},
$S(){return this.a.$ti.h("~(1,2)")}}
A.i4.prototype={
$1(a){var s=this.a.$ti
s.h("a7<1,2>").a(a)
return new A.a7(s.y[2].a(a.a),s.y[3].a(a.b),s.h("a7<3,4>"))},
$S(){return this.a.$ti.h("a7<3,4>(a7<1,2>)")}}
A.c5.prototype={
n(a){return"LateInitializationError: "+this.a}}
A.f2.prototype={
gi(a){return this.a.length},
l(a,b){var s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s.charCodeAt(b)}}
A.lV.prototype={
$0(){return A.ra(null,t.H)},
$S:27}
A.iG.prototype={}
A.n.prototype={}
A.P.prototype={
gI(a){var s=this
return new A.au(s,s.gi(s),A.y(s).h("au<P.E>"))},
gY(a){return this.gi(this)===0},
a9(a,b){var s,r=this,q=r.gi(r)
for(s=0;s<q;++s){if(J.T(r.au(0,s),b))return!0
if(q!==r.gi(r))throw A.d(A.ax(r))}return!1},
bC(a,b,c){var s=A.y(this)
return new A.av(this,s.M(c).h("1(P.E)").a(b),s.h("@<P.E>").M(c).h("av<1,2>"))},
a5(a,b){return A.aK(this,b,null,A.y(this).h("P.E"))},
cR(a,b){return A.aK(this,0,A.ba(b,"count",t.S),A.y(this).h("P.E"))}}
A.e0.prototype={
gja(){var s=J.B(this.a),r=this.c
if(r==null||r>s)return s
return r},
gkD(){var s=J.B(this.a),r=this.b
if(r>s)return s
return r},
gi(a){var s,r=J.B(this.a),q=this.b
if(q>=r)return 0
s=this.c
if(s==null||s>=r)return r-q
return s-q},
au(a,b){var s=this,r=s.gkD()+b
if(b<0||r>=s.gja())throw A.d(A.mi(b,s.gi(0),s,"index"))
return J.nF(s.a,r)},
a5(a,b){var s,r,q=this
A.bN(b,"count")
s=q.b+b
r=q.c
if(r!=null&&s>=r)return new A.dt(q.$ti.h("dt<1>"))
return A.aK(q.a,s,r,q.$ti.c)},
cR(a,b){var s,r,q,p=this
A.bN(b,"count")
s=p.c
r=p.b
q=r+b
if(s==null)return A.aK(p.a,r,q,p.$ti.c)
else{if(s<q)return p
return A.aK(p.a,r,q,p.$ti.c)}},
i5(a,b){var s,r,q,p=this,o=p.b,n=p.a,m=J.aj(n),l=m.gi(n),k=p.c
if(k!=null&&k<l)l=k
s=l-o
if(s<=0){n=p.$ti.c
return b?J.o0(0,n):J.o_(0,n)}r=A.b_(s,m.au(n,o),b,p.$ti.c)
for(q=1;q<s;++q){B.b.D(r,q,m.au(n,o+q))
if(m.gi(n)<l)throw A.d(A.ax(p))}return r},
i4(a){return this.i5(0,!0)}}
A.au.prototype={
gC(){var s=this.d
return s==null?this.$ti.c.a(s):s},
u(){var s,r=this,q=r.a,p=J.aj(q),o=p.gi(q)
if(r.b!==o)throw A.d(A.ax(q))
s=r.c
if(s>=o){r.d=null
return!1}r.d=p.au(q,s);++r.c
return!0},
$iC:1}
A.c8.prototype={
gI(a){return new A.dL(J.aO(this.a),this.b,A.y(this).h("dL<1,2>"))},
gi(a){return J.B(this.a)},
gY(a){return J.nG(this.a)}}
A.ds.prototype={$in:1}
A.dL.prototype={
u(){var s=this,r=s.b
if(r.u()){s.a=s.c.$1(r.gC())
return!0}s.a=null
return!1},
gC(){var s=this.a
return s==null?this.$ti.y[1].a(s):s},
$iC:1}
A.av.prototype={
gi(a){return J.B(this.a)},
au(a,b){return this.b.$1(J.nF(this.a,b))}}
A.aT.prototype={
gI(a){return new A.e4(J.aO(this.a),this.b,this.$ti.h("e4<1>"))}}
A.e4.prototype={
u(){var s,r
for(s=this.a,r=this.b;s.u();)if(r.$1(s.gC()))return!0
return!1},
gC(){return this.a.gC()},
$iC:1}
A.dt.prototype={
gI(a){return B.aG},
gY(a){return!0},
gi(a){return 0},
a9(a,b){return!1}}
A.du.prototype={
u(){return!1},
gC(){throw A.d(A.cG())},
$iC:1}
A.dy.prototype={
gi(a){return J.B(this.a)},
gY(a){return J.nG(this.a)},
a9(a,b){return!1},
gI(a){return new A.bl(J.aO(this.a),this.b,A.y(this).h("bl<1>"))}}
A.dr.prototype={
a9(a,b){return!1},
$in:1}
A.bl.prototype={
u(){if(++this.c>=0&&this.a.u())return!0
this.c=-2
return!1},
gC(){var s=this.c
return s>=0?new A.cn(this.b+s,this.a.gC()):A.j(A.cG())},
$iC:1}
A.R.prototype={
si(a,b){throw A.d(A.ao("Cannot change the length of a fixed-length list"))},
m(a,b){A.ar(a).h("R.E").a(b)
throw A.d(A.ao("Cannot add to a fixed-length list"))}}
A.b3.prototype={
D(a,b,c){A.y(this).h("b3.E").a(c)
throw A.d(A.ao("Cannot modify an unmodifiable list"))},
si(a,b){throw A.d(A.ao("Cannot change the length of an unmodifiable list"))},
m(a,b){A.y(this).h("b3.E").a(b)
throw A.d(A.ao("Cannot add to an unmodifiable list"))},
V(a,b,c,d){A.y(this).h("h<b3.E>").a(d)
throw A.d(A.ao("Cannot modify an unmodifiable list"))}}
A.cP.prototype={}
A.b0.prototype={
gi(a){return J.B(this.a)},
au(a,b){var s=this.a,r=J.aj(s)
return r.au(s,r.gi(s)-1-b)}}
A.cn.prototype={$r:"+(1,2)",$s:1}
A.bw.prototype={$r:"+mode,size(1,2)",$s:2}
A.d_.prototype={$r:"+(1,2,3)",$s:3}
A.cB.prototype={
cz(a,b,c){var s=A.y(this)
return A.ob(this,s.c,s.y[1],b,c)},
gY(a){return this.gi(this)===0},
n(a){return A.mn(this)},
gbx(){return new A.bx(this.lx(),A.y(this).h("bx<a7<1,2>>"))},
lx(){var s=this
return function(){var r=0,q=1,p=[],o,n,m,l,k
return function $async$gbx(a,b,c){if(b===1){p.push(c)
r=q}for(;;)switch(r){case 0:o=s.gap(),o=o.gI(o),n=A.y(s),m=n.y[1],n=n.h("a7<1,2>")
case 2:if(!o.u()){r=3
break}l=o.gC()
k=s.l(0,l)
r=4
return a.b=new A.a7(l,k==null?m.a(k):k,n),1
case 4:r=2
break
case 3:return 0
case 1:return a.c=p.at(-1),3}}}},
$iV:1}
A.dn.prototype={
gi(a){return this.b.length},
gfD(){var s=this.$keys
if(s==null){s=Object.keys(this.a)
this.$keys=s}return s},
a3(a){if(typeof a!="string")return!1
if("__proto__"===a)return!1
return this.a.hasOwnProperty(a)},
l(a,b){if(!this.a3(b))return null
return this.b[this.a[b]]},
aO(a,b){var s,r,q,p
this.$ti.h("~(1,2)").a(b)
s=this.gfD()
r=this.b
for(q=s.length,p=0;p<q;++p)b.$2(s[p],r[p])},
gap(){return new A.cj(this.gfD(),this.$ti.h("cj<1>"))},
gbk(){return new A.cj(this.b,this.$ti.h("cj<2>"))}}
A.cj.prototype={
gi(a){return this.a.length},
gY(a){return 0===this.a.length},
gI(a){var s=this.a
return new A.ck(s,s.length,this.$ti.h("ck<1>"))}}
A.ck.prototype={
gC(){var s=this.d
return s==null?this.$ti.c.a(s):s},
u(){var s=this,r=s.c
if(r>=s.b){s.d=null
return!1}s.d=s.a[r]
s.c=r+1
return!0},
$iC:1}
A.c4.prototype={
bq(){var s=this,r=s.$map
if(r==null){r=new A.dE(s.$ti.h("dE<1,2>"))
A.pz(s.a,r)
s.$map=r}return r},
a3(a){return this.bq().a3(a)},
l(a,b){return this.bq().l(0,b)},
aO(a,b){this.$ti.h("~(1,2)").a(b)
this.bq().aO(0,b)},
gap(){var s=this.bq()
return new A.bo(s,A.y(s).h("bo<1>"))},
gbk(){var s=this.bq()
return new A.bp(s,A.y(s).h("bp<2>"))},
gi(a){return this.bq().a}}
A.dm.prototype={
m(a,b){A.y(this).c.a(b)
A.qZ()}}
A.cC.prototype={
gi(a){return this.b},
gY(a){return this.b===0},
gI(a){var s,r=this,q=r.$keys
if(q==null){q=Object.keys(r.a)
r.$keys=q}s=q
return new A.ck(s,s.length,r.$ti.h("ck<1>"))},
a9(a,b){if(typeof b!="string")return!1
if("__proto__"===b)return!1
return this.a.hasOwnProperty(b)}}
A.dX.prototype={}
A.iP.prototype={
aP(a){var s,r,q=this,p=new RegExp(q.a).exec(a)
if(p==null)return null
s=Object.create(null)
r=q.b
if(r!==-1)s.arguments=p[r+1]
r=q.c
if(r!==-1)s.argumentsExpr=p[r+1]
r=q.d
if(r!==-1)s.expr=p[r+1]
r=q.e
if(r!==-1)s.method=p[r+1]
r=q.f
if(r!==-1)s.receiver=p[r+1]
return s}}
A.dT.prototype={
n(a){return"Null check operator used on a null value"}}
A.fk.prototype={
n(a){var s,r=this,q="NoSuchMethodError: method not found: '",p=r.b
if(p==null)return"NoSuchMethodError: "+r.a
s=r.c
if(s==null)return q+p+"' ("+r.a+")"
return q+p+"' on '"+s+"' ("+r.a+")"}}
A.fD.prototype={
n(a){var s=this.a
return s.length===0?"Error":"Error: "+s}}
A.iz.prototype={
n(a){return"Throw of null ('"+(this.a===null?"null":"undefined")+"' from JavaScript)"}}
A.dv.prototype={}
A.ex.prototype={
n(a){var s,r=this.b
if(r!=null)return r
r=this.a
s=r!==null&&typeof r==="object"?r.stack:null
return this.b=s==null?"":s},
$ib2:1}
A.bD.prototype={
n(a){var s=this.constructor,r=s==null?null:s.name
return"Closure '"+A.pM(r==null?"unknown":r)+"'"},
$ic3:1,
gm6(){return this},
$C:"$1",
$R:1,
$D:null}
A.f0.prototype={$C:"$0",$R:0}
A.f1.prototype={$C:"$2",$R:2}
A.fB.prototype={}
A.fz.prototype={
n(a){var s=this.$static_name
if(s==null)return"Closure of unknown static method"
return"Closure '"+A.pM(s)+"'"}}
A.cA.prototype={
aC(a,b){if(b==null)return!1
if(this===b)return!0
if(!(b instanceof A.cA))return!1
return this.$_target===b.$_target&&this.a===b.a},
ga1(a){return(A.nd(this.a)^A.dV(this.$_target))>>>0},
n(a){return"Closure '"+this.$_name+"' of "+("Instance of '"+A.fw(this.a)+"'")}}
A.fy.prototype={
n(a){return"RuntimeError: "+this.a}}
A.bn.prototype={
gi(a){return this.a},
gY(a){return this.a===0},
gap(){return new A.bo(this,A.y(this).h("bo<1>"))},
gbk(){return new A.bp(this,A.y(this).h("bp<2>"))},
gbx(){return new A.c6(this,A.y(this).h("c6<1,2>"))},
a3(a){var s,r
if(typeof a=="string"){s=this.b
if(s==null)return!1
return s[a]!=null}else if(typeof a=="number"&&(a&0x3fffffff)===a){r=this.c
if(r==null)return!1
return r[a]!=null}else return this.lC(a)},
lC(a){var s=this.d
if(s==null)return!1
return this.cK(this.fq(s,a),a)>=0},
l(a,b){var s,r,q,p,o=null
if(typeof b=="string"){s=this.b
if(s==null)return o
r=s[b]
q=r==null?o:r.b
return q}else if(typeof b=="number"&&(b&0x3fffffff)===b){p=this.c
if(p==null)return o
r=p[b]
q=r==null?o:r.b
return q}else return this.lD(b)},
lD(a){var s,r,q=this.d
if(q==null)return null
s=this.fq(q,a)
r=this.cK(s,a)
if(r<0)return null
return s[r].b},
D(a,b,c){var s,r,q,p,o,n,m=this,l=A.y(m)
l.c.a(b)
l.y[1].a(c)
if(typeof b=="string"){s=m.b
m.eL(s==null?m.b=m.dE():s,b,c)}else if(typeof b=="number"&&(b&0x3fffffff)===b){r=m.c
m.eL(r==null?m.c=m.dE():r,b,c)}else{q=m.d
if(q==null)q=m.d=m.dE()
p=m.eh(b)
o=q[p]
if(o==null)q[p]=[m.dF(b,c)]
else{n=m.cK(o,b)
if(n>=0)o[n].b=c
else o.push(m.dF(b,c))}}},
lS(a,b){var s,r,q=this,p=A.y(q)
p.c.a(a)
p.h("2()").a(b)
if(q.a3(a)){s=q.l(0,a)
return s==null?p.y[1].a(s):s}r=b.$0()
q.D(0,a,r)
return r},
aO(a,b){var s,r,q=this
A.y(q).h("~(1,2)").a(b)
s=q.e
r=q.r
while(s!=null){b.$2(s.a,s.b)
if(r!==q.r)throw A.d(A.ax(q))
s=s.c}},
eL(a,b,c){var s,r=A.y(this)
r.c.a(b)
r.y[1].a(c)
s=a[b]
if(s==null)a[b]=this.dF(b,c)
else s.b=c},
jN(){this.r=this.r+1&1073741823},
dF(a,b){var s=this,r=A.y(s),q=new A.ir(r.c.a(a),r.y[1].a(b))
if(s.e==null)s.e=s.f=q
else{r=s.f
r.toString
q.d=r
s.f=r.c=q}++s.a
s.jN()
return q},
eh(a){return J.as(a)&1073741823},
fq(a,b){return a[this.eh(b)]},
cK(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.T(a[r].a,b))return r
return-1},
n(a){return A.mn(this)},
dE(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s},
$imm:1}
A.ir.prototype={}
A.bo.prototype={
gi(a){return this.a.a},
gY(a){return this.a.a===0},
gI(a){var s=this.a
return new A.dI(s,s.r,s.e,this.$ti.h("dI<1>"))},
a9(a,b){return this.a.a3(b)}}
A.dI.prototype={
gC(){return this.d},
u(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.d(A.ax(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.a
r.c=s.c
return!0}},
$iC:1}
A.bp.prototype={
gi(a){return this.a.a},
gY(a){return this.a.a===0},
gI(a){var s=this.a
return new A.dJ(s,s.r,s.e,this.$ti.h("dJ<1>"))}}
A.dJ.prototype={
gC(){return this.d},
u(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.d(A.ax(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.b
r.c=s.c
return!0}},
$iC:1}
A.c6.prototype={
gi(a){return this.a.a},
gY(a){return this.a.a===0},
gI(a){var s=this.a
return new A.dH(s,s.r,s.e,this.$ti.h("dH<1,2>"))}}
A.dH.prototype={
gC(){var s=this.d
s.toString
return s},
u(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.d(A.ax(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=new A.a7(s.a,s.b,r.$ti.h("a7<1,2>"))
r.c=s.c
return!0}},
$iC:1}
A.dE.prototype={
eh(a){return A.vq(a)&1073741823},
cK(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.T(a[r].a,b))return r
return-1}}
A.lB.prototype={
$1(a){return this.a(a)},
$S:19}
A.lC.prototype={
$2(a,b){return this.a(a,b)},
$S:45}
A.lD.prototype={
$1(a){return this.a(A.a9(a))},
$S:15}
A.b7.prototype={
n(a){return this.h7(!1)},
h7(a){var s,r,q,p,o,n=this.jg(),m=this.dz(),l=(a?"Record ":"")+"("
for(s=n.length,r="",q=0;q<s;++q,r=", "){l+=r
p=n[q]
if(typeof p=="string")l=l+p+": "
if(!(q<m.length))return A.a(m,q)
o=m[q]
l=a?l+A.oi(o):l+A.r(o)}l+=")"
return l.charCodeAt(0)==0?l:l},
jg(){var s,r=this.$s
while($.kB.length<=r)B.b.m($.kB,null)
s=$.kB[r]
if(s==null){s=this.iS()
B.b.D($.kB,r,s)}return s},
iS(){var s,r,q,p=this.$r,o=p.indexOf("("),n=p.substring(1,o),m=p.substring(o),l=m==="()"?0:m.replace(/[^,]/g,"").length+1,k=t.K,j=J.nZ(l,k)
for(s=0;s<l;++s)j[s]=s
if(n!==""){r=n.split(",")
s=r.length
for(q=l;s>0;){--q;--s
B.b.D(j,q,r[s])}}j=A.ri(j,!1,k)
j.$flags=3
return j}}
A.cm.prototype={
dz(){return[this.a,this.b]},
aC(a,b){if(b==null)return!1
return b instanceof A.cm&&this.$s===b.$s&&J.T(this.a,b.a)&&J.T(this.b,b.b)},
ga1(a){return A.iA(this.$s,this.a,this.b,B.G)}}
A.cZ.prototype={
dz(){return[this.a,this.b,this.c]},
aC(a,b){var s=this
if(b==null)return!1
return b instanceof A.cZ&&s.$s===b.$s&&J.T(s.a,b.a)&&J.T(s.b,b.b)&&J.T(s.c,b.c)},
ga1(a){var s=this
return A.iA(s.$s,s.a,s.b,s.c)}}
A.dC.prototype={
n(a){return"RegExp/"+this.a+"/"+this.b.flags},
gfI(){var s=this,r=s.c
if(r!=null)return r
r=s.b
return s.c=A.o5(s.a,r.multiline,!r.ignoreCase,r.unicode,r.dotAll,"g")},
bA(a){var s=this.b.exec(a)
if(s==null)return null
return new A.eo(s)},
e6(a,b,c){var s=b.length
if(c>s)throw A.d(A.ac(c,0,s,null,null))
return new A.fN(this,b,c)},
hl(a,b){return this.e6(0,b,0)},
fk(a,b){var s,r=this.gfI()
if(r==null)r=A.b8(r)
r.lastIndex=b
s=r.exec(a)
if(s==null)return null
return new A.eo(s)},
$iiB:1,
$irw:1}
A.eo.prototype={
geG(){return this.b.index},
gcD(){var s=this.b
return s.index+s[0].length},
$icK:1,
$idW:1}
A.fN.prototype={
gI(a){return new A.fO(this.a,this.b,this.c)}}
A.fO.prototype={
gC(){var s=this.d
return s==null?t.cz.a(s):s},
u(){var s,r,q,p,o,n,m=this,l=m.b
if(l==null)return!1
s=m.c
r=l.length
if(s<=r){q=m.a
p=q.fk(l,s)
if(p!=null){m.d=p
o=p.gcD()
if(p.b.index===o){s=!1
if(q.b.unicode){q=m.c
n=q+1
if(n<r){if(!(q>=0&&q<r))return A.a(l,q)
q=l.charCodeAt(q)
if(q>=55296&&q<=56319){if(!(n>=0))return A.a(l,n)
s=l.charCodeAt(n)
s=s>=56320&&s<=57343}}}o=(s?o+1:o)+1}m.c=o
return!0}}m.b=m.d=null
return!1},
$iC:1}
A.fA.prototype={
gcD(){return this.a+this.c.length},
$icK:1,
geG(){return this.a}}
A.ha.prototype={
gI(a){return new A.hb(this.a,this.b,this.c)}}
A.hb.prototype={
u(){var s,r,q=this,p=q.c,o=q.b,n=o.length,m=q.a,l=m.length
if(p+n>l){q.d=null
return!1}s=m.indexOf(o,p)
if(s<0){q.c=l+1
q.d=null
return!1}r=s+n
q.d=new A.fA(s,o)
q.c=r===q.c?r+1:r
return!0},
gC(){var s=this.d
s.toString
return s},
$iC:1}
A.kb.prototype={
dO(){var s=this.b
if(s===this)throw A.d(new A.c5("Local '' has not been initialized."))
return s},
cm(){var s=this.b
if(s===this)throw A.d(A.iq(""))
return s}}
A.bK.prototype={
ghP(a){return a.byteLength},
gae(a){return B.ch},
bs(a,b,c){A.cq(a,b,c)
return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
hp(a){return this.bs(a,0,null)},
hn(a,b,c){A.cq(a,b,c)
c=B.a.t(a.byteLength-b,2)
return new Uint16Array(a,b,c)},
ho(a,b,c){A.cq(a,b,c)
if(c==null)c=B.a.t(a.byteLength-b,4)
return new Uint32Array(a,b,c)},
cw(a,b,c){A.cq(a,b,c)
return c==null?new DataView(a,b):new DataView(a,b,c)},
hm(a){return this.cw(a,0,null)},
$iE:1,
$ibK:1,
$idj:1}
A.cL.prototype={$icL:1}
A.dO.prototype={
gN(a){if(((a.$flags|0)&2)!==0)return new A.hf(a.buffer)
else return a.buffer},
jG(a,b,c,d){var s=A.ac(b,0,c,d,null)
throw A.d(s)},
eW(a,b,c,d){if(b>>>0!==b||b>c)this.jG(a,b,c,d)},
$iY:1}
A.hf.prototype={
ghP(a){return this.a.byteLength},
bs(a,b,c){var s=A.od(this.a,b,c)
s.$flags=3
return s},
hp(a){return this.bs(0,0,null)},
hn(a,b,c){var s=A.rm(this.a,b,c)
s.$flags=3
return s},
ho(a,b,c){var s=A.ro(this.a,b,c)
s.$flags=3
return s},
cw(a,b,c){var s=A.rk(this.a,b,c)
s.$flags=3
return s},
hm(a){return this.cw(0,0,null)},
$idj:1}
A.dM.prototype={
gae(a){return B.ci},
$iE:1,
$imb:1}
A.ad.prototype={
gi(a){return a.length},
fZ(a,b,c,d,e){var s,r,q
t.gu.a(d)
s=a.length
this.eW(a,b,s,"start")
this.eW(a,c,s,"end")
if(b>c)throw A.d(A.ac(b,0,c,null,null))
r=c-b
if(e<0)throw A.d(A.bd(e,null))
q=d.length
if(q-e<r)throw A.d(A.az("Not enough elements"))
if(e!==0||q!==r)d=d.subarray(e,e+r)
a.set(d,b)},
$iaf:1,
$iaG:1}
A.bL.prototype={
l(a,b){A.bz(b,a,a.length)
return a[b]},
D(a,b,c){A.oT(c)
a.$flags&2&&A.b(a)
A.bz(b,a,a.length)
a[b]=c},
V(a,b,c,d){t.bM.a(d)
a.$flags&2&&A.b(a,5)
if(t.d4.b(d)){this.fZ(a,b,c,d,0)
return}this.eI(a,b,c,d,0)},
$in:1,
$ih:1,
$ik:1}
A.aH.prototype={
D(a,b,c){A.H(c)
a.$flags&2&&A.b(a)
A.bz(b,a,a.length)
a[b]=c},
H(a,b,c,d,e){t.hb.a(d)
a.$flags&2&&A.b(a,5)
if(t.eB.b(d)){this.fZ(a,b,c,d,e)
return}this.eI(a,b,c,d,e)},
V(a,b,c,d){return this.H(a,b,c,d,0)},
$in:1,
$ih:1,
$ik:1}
A.fq.prototype={
gae(a){return B.cj},
$iE:1}
A.fr.prototype={
gae(a){return B.ck},
$iE:1}
A.fs.prototype={
gae(a){return B.cl},
l(a,b){A.bz(b,a,a.length)
return a[b]},
$iE:1,
$iff:1}
A.dN.prototype={
gae(a){return B.cm},
l(a,b){A.bz(b,a,a.length)
return a[b]},
$iE:1,
$ifg:1}
A.ft.prototype={
gae(a){return B.cn},
l(a,b){A.bz(b,a,a.length)
return a[b]},
$iE:1}
A.dP.prototype={
gae(a){return B.cp},
l(a,b){A.bz(b,a,a.length)
return a[b]},
$iE:1,
$imz:1}
A.dR.prototype={
gae(a){return B.cq},
l(a,b){A.bz(b,a,a.length)
return a[b]},
$iE:1,
$ie1:1}
A.dS.prototype={
gae(a){return B.cr},
gi(a){return a.length},
l(a,b){A.bz(b,a,a.length)
return a[b]},
$iE:1}
A.c9.prototype={
gae(a){return B.cs},
gi(a){return a.length},
l(a,b){A.bz(b,a,a.length)
return a[b]},
aZ(a,b,c){return new Uint8Array(a.subarray(b,A.d3(b,c,a.length)))},
$iE:1,
$ic9:1,
$ibh:1}
A.er.prototype={}
A.es.prototype={}
A.et.prototype={}
A.eu.prototype={}
A.b1.prototype={
h(a){return A.eD(v.typeUniverse,this,a)},
M(a){return A.oP(v.typeUniverse,this,a)}}
A.h_.prototype={}
A.hd.prototype={
n(a){return A.aL(this.a,null)}}
A.fZ.prototype={
n(a){return this.a}}
A.ez.prototype={$ibs:1}
A.k4.prototype={
$1(a){var s=this.a,r=s.a
s.a=null
r.$0()},
$S:16}
A.k3.prototype={
$1(a){var s,r
this.a.a=t.M.a(a)
s=this.b
r=this.c
s.firstChild?s.removeChild(r):s.appendChild(r)},
$S:43}
A.k5.prototype={
$0(){this.a.$0()},
$S:18}
A.k6.prototype={
$0(){this.a.$0()},
$S:18}
A.kF.prototype={
it(a,b){if(self.setTimeout!=null)self.setTimeout(A.d7(new A.kG(this,b),0),a)
else throw A.d(A.ao("`setTimeout()` not found."))}}
A.kG.prototype={
$0(){this.b.$0()},
$S:0}
A.fP.prototype={
cA(a){var s,r=this,q=r.$ti
q.h("1/?").a(a)
if(a==null)a=q.c.a(a)
if(!r.b)r.a.bL(a)
else{s=r.a
if(q.h("am<1>").b(a))s.eT(a)
else s.df(a)}},
e9(a,b){var s
if(b==null)b=A.cz(a)
s=this.a
if(this.b)s.bo(new A.aa(a,b))
else s.bM(new A.aa(a,b))}}
A.kR.prototype={
$1(a){return this.a.$2(0,a)},
$S:10}
A.kS.prototype={
$2(a,b){this.a.$2(1,new A.dv(a,t.l.a(b)))},
$S:38}
A.lm.prototype={
$2(a,b){this.a(A.H(a),b)},
$S:35}
A.cp.prototype={
gC(){var s=this.b
return s==null?this.$ti.c.a(s):s},
kq(a,b){var s,r,q
a=A.H(a)
b=b
s=this.a
for(;;)try{r=s(this,a,b)
return r}catch(q){b=q
a=1}},
u(){var s,r,q,p,o=this,n=null,m=0
for(;;){s=o.d
if(s!=null)try{if(s.u()){o.b=s.gC()
return!0}else o.d=null}catch(r){n=r
m=1
o.d=null}q=o.kq(m,n)
if(1===q)return!0
if(0===q){o.b=null
p=o.e
if(p==null||p.length===0){o.a=A.oJ
return!1}if(0>=p.length)return A.a(p,-1)
o.a=p.pop()
m=0
n=null
continue}if(2===q){m=0
n=null
continue}if(3===q){n=o.c
o.c=null
p=o.e
if(p==null||p.length===0){o.b=null
o.a=A.oJ
throw n
return!1}if(0>=p.length)return A.a(p,-1)
o.a=p.pop()
m=1
continue}throw A.d(A.az("sync*"))}return!1},
m8(a){var s,r,q=this
if(a instanceof A.bx){s=a.a()
r=q.e
if(r==null)r=q.e=[]
B.b.m(r,q.a)
q.a=s
return 2}else{q.d=J.aO(a)
return 2}},
$iC:1}
A.bx.prototype={
gI(a){return new A.cp(this.a(),this.$ti.h("cp<1>"))}}
A.aa.prototype={
n(a){return A.r(this.a)},
$iL:1,
gbE(){return this.b}}
A.ij.prototype={
$0(){var s,r,q,p,o,n,m=this,l=m.a
if(l==null){m.c.a(null)
m.b.cc(null)}else{s=null
try{s=l.$0()}catch(p){r=A.G(p)
q=A.aq(p)
l=r
o=q
n=A.hh(l,o)
l=new A.aa(l,o)
m.b.bo(l)
return}m.b.cc(s)}},
$S:0}
A.fR.prototype={
e9(a,b){var s=this.a
if((s.a&30)!==0)throw A.d(A.az("Future already completed"))
s.bM(A.pa(a,b))},
c_(a){return this.e9(a,null)}}
A.cg.prototype={
cA(a){var s,r=this.$ti
r.h("1/?").a(a)
s=this.a
if((s.a&30)!==0)throw A.d(A.az("Future already completed"))
s.bL(r.h("1/").a(a))}}
A.b5.prototype={
lJ(a){var s
if((this.c&15)!==6)return!0
s=this.b.b
return s.cp(s,t.bN.a(this.d),a.a,t.y,t.K)},
lA(a){var s,r=this,q=r.e,p=null,o=t.z,n=t.K,m=a.a,l=r.b.b
if(t.Q.b(q))p=l.fT(l,q,m,a.b,o,n,t.l)
else p=l.cp(l,t.v.a(q),m,o,n)
try{o=r.$ti.h("2/").a(p)
return o}catch(s){if(t.eK.b(A.G(s))){if((r.c&1)!==0)throw A.d(A.bd("The error handler of Future.then must return a value of the returned future's type","onError"))
throw A.d(A.bd("The error handler of Future.catchError must return a value of the future's type","onError"))}else throw s}}}
A.x.prototype={
cS(a,b,c){var s,r,q,p=this.$ti
p.M(c).h("1/(2)").a(a)
s=$.w
if(s===B.n){if(b!=null&&!t.Q.b(b)&&!t.v.b(b))throw A.d(A.aZ(b,"onError",u.c))}else{r=p.c
a=s.cn(s,c.h("@<0/>").M(r).h("1(2)").a(a),c.h("0/"),r)
if(b!=null)b=A.ph(b,s)}q=new A.x(s,c.h("x<0>"))
r=b==null?1:3
this.bJ(new A.b5(q,r,a,b,p.h("@<1>").M(c).h("b5<1,2>")))
return q},
md(a,b){return this.cS(a,null,b)},
h6(a,b,c){var s,r=this.$ti
r.M(c).h("1/(2)").a(a)
s=new A.x($.w,c.h("x<0>"))
this.bJ(new A.b5(s,19,a,b,r.h("@<1>").M(c).h("b5<1,2>")))
return s},
cT(a){var s,r,q
t.O.a(a)
s=this.$ti
r=$.w
q=new A.x(r,s)
if(r!==B.n)a=r.bU(r,a,t.z)
this.bJ(new A.b5(q,8,a,null,s.h("b5<1,1>")))
return q},
kw(a){this.a=this.a&1|16
this.c=a},
cb(a){this.a=a.a&30|this.a&1
this.c=a.c},
bJ(a){var s,r=this,q=r.a
if(q<=3){a.a=t.F.a(r.c)
r.c=a}else{if((q&4)!==0){s=t._.a(r.c)
if((s.a&24)===0){s.bJ(a)
return}r.cb(s)}q=r.b
q.b2(q,new A.kh(r,a))}},
fN(a){var s,r,q,p,o,n,m=this,l={}
l.a=a
if(a==null)return
s=m.a
if(s<=3){r=t.F.a(m.c)
m.c=a
if(r!=null){q=a.a
for(p=a;q!=null;p=q,q=o)o=q.a
p.a=r}}else{if((s&4)!==0){n=t._.a(m.c)
if((n.a&24)===0){n.fN(a)
return}m.cb(n)}l.a=m.co(a)
s=m.b
s.b2(s,new A.km(l,m))}},
bV(){var s=t.F.a(this.c)
this.c=null
return this.co(s)},
co(a){var s,r,q
for(s=a,r=null;s!=null;r=s,s=q){q=s.a
s.a=r}return r},
cc(a){var s,r=this,q=r.$ti
q.h("1/").a(a)
if(q.h("am<1>").b(a))A.kk(a,r,!0)
else{s=r.bV()
q.c.a(a)
r.a=8
r.c=a
A.ci(r,s)}},
df(a){var s,r=this
r.$ti.c.a(a)
s=r.bV()
r.a=8
r.c=a
A.ci(r,s)},
iQ(a){var s=this.bV()
this.cb(a)
A.ci(this,s)},
bo(a){var s=this.bV()
this.kw(a)
A.ci(this,s)},
iP(a,b){A.b8(a)
t.l.a(b)
this.bo(new A.aa(a,b))},
bL(a){var s=this.$ti
s.h("1/").a(a)
if(s.h("am<1>").b(a)){this.eT(a)
return}this.eP(a)},
eP(a){var s,r=this
r.$ti.c.a(a)
r.a^=2
s=r.b
s.b2(s,new A.kj(r,a))},
eT(a){A.kk(this.$ti.h("am<1>").a(a),this,!1)
return},
bM(a){var s
this.a^=2
s=this.b
s.b2(s,new A.ki(this,a))},
$iam:1}
A.kh.prototype={
$0(){A.ci(this.a,this.b)},
$S:0}
A.km.prototype={
$0(){A.ci(this.b,this.a.a)},
$S:0}
A.kl.prototype={
$0(){A.kk(this.a.a,this.b,!0)},
$S:0}
A.kj.prototype={
$0(){this.a.df(this.b)},
$S:0}
A.ki.prototype={
$0(){this.a.bo(this.b)},
$S:0}
A.kp.prototype={
$0(){var s,r,q,p,o,n,m,l,k=this,j=null
try{q=k.a.a
p=q.b.b
j=p.cq(p,t.O.a(q.d),t.z)}catch(o){s=A.G(o)
r=A.aq(o)
if(k.c&&t.n.a(k.b.a.c).a===s){q=k.a
q.c=t.n.a(k.b.a.c)}else{q=s
p=r
if(p==null)p=A.cz(q)
n=k.a
n.c=new A.aa(q,p)
q=n}q.b=!0
return}if(j instanceof A.x&&(j.a&24)!==0){if((j.a&16)!==0){q=k.a
q.c=t.n.a(j.c)
q.b=!0}return}if(j instanceof A.x){m=k.b.a
l=new A.x(m.b,m.$ti)
j.cS(new A.kq(l,m),new A.kr(l),t.H)
q=k.a
q.c=l
q.b=!1}},
$S:0}
A.kq.prototype={
$1(a){this.a.iQ(this.b)},
$S:16}
A.kr.prototype={
$2(a,b){A.b8(a)
t.l.a(b)
this.a.bo(new A.aa(a,b))},
$S:32}
A.ko.prototype={
$0(){var s,r,q,p,o,n,m,l,k
try{q=this.a
p=q.a
o=p.$ti
n=o.c
m=n.a(this.b)
l=p.b.b
q.c=l.cp(l,o.h("2/(1)").a(p.d),m,o.h("2/"),n)}catch(k){s=A.G(k)
r=A.aq(k)
q=s
p=r
if(p==null)p=A.cz(q)
o=this.a
o.c=new A.aa(q,p)
o.b=!0}},
$S:0}
A.kn.prototype={
$0(){var s,r,q,p,o,n,m,l=this
try{s=t.n.a(l.a.a.c)
p=l.b
if(p.a.lJ(s)&&p.a.e!=null){p.c=p.a.lA(s)
p.b=!1}}catch(o){r=A.G(o)
q=A.aq(o)
p=t.n.a(l.a.a.c)
if(p.a===r){n=l.b
n.c=p
p=n}else{p=r
n=q
if(n==null)n=A.cz(p)
m=l.b
m.c=new A.aa(p,n)
p=m}p.b=!0}},
$S:0}
A.fQ.prototype={}
A.dZ.prototype={
gi(a){var s={},r=new A.x($.w,t.fJ)
s.a=0
this.hQ(new A.iM(s,this),!0,new A.iN(s,r),r.giO())
return r}}
A.iK.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j={}
this.b.h("iw<0>").a(a)
j.a=null
try{p=this.a
j.a=new J.at(p,p.length,A.F(p).h("at<1>"))}catch(o){s=A.G(o)
r=A.aq(o)
j=s
p=r
n=A.hh(j,p)
j=new A.aa(j,p==null?A.cz(j):p)
q=j
j=q.a
p=q.b
if(a.b>=4)A.j(a.bN())
m=A.pa(j,p)
q=m.a
l=m.b
j=a.b
if((j&1)!==0)a.gbc().bK(new A.cY(q,l))
else if((j&3)===0)a.fj().m(0,new A.cY(q,l))
a.al()
return}k=$.w
j.b=!0
p=new A.iL(j,a,k)
a.slM(new A.iJ(j,k,p))
k.b2(k,t.M.a(p))},
$S(){return this.b.h("~(iw<0>)")}}
A.iL.prototype={
$0(){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=h.b
if((g.b&1)!==0)l=(g.gbc().e&4)!==0
else l=!0
if(l){h.a.b=!1
return}s=null
try{s=h.a.a.u()}catch(k){r=A.G(k)
q=A.aq(k)
l=r
j=q
i=A.hh(l,j)
l=new A.aa(l,j==null?A.cz(l):j)
p=l
g.hk(p.a,p.b)
g.hw()
return}if(s){try{l=h.a.a
j=l.d
l=j==null?l.$ti.c.a(j):j
g.$ti.c.a(l)
j=g.b
if(j>=4)A.j(g.bN())
if((j&1)!==0)g.gbc().iy(l)}catch(k){o=A.G(k)
n=A.aq(k)
l=o
j=n
i=A.hh(l,j)
l=new A.aa(l,j==null?A.cz(l):j)
m=l
g.hk(m.a,m.b)}if((g.b&1)!==0){g=g.gbc().e
g=(g&4)===0}else g=!1
if(g){g=h.c
g.b2(g,t.M.a(h))}else h.a.b=!1}else g.hw()},
$S:0}
A.iJ.prototype={
$0(){var s=this.a
if(!s.b){s.b=!0
s=this.b
s.b2(s,t.M.a(this.c))}},
$S:0}
A.iM.prototype={
$1(a){this.b.$ti.c.a(a);++this.a.a},
$S(){return this.b.$ti.h("~(1)")}}
A.iN.prototype={
$0(){this.b.cc(this.a.a)},
$S:0}
A.d0.prototype={
gkb(){var s,r=this
if((r.b&8)===0)return r.$ti.h("b6<1>?").a(r.a)
s=r.$ti
return s.h("b6<1>?").a(s.h("d1<1>").a(r.a).ge_())},
fj(){var s,r,q=this
if((q.b&8)===0){s=q.a
if(s==null)s=q.a=new A.b6(q.$ti.h("b6<1>"))
return q.$ti.h("b6<1>").a(s)}r=q.$ti
s=r.h("d1<1>").a(q.a).ge_()
return r.h("b6<1>").a(s)},
gbc(){var s=this.a
if((this.b&8)!==0)s=t.fv.a(s).ge_()
return this.$ti.h("ch<1>").a(s)},
bN(){if((this.b&4)!==0)return new A.bR("Cannot add event after closing")
return new A.bR("Cannot add event while adding a stream")},
fi(){var s=this.c
if(s==null)s=this.c=(this.b&2)!==0?$.eP():new A.x($.w,t.D)
return s},
al(){var s=this,r=s.b
if((r&4)!==0)return s.fi()
if(r>=4)throw A.d(s.bN())
r=s.b=r|4
if((r&1)!==0)s.gbc().bK(B.U)
else if((r&3)===0)s.fj().m(0,B.U)
return s.fi()},
kG(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.$ti
h.h("~(1)?").a(a)
t.Z.a(c)
if((i.b&3)!==0)throw A.d(A.az("Stream has already been listened to."))
s=h.c
r=$.w
q=d?1:0
p=b!=null?32:0
o=t.H
s=r.cn(r,t.a7.M(s).h("1(2)").a(a),o,s)
n=A.t_(r,b)
m=c==null?A.vn():c
l=new A.ch(i,s,n,r.bU(r,t.M.a(m),o),r,q|p,h.h("ch<1>"))
k=i.gkb()
if(((i.b|=1)&8)!==0){j=h.h("d1<1>").a(i.a)
j.se_(l)
j.cP()}else i.a=l
l.kx(k)
l.dB(new A.kE(i))
return l},
kn(a){var s,r,q,p,o,n,m,l,k=this,j=k.$ti
j.h("e_<1>").a(a)
s=null
if((k.b&8)!==0)s=j.h("d1<1>").a(k.a).hu()
k.a=null
k.b=k.b&4294967286|2
r=k.r
if(r!=null)if(s==null)try{q=r.$0()
if(q instanceof A.x)s=q}catch(n){p=A.G(n)
o=A.aq(n)
m=new A.x($.w,t.D)
j=A.b8(p)
l=t.l.a(o)
m.bM(new A.aa(j,l))
s=m}else s=s.cT(r)
j=new A.kD(k)
if(s!=null)s=s.cT(j)
else j.$0()
return s},
slL(a){this.d=t.Z.a(a)},
slM(a){this.f=t.Z.a(a)},
$imL:1,
$ibV:1,
$iS:1}
A.kE.prototype={
$0(){A.hk(this.a.d)},
$S:0}
A.kD.prototype={
$0(){var s=this.a.c
if(s!=null&&(s.a&30)===0)s.bL(null)},
$S:0}
A.ee.prototype={}
A.cV.prototype={}
A.ch.prototype={
jW(){var s=this.w,r=s.$ti
r.h("e_<1>").a(this)
if((s.b&8)!==0)r.h("d1<1>").a(s.a).en()
A.hk(s.e)},
jY(){var s=this.w,r=s.$ti
r.h("e_<1>").a(this)
if((s.b&8)!==0)r.h("d1<1>").a(s.a).cP()
A.hk(s.f)}}
A.ef.prototype={
kx(a){var s=this
s.$ti.h("b6<1>?").a(a)
if(a==null)return
s.r=a
if(a.c!=null){s.e=(s.e|128)>>>0
a.c8(s)}},
en(){var s,r,q=this,p=q.e
if((p&8)!==0)return
s=(p+256|4)>>>0
q.e=s
if(p<256){r=q.r
if(r!=null)if(r.a===1)r.a=3}if((p&4)===0&&(s&64)===0)q.dB(q.gjV())},
cP(){var s=this,r=s.e
if((r&8)!==0)return
if(r>=256){r=s.e=r-256
if(r<256)if((r&128)!==0&&s.r.c!=null)s.r.c8(s)
else{r=(r&4294967291)>>>0
s.e=r
if((r&64)===0)s.dB(s.gjX())}}},
d8(){var s,r=this,q=r.e=(r.e|8)>>>0
if((q&128)!==0){s=r.r
if(s.a===1)s.a=3}if((q&64)===0)r.r=null
r.f=r.w.kn(r)},
iy(a){var s,r=this,q=r.$ti
q.c.a(a)
s=r.e
if((s&8)!==0)return
if(s<64)r.fV(a)
else r.bK(new A.eh(a,q.h("eh<1>")))},
iw(a,b){var s
if(t.C.b(a))A.mt(a,b)
s=this.e
if((s&8)!==0)return
if(s<64)this.fX(a,b)
else this.bK(new A.cY(a,b))},
iM(){var s=this,r=s.e
if((r&8)!==0)return
r=(r|2)>>>0
s.e=r
if(r<64)s.fW()
else s.bK(B.U)},
bK(a){var s,r=this,q=r.r
if(q==null)q=r.r=new A.b6(r.$ti.h("b6<1>"))
q.m(0,a)
s=r.e
if((s&128)===0){s=(s|128)>>>0
r.e=s
if(s<256)q.c8(r)}},
fV(a){var s,r=this,q=r.$ti.c
q.a(a)
s=r.e
r.e=(s|64)>>>0
r.d.i3(r.a,a,q)
r.e=(r.e&4294967231)>>>0
r.dc((s&4)!==0)},
fX(a,b){var s,r=this,q=r.e,p=new A.k9(r,a,b)
if((q&1)!==0){r.e=(q|16)>>>0
r.d8()
s=r.f
if(s!=null&&s!==$.eP())s.cT(p)
else p.$0()}else{p.$0()
r.dc((q&4)!==0)}},
fW(){var s,r=this,q=new A.k8(r)
r.d8()
r.e=(r.e|16)>>>0
s=r.f
if(s!=null&&s!==$.eP())s.cT(q)
else q.$0()},
dB(a){var s,r=this
t.M.a(a)
s=r.e
r.e=(s|64)>>>0
a.$0()
r.e=(r.e&4294967231)>>>0
r.dc((s&4)!==0)},
dc(a){var s,r,q,p,o,n=this,m=n.e
if((m&128)!==0&&n.r.c==null){m=n.e=(m&4294967167)>>>0
s=!1
if((m&4)!==0)if(m<256){s=n.r
s=s==null?null:s.c==null
s=s!==!1}if(s){m=(m&4294967291)>>>0
n.e=m}}for(s=n.w,r=s.$ti,q=r.h("e_<1>"),r=r.h("d1<1>"),p=s.e;;a=o){if((m&8)!==0){n.r=null
return}o=(m&4)!==0
if(a===o)break
n.e=(m^64)>>>0
if(o){q.a(n)
if((s.b&8)!==0)r.a(s.a).en()
A.hk(p)}else{q.a(n)
if((s.b&8)!==0)r.a(s.a).cP()
A.hk(s.f)}m=(n.e&4294967231)>>>0
n.e=m}if((m&128)!==0&&m<256)n.r.c8(n)},
$ie_:1,
$ibV:1}
A.k9.prototype={
$0(){var s,r,q,p=this.a,o=p.e
if((o&8)!==0&&(o&16)===0)return
p.e=(o|64)>>>0
s=p.b
o=this.b
r=t.K
q=p.d
if(t.da.b(s))q.m0(s,o,this.c,r,t.l)
else q.i3(t.d5.a(s),o,r)
p.e=(p.e&4294967231)>>>0},
$S:0}
A.k8.prototype={
$0(){var s=this.a,r=s.e
if((r&16)===0)return
s.e=(r|74)>>>0
s.d.i2(s.c)
s.e=(s.e&4294967231)>>>0},
$S:0}
A.bv.prototype={
sc4(a){this.a=t.ev.a(a)},
gc4(){return this.a}}
A.eh.prototype={
ep(a){this.$ti.h("bV<1>").a(a).fV(this.b)}}
A.cY.prototype={
ep(a){a.fX(this.b,this.c)}}
A.fY.prototype={
ep(a){a.fW()},
gc4(){return null},
sc4(a){throw A.d(A.az("No events after a done."))},
$ibv:1}
A.b6.prototype={
c8(a){var s,r=this
r.$ti.h("bV<1>").a(a)
s=r.a
if(s===1)return
if(s>=1){r.a=1
return}A.vQ(new A.kA(r,a))
r.a=1},
m(a,b){var s=this,r=s.c
if(r==null)s.b=s.c=b
else{r.sc4(b)
s.c=b}}}
A.kA.prototype={
$0(){var s,r,q,p=this.a,o=p.a
p.a=0
if(o===3)return
s=p.$ti.h("bV<1>").a(this.b)
r=p.b
q=r.gc4()
p.b=q
if(q==null)p.c=null
r.ep(s)},
$S:0}
A.co.prototype={
gC(){var s=this
if(s.c)return s.$ti.c.a(s.b)
return s.$ti.c.a(null)},
u(){var s,r=this,q=r.a
if(q!=null){if(r.c){s=new A.x($.w,t.k)
r.b=s
r.c=!1
q.cP()
return s}throw A.d(A.az("Already waiting for next."))}return r.jC()},
jC(){var s,r,q=this,p=q.b
if(p!=null){q.$ti.h("dZ<1>").a(p)
s=new A.x($.w,t.k)
q.b=s
r=p.hQ(q.gjP(),!0,q.gjR(),q.gjT())
if(q.b!=null)q.a=r
return s}return $.pY()},
hu(){var s,r=this,q=r.a,p=r.b
r.b=null
if(q!=null){r.a=null
if(!r.c)t.k.a(p).bL(!1)
else r.c=!1
s=(q.e&4294967279)>>>0
q.e=s
if((s&8)===0)q.d8()
s=q.f
return s==null?$.eP():s}return $.eP()},
jQ(a){var s,r,q=this
q.$ti.c.a(a)
if(q.a==null)return
s=t.k.a(q.b)
q.b=a
q.c=!0
s.cc(!0)
if(q.c){r=q.a
if(r!=null)r.en()}},
jU(a,b){var s,r,q=this
A.b8(a)
t.l.a(b)
s=q.a
r=t.k.a(q.b)
q.b=q.a=null
if(s!=null)r.bo(new A.aa(a,b))
else r.bM(new A.aa(a,b))},
jS(){var s=this,r=s.a,q=t.k.a(s.b)
s.b=s.a=null
if(r!=null)q.df(!1)
else q.eP(!1)}}
A.ep.prototype={
hQ(a,b,c,d){var s,r=null,q=this.$ti
q.h("~(1)?").a(a)
t.Z.a(c)
s=new A.eq(r,r,r,r,q.h("eq<1>"))
s.slL(new A.kz(this,s))
return s.kG(a,d,c,b===!0)}}
A.kz.prototype={
$0(){this.a.b.$1(this.b)},
$S:0}
A.eq.prototype={
hk(a,b){var s=this.b
if(s>=4)throw A.d(this.bN())
if((s&1)!==0){s=this.gbc()
s.iw(a,b)}},
hw(){var s=this,r=s.b
if((r&4)!==0)return
if(r>=4)throw A.d(s.bN())
r|=4
s.b=r
if((r&1)!==0)s.gbc().iM()},
$iiw:1}
A.jo.prototype={
i2(a){var s,r,q,p,o=this
t.M.a(a)
try{q=o.cq(o,a,t.H)
return q}catch(p){s=A.G(p)
r=A.aq(p)
o.b8(o,s,r)}},
i3(a,b,c){var s,r,q,p,o=this
c.h("~(0)").a(a)
c.a(b)
try{q=o.cp(o,a,b,t.H,c)
return q}catch(p){s=A.G(p)
r=A.aq(p)
o.b8(o,s,r)}},
m0(a,b,c,d,e){var s,r,q,p,o=this
d.h("@<0>").M(e).h("~(1,2)").a(a)
d.a(b)
e.a(c)
try{q=o.fT(o,a,b,c,t.H,d,e)
return q}catch(p){s=A.G(p)
r=A.aq(p)
o.b8(o,s,r)}},
hs(a,b){return new A.jq(this,this.bU(this,b.h("0()").a(a),b),b)},
l0(a){return new A.jp(this,this.bU(this,t.M.a(a),t.H))},
b8(a,b,c){var s,r,q,p,o,n,m,l
t.l.a(c)
s=null
if(s==null){A.uL(b,c)
return}r=s.geA()
q=r.gm7()
p=$.w
try{$.w=q
s.lz(r,r.gdI(),a,b,c)
$.w=p}catch(m){o=A.G(m)
n=A.aq(m)
$.w=p
l=b===o?c:n
q.b8(r,o,l)}},
cq(a,b,c){var s,r,q
c.h("0()").a(b)
r=$.w
if(r===a)return b.$0()
s=r
$.w=a
try{r=b.$0()
return r}finally{$.w=s}q=null.geA()
return null.mb(q,q.gdI(),a,b)},
cp(a,b,c,d,e){var s,r,q
d.h("@<0>").M(e).h("1(2)").a(b)
e.a(c)
r=$.w
if(r===a)return b.$1(c)
s=r
$.w=a
try{r=b.$1(c)
return r}finally{$.w=s}q=null.geA()
return null.lz(q,q.gdI(),a,b,c)},
fT(a,b,c,d,e,f,g){var s,r,q
e.h("@<0>").M(f).M(g).h("1(2,3)").a(b)
f.a(c)
g.a(d)
r=$.w
if(r===a)return b.$2(c,d)
s=r
$.w=a
try{r=b.$2(c,d)
return r}finally{$.w=s}q=null.geA()
return null.mc(q,q.gdI(),a,b,c,d)},
bU(a,b,c){c.h("0()").a(b)
return b},
cn(a,b,c,d){c.h("@<0>").M(d).h("1(2)").a(b)
return b},
dR(a,b,c,d,e){c.h("@<0>").M(d).M(e).h("1(2,3)").a(b)
return b},
jb(a,b,c){return null},
b2(a,b){A.n2(a,t.M.a(b))
return},
f0(a,b,c){t.M.a(c)
return A.on(b,B.n!==a?a.hs(c,t.H):c)}}
A.jq.prototype={
$0(){var s=this.a
return s.cq(s,this.b,this.c)},
$S(){return this.c.h("0()")}}
A.jp.prototype={
$0(){return this.a.i2(this.b)},
$S:0}
A.lg.prototype={
$0(){A.me(this.a,this.b)},
$S:0}
A.ek.prototype={
gI(a){var s=this,r=new A.el(s,s.r,s.$ti.h("el<1>"))
r.c=s.e
return r},
gi(a){return this.a},
gY(a){return this.a===0},
a9(a,b){var s,r
if(typeof b=="string"&&b!=="__proto__"){s=this.b
if(s==null)return!1
return t.g.a(s[b])!=null}else if(typeof b=="number"&&(b&1073741823)===b){r=this.c
if(r==null)return!1
return t.g.a(r[b])!=null}else return this.iT(b)},
iT(a){var s=this.d
if(s==null)return!1
return this.du(s[J.as(a)&1073741823],a)>=0},
m(a,b){var s,r,q=this
q.$ti.c.a(b)
if(typeof b=="string"&&b!=="__proto__"){s=q.b
return q.eY(s==null?q.b=A.mJ():s,b)}else if(typeof b=="number"&&(b&1073741823)===b){r=q.c
return q.eY(r==null?q.c=A.mJ():r,b)}else return q.iN(b)},
iN(a){var s,r,q,p=this
p.$ti.c.a(a)
s=p.d
if(s==null)s=p.d=A.mJ()
r=J.as(a)&1073741823
q=s[r]
if(q==null)s[r]=[p.de(a)]
else{if(p.du(q,a)>=0)return!1
q.push(p.de(a))}return!0},
lZ(a,b){var s=this
if(typeof b=="string"&&b!=="__proto__")return s.fR(s.b,b)
else if(typeof b=="number"&&(b&1073741823)===b)return s.fR(s.c,b)
else return s.ko(b)},
ko(a){var s,r,q,p,o=this.d
if(o==null)return!1
s=J.as(a)&1073741823
r=o[s]
q=this.du(r,a)
if(q<0)return!1
p=r.splice(q,1)[0]
if(0===r.length)delete o[s]
this.h9(p)
return!0},
bw(a){var s=this
if(s.a>0){s.b=s.c=s.d=s.e=s.f=null
s.a=0
s.dd()}},
eY(a,b){this.$ti.c.a(b)
if(t.g.a(a[b])!=null)return!1
a[b]=this.de(b)
return!0},
fR(a,b){var s
if(a==null)return!1
s=t.g.a(a[b])
if(s==null)return!1
this.h9(s)
delete a[b]
return!0},
dd(){this.r=this.r+1&1073741823},
de(a){var s,r=this,q=new A.h4(r.$ti.c.a(a))
if(r.e==null)r.e=r.f=q
else{s=r.f
s.toString
q.c=s
r.f=s.b=q}++r.a
r.dd()
return q},
h9(a){var s=this,r=a.c,q=a.b
if(r==null)s.e=q
else r.b=q
if(q==null)s.f=r
else q.c=r;--s.a
s.dd()},
du(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.T(a[r].a,b))return r
return-1}}
A.h4.prototype={}
A.el.prototype={
gC(){var s=this.d
return s==null?this.$ti.c.a(s):s},
u(){var s=this,r=s.c,q=s.a
if(s.b!==q.r)throw A.d(A.ax(q))
else if(r==null){s.d=null
return!1}else{s.d=s.$ti.h("1?").a(r.a)
s.c=r.b
return!0}},
$iC:1}
A.e2.prototype={
gi(a){return this.a.length},
l(a,b){var s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]}}
A.o.prototype={
gI(a){return new A.au(a,this.gi(a),A.ar(a).h("au<o.E>"))},
au(a,b){return this.l(a,b)},
gY(a){return this.gi(a)===0},
gek(a){return this.gi(a)!==0},
ef(a,b){var s,r
A.ar(a).h("K(o.E)").a(b)
s=this.gi(a)
for(r=0;r<s;++r){if(!b.$1(this.l(a,r)))return!1
if(s!==this.gi(a))throw A.d(A.ax(a))}return!0},
kZ(a,b){var s,r
A.ar(a).h("K(o.E)").a(b)
s=this.gi(a)
for(r=0;r<s;++r){if(b.$1(this.l(a,r)))return!0
if(s!==this.gi(a))throw A.d(A.ax(a))}return!1},
bi(a,b){var s
if(this.gi(a)===0)return""
s=A.my("",a,b)
return s.charCodeAt(0)==0?s:s},
bC(a,b,c){var s=A.ar(a)
return new A.av(a,s.M(c).h("1(o.E)").a(b),s.h("@<o.E>").M(c).h("av<1,2>"))},
a5(a,b){return A.aK(a,b,null,A.ar(a).h("o.E"))},
cR(a,b){return A.aK(a,0,A.ba(b,"count",t.S),A.ar(a).h("o.E"))},
m(a,b){var s
A.ar(a).h("o.E").a(b)
s=this.gi(a)
this.si(a,s+1)
this.D(a,s,b)},
F(a,b,c,d){var s,r,q=A.ar(a)
q.h("o.E?").a(d)
s=d==null?q.h("o.E").a(d):d
A.bO(b,c,this.gi(a))
for(r=b;r<c;++r)this.D(a,r,s)},
H(a,b,c,d,e){var s,r,q,p,o
A.ar(a).h("h<o.E>").a(d)
A.bO(b,c,this.gi(a))
s=c-b
if(s===0)return
A.bN(e,"skipCount")
if(t.j.b(d)){r=e
q=d}else{q=J.m9(d,e).i5(0,!1)
r=0}p=J.aj(q)
if(r+s>p.gi(q))throw A.d(A.az("Too few elements"))
if(r<b)for(o=s-1;o>=0;--o)this.D(a,b+o,p.l(q,r+o))
else for(o=0;o<s;++o)this.D(a,b+o,p.l(q,r+o))},
V(a,b,c,d){return this.H(a,b,c,d,0)},
ab(a,b,c){var s,r,q
A.ar(a).h("h<o.E>").a(c)
if(t.j.b(c))this.V(a,b,b+c.length,c)
else for(s=c.length,r=0;r<c.length;c.length===s||(0,A.O)(c),++r,b=q){q=b+1
this.D(a,b,c[r])}},
n(a){return A.mj(a,"[","]")},
$in:1,
$ih:1,
$ik:1}
A.D.prototype={
cz(a,b,c){var s=A.y(this)
return A.ob(this,s.h("D.K"),s.h("D.V"),b,c)},
aO(a,b){var s,r,q,p=A.y(this)
p.h("~(D.K,D.V)").a(b)
for(s=this.gap(),s=s.gI(s),p=p.h("D.V");s.u();){r=s.gC()
q=this.l(0,r)
b.$2(r,q==null?p.a(q):q)}},
gbx(){return this.gap().bC(0,new A.iu(this),A.y(this).h("a7<D.K,D.V>"))},
a3(a){return this.gap().a9(0,a)},
gi(a){var s=this.gap()
return s.gi(s)},
gY(a){var s=this.gap()
return s.gY(s)},
gbk(){return new A.em(this,A.y(this).h("em<D.K,D.V>"))},
n(a){return A.mn(this)},
$iV:1}
A.iu.prototype={
$1(a){var s=this.a,r=A.y(s)
r.h("D.K").a(a)
s=s.l(0,a)
if(s==null)s=r.h("D.V").a(s)
return new A.a7(a,s,r.h("a7<D.K,D.V>"))},
$S(){return A.y(this.a).h("a7<D.K,D.V>(D.K)")}}
A.iv.prototype={
$2(a,b){var s,r=this.a
if(!r.a)this.b.a+=", "
r.a=!1
r=this.b
s=A.r(a)
r.a=(r.a+=s)+": "
s=A.r(b)
r.a+=s},
$S:21}
A.em.prototype={
gi(a){var s=this.a
return s.gi(s)},
gY(a){var s=this.a
return s.gY(s)},
gI(a){var s=this.a,r=s.gap()
return new A.en(r.gI(r),s,this.$ti.h("en<1,2>"))}}
A.en.prototype={
u(){var s=this,r=s.a
if(r.u()){s.c=s.b.l(0,r.gC())
return!0}s.c=null
return!1},
gC(){var s=this.c
return s==null?this.$ti.y[1].a(s):s},
$iC:1}
A.bP.prototype={
gY(a){return this.gi(this)===0},
af(a,b){var s,r
A.y(this).h("h<1>").a(b)
for(s=b.length,r=0;r<b.length;b.length===s||(0,A.O)(b),++r)this.m(0,b[r])},
n(a){return A.mj(this,"{","}")},
cI(a,b,c,d){var s,r
d.a(b)
A.y(this).M(d).h("1(1,2)").a(c)
for(s=this.gI(this),r=b;s.u();)r=c.$2(r,s.gC())
return r},
$in:1,
$ih:1}
A.ev.prototype={}
A.h1.prototype={
l(a,b){var s,r=this.b
if(r==null)return this.c.l(0,b)
else if(typeof b!="string")return null
else{s=r[b]
return typeof s=="undefined"?this.kd(b):s}},
gi(a){return this.b==null?this.c.a:this.bQ().length},
gY(a){return this.gi(0)===0},
gap(){if(this.b==null){var s=this.c
return new A.bo(s,A.y(s).h("bo<1>"))}return new A.h2(this)},
gbk(){var s,r=this
if(r.b==null){s=r.c
return new A.bp(s,A.y(s).h("bp<2>"))}return A.oc(r.bQ(),new A.ku(r),t.N,t.z)},
a3(a){if(this.b==null)return this.c.a3(a)
if(typeof a!="string")return!1
return Object.prototype.hasOwnProperty.call(this.a,a)},
aO(a,b){var s,r,q,p,o=this
t.cA.a(b)
if(o.b==null)return o.c.aO(0,b)
s=o.bQ()
for(r=0;r<s.length;++r){q=s[r]
p=o.b[q]
if(typeof p=="undefined"){p=A.kX(o.a[q])
o.b[q]=p}b.$2(q,p)
if(s!==o.c)throw A.d(A.ax(o))}},
bQ(){var s=t.bF.a(this.c)
if(s==null)s=this.c=A.i(Object.keys(this.a),t.s)
return s},
kd(a){var s
if(!Object.prototype.hasOwnProperty.call(this.a,a))return null
s=A.kX(this.a[a])
return this.b[a]=s}}
A.ku.prototype={
$1(a){return this.a.l(0,A.a9(a))},
$S:15}
A.h2.prototype={
gi(a){return this.a.gi(0)},
au(a,b){var s=this.a
if(s.b==null)s=s.gap().au(0,b)
else{s=s.bQ()
if(!(b>=0&&b<s.length))return A.a(s,b)
s=s[b]}return s},
gI(a){var s=this.a
if(s.b==null){s=s.gap()
s=s.gI(s)}else{s=s.bQ()
s=new J.at(s,s.length,A.F(s).h("at<1>"))}return s},
a9(a,b){return this.a.a3(b)}}
A.kJ.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:true})
return s}catch(r){}return null},
$S:22}
A.kI.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:false})
return s}catch(r){}return null},
$S:22}
A.eS.prototype={
lm(a){return B.a3.a4(a)}}
A.he.prototype={
a4(a){var s,r,q,p,o
A.a9(a)
s=a.length
r=A.bO(0,null,s)
q=new Uint8Array(r)
for(p=0;p<r;++p){if(!(p<s))return A.a(a,p)
o=a.charCodeAt(p)
if((o&4294967168)!==0)throw A.d(A.aZ(a,"string","Contains invalid characters."))
if(!(p<r))return A.a(q,p)
q[p]=o}return q}}
A.eT.prototype={}
A.di.prototype={
ged(){return B.aE}}
A.eW.prototype={
a4(a){var s
t.L.a(a)
s=a.length
if(s===0)return""
s=new A.k7("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/").ln(a,0,s,!0)
s.toString
return A.cb(s,0,null)}}
A.k7.prototype={
ln(a,b,c,d){var s,r,q,p,o
t.L.a(a)
s=this.a
r=(s&3)+(c-b)
q=B.a.t(r,3)
p=q*4
if(r-q*3>0)p+=4
o=new Uint8Array(p)
this.a=A.rZ(this.b,a,b,c,!0,o,0,s)
if(p>0)return o
return null}}
A.eZ.prototype={$iS:1}
A.aD.prototype={}
A.a_.prototype={
d0(a){A.y(this).h("S<a_.T>").a(a)
throw A.d(A.ao("This converter does not support chunked conversions: "+this.n(0)))}}
A.cD.prototype={}
A.dF.prototype={
n(a){var s=A.fb(this.a)
return(this.b!=null?"Converting object to an encodable object failed:":"Converting object did not return an encodable object:")+" "+s}}
A.fm.prototype={
n(a){return"Cyclic error in JSON stringify"}}
A.fl.prototype={
cB(a,b){var s=A.ur(a,this.glj().a)
return s},
aL(a,b){var s=A.t4(a,this.ged().b,null)
return s},
ged(){return B.bj},
glj(){return B.bi}}
A.fo.prototype={}
A.fn.prototype={}
A.kw.prototype={
ib(a){var s,r,q,p,o,n,m=a.length
for(s=this.c,r=0,q=0;q<m;++q){p=a.charCodeAt(q)
if(p>92){if(p>=55296){o=p&64512
if(o===55296){n=q+1
n=!(n<m&&(a.charCodeAt(n)&64512)===56320)}else n=!1
if(!n)if(o===56320){o=q-1
o=!(o>=0&&(a.charCodeAt(o)&64512)===55296)}else o=!1
else o=!0
if(o){if(q>r)s.a+=B.e.aS(a,r,q)
r=q+1
o=A.X(92)
s.a+=o
o=A.X(117)
s.a+=o
o=A.X(100)
s.a+=o
o=p>>>8&15
o=A.X(o<10?48+o:87+o)
s.a+=o
o=p>>>4&15
o=A.X(o<10?48+o:87+o)
s.a+=o
o=p&15
o=A.X(o<10?48+o:87+o)
s.a+=o}}continue}if(p<32){if(q>r)s.a+=B.e.aS(a,r,q)
r=q+1
o=A.X(92)
s.a+=o
switch(p){case 8:o=A.X(98)
s.a+=o
break
case 9:o=A.X(116)
s.a+=o
break
case 10:o=A.X(110)
s.a+=o
break
case 12:o=A.X(102)
s.a+=o
break
case 13:o=A.X(114)
s.a+=o
break
default:o=A.X(117)
s.a+=o
o=A.X(48)
s.a=(s.a+=o)+o
o=p>>>4&15
o=A.X(o<10?48+o:87+o)
s.a+=o
o=p&15
o=A.X(o<10?48+o:87+o)
s.a+=o
break}}else if(p===34||p===92){if(q>r)s.a+=B.e.aS(a,r,q)
r=q+1
o=A.X(92)
s.a+=o
o=A.X(p)
s.a+=o}}if(r===0)s.a+=a
else if(r<m)s.a+=B.e.aS(a,r,m)},
d9(a){var s,r,q,p
for(s=this.a,r=s.length,q=0;q<r;++q){p=s[q]
if(a==null?p==null:a===p)throw A.d(new A.fm(a,null))}B.b.m(s,a)},
cV(a){var s,r,q,p,o=this
if(o.ia(a))return
o.d9(a)
try{s=o.b.$1(a)
if(!o.ia(s)){q=A.o6(a,null,o.gfK())
throw A.d(q)}q=o.a
if(0>=q.length)return A.a(q,-1)
q.pop()}catch(p){r=A.G(p)
q=A.o6(a,r,o.gfK())
throw A.d(q)}},
ia(a){var s,r,q=this
if(typeof a=="number"){if(!isFinite(a))return!1
q.c.a+=B.w.n(a)
return!0}else if(a===!0){q.c.a+="true"
return!0}else if(a===!1){q.c.a+="false"
return!0}else if(a==null){q.c.a+="null"
return!0}else if(typeof a=="string"){s=q.c
s.a+='"'
q.ib(a)
s.a+='"'
return!0}else if(t.j.b(a)){q.d9(a)
q.m4(a)
s=q.a
if(0>=s.length)return A.a(s,-1)
s.pop()
return!0}else if(t.f.b(a)){q.d9(a)
r=q.m5(a)
s=q.a
if(0>=s.length)return A.a(s,-1)
s.pop()
return r}else return!1},
m4(a){var s,r,q=this.c
q.a+="["
s=J.aj(a)
if(s.gek(a)){this.cV(s.l(a,0))
for(r=1;r<s.gi(a);++r){q.a+=","
this.cV(s.l(a,r))}}q.a+="]"},
m5(a){var s,r,q,p,o,n,m=this,l={}
if(a.gY(a)){m.c.a+="{}"
return!0}s=a.gi(a)*2
r=A.b_(s,null,!1,t.X)
q=l.a=0
l.b=!0
a.aO(0,new A.kx(l,r))
if(!l.b)return!1
p=m.c
p.a+="{"
for(o='"';q<s;q+=2,o=',"'){p.a+=o
m.ib(A.a9(r[q]))
p.a+='":'
n=q+1
if(!(n<s))return A.a(r,n)
m.cV(r[n])}p.a+="}"
return!0}}
A.kx.prototype={
$2(a,b){var s,r
if(typeof a!="string")this.a.b=!1
s=this.b
r=this.a
B.b.D(s,r.a++,a)
B.b.D(s,r.a++,b)},
$S:21}
A.kv.prototype={
gfK(){var s=this.c.a
return s.charCodeAt(0)==0?s:s}}
A.fE.prototype={
hx(a){t.L.a(a)
return B.aw.a4(a)}}
A.fG.prototype={
a4(a){var s,r,q,p,o
A.a9(a)
s=a.length
r=A.bO(0,null,s)
if(r===0)return new Uint8Array(0)
q=new Uint8Array(r*3)
p=new A.kK(q)
if(p.jh(a,0,r)!==r){o=r-1
if(!(o>=0&&o<s))return A.a(a,o)
p.e0()}return B.c.aZ(q,0,p.b)}}
A.kK.prototype={
e0(){var s,r=this,q=r.c,p=r.b,o=r.b=p+1
q.$flags&2&&A.b(q)
s=q.length
if(!(p<s))return A.a(q,p)
q[p]=239
p=r.b=o+1
if(!(o<s))return A.a(q,o)
q[o]=191
r.b=p+1
if(!(p<s))return A.a(q,p)
q[p]=189},
kT(a,b){var s,r,q,p,o,n=this
if((b&64512)===56320){s=65536+((a&1023)<<10)|b&1023
r=n.c
q=n.b
p=n.b=q+1
r.$flags&2&&A.b(r)
o=r.length
if(!(q<o))return A.a(r,q)
r[q]=s>>>18|240
q=n.b=p+1
if(!(p<o))return A.a(r,p)
r[p]=s>>>12&63|128
p=n.b=q+1
if(!(q<o))return A.a(r,q)
r[q]=s>>>6&63|128
n.b=p+1
if(!(p<o))return A.a(r,p)
r[p]=s&63|128
return!0}else{n.e0()
return!1}},
jh(a,b,c){var s,r,q,p,o,n,m,l,k=this
if(b!==c){s=c-1
if(!(s>=0&&s<a.length))return A.a(a,s)
s=(a.charCodeAt(s)&64512)===55296}else s=!1
if(s)--c
for(s=k.c,r=s.$flags|0,q=s.length,p=a.length,o=b;o<c;++o){if(!(o<p))return A.a(a,o)
n=a.charCodeAt(o)
if(n<=127){m=k.b
if(m>=q)break
k.b=m+1
r&2&&A.b(s)
s[m]=n}else{m=n&64512
if(m===55296){if(k.b+4>q)break
m=o+1
if(!(m<p))return A.a(a,m)
if(k.kT(n,a.charCodeAt(m)))o=m}else if(m===56320){if(k.b+3>q)break
k.e0()}else if(n<=2047){m=k.b
l=m+1
if(l>=q)break
k.b=l
r&2&&A.b(s)
if(!(m<q))return A.a(s,m)
s[m]=n>>>6|192
k.b=l+1
s[l]=n&63|128}else{m=k.b
if(m+2>=q)break
l=k.b=m+1
r&2&&A.b(s)
if(!(m<q))return A.a(s,m)
s[m]=n>>>12|224
m=k.b=l+1
if(!(l<q))return A.a(s,l)
s[l]=n>>>6&63|128
k.b=m+1
if(!(m<q))return A.a(s,m)
s[m]=n&63|128}}}return o}}
A.fF.prototype={
a4(a){return new A.eE(this.a).dh(t.L.a(a),0,null,!0)}}
A.eE.prototype={
dh(a,b,c,d){var s,r,q,p,o,n,m,l=this
t.L.a(a)
s=A.bO(b,c,J.B(a))
if(b===s)return""
if(a instanceof Uint8Array){r=a
q=r
p=0}else{q=A.tp(a,b,s)
s-=b
p=b
b=0}if(s-b>=15){o=l.a
n=A.to(o,q,b,s)
if(n!=null){if(!o)return n
if(n.indexOf("\ufffd")<0)return n}}n=l.di(q,b,s,!0)
o=l.b
if((o&1)!==0){m=A.tq(o)
l.b=0
throw A.d(A.dx(m,a,p+l.c))}return n},
di(a,b,c,d){var s,r,q=this
if(c-b>1000){s=B.a.t(b+c,2)
r=q.di(a,b,s,!1)
if((q.b&1)!==0)return r
return r+q.di(a,s,c,d)}return q.ld(a,b,c,d)},
ld(a,b,a0,a1){var s,r,q,p,o,n,m,l,k=this,j="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFFFFFFFFFFFFFFFFGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHHHHHHHHHHHHIHHHJEEBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBKCCCCCCCCCCCCDCLONNNMEEEEEEEEEEE",i=" \x000:XECCCCCN:lDb \x000:XECCCCCNvlDb \x000:XECCCCCN:lDb AAAAA\x00\x00\x00\x00\x00AAAAA00000AAAAA:::::AAAAAGG000AAAAA00KKKAAAAAG::::AAAAA:IIIIAAAAA000\x800AAAAA\x00\x00\x00\x00 AAAAA",h=65533,g=k.b,f=k.c,e=new A.bS(""),d=b+1,c=a.length
if(!(b>=0&&b<c))return A.a(a,b)
s=a[b]
A:for(r=k.a;;){for(;;d=o){if(!(s>=0&&s<256))return A.a(j,s)
q=j.charCodeAt(s)&31
f=g<=32?s&61694>>>q:(s&63|f<<6)>>>0
p=g+q
if(!(p>=0&&p<144))return A.a(i,p)
g=i.charCodeAt(p)
if(g===0){p=A.X(f)
e.a+=p
if(d===a0)break A
break}else if((g&1)!==0){if(r)switch(g){case 69:case 67:p=A.X(h)
e.a+=p
break
case 65:p=A.X(h)
e.a+=p;--d
break
default:p=A.X(h)
e.a=(e.a+=p)+p
break}else{k.b=g
k.c=d-1
return""}g=0}if(d===a0)break A
o=d+1
if(!(d>=0&&d<c))return A.a(a,d)
s=a[d]}o=d+1
if(!(d>=0&&d<c))return A.a(a,d)
s=a[d]
if(s<128){for(;;){if(!(o<a0)){n=a0
break}m=o+1
if(!(o>=0&&o<c))return A.a(a,o)
s=a[o]
if(s>=128){n=m-1
o=m
break}o=m}if(n-d<20)for(l=d;l<n;++l){if(!(l<c))return A.a(a,l)
p=A.X(a[l])
e.a+=p}else{p=A.cb(a,d,n)
e.a+=p}if(n===a0)break A
d=o}else d=o}if(a1&&g>32)if(r){c=A.X(h)
e.a+=c}else{k.b=77
k.c=a0
return""}k.b=g
k.c=f
c=e.a
return c.charCodeAt(0)==0?c:c}}
A.f8.prototype={
$0(){var s=this
return A.j(A.bd("("+s.a+", "+s.b+", "+s.c+", "+s.d+", "+s.e+", "+s.f+", "+s.r+", "+s.w+")",null))},
$S:46}
A.aF.prototype={
aC(a,b){if(b==null)return!1
return b instanceof A.aF&&this.a===b.a&&this.b===b.b&&this.c===b.c},
ga1(a){return A.iA(this.a,this.b,B.G,B.G)},
be(a,b){var s
t.dy.a(b)
s=B.a.be(this.a,b.a)
if(s!==0)return s
return B.a.be(this.b,b.b)},
i7(){var s=this
if(s.c)return s
return new A.aF(s.a,s.b,!0)},
n(a){var s=this,r=A.nS(A.ca(s)),q=A.bk(A.iD(s)),p=A.bk(A.mq(s)),o=A.bk(A.mr(s)),n=A.bk(A.iC(s)),m=A.bk(A.ms(s)),l=A.ie(A.og(s)),k=s.b,j=k===0?"":A.ie(k)
k=r+"-"+q
if(s.c)return k+"-"+p+" "+o+":"+n+":"+m+"."+l+j+"Z"
else return k+"-"+p+" "+o+":"+n+":"+m+"."+l+j},
ev(){var s=this,r=A.ca(s)>=-9999&&A.ca(s)<=9999?A.nS(A.ca(s)):A.r3(A.ca(s)),q=A.bk(A.iD(s)),p=A.bk(A.mq(s)),o=A.bk(A.mr(s)),n=A.bk(A.iC(s)),m=A.bk(A.ms(s)),l=A.ie(A.og(s)),k=s.b,j=k===0?"":A.ie(k)
k=r+"-"+q
if(s.c)return k+"-"+p+"T"+o+":"+n+":"+m+"."+l+j+"Z"
else return k+"-"+p+"T"+o+":"+n+":"+m+"."+l+j},
$iaE:1}
A.ig.prototype={
$1(a){if(a==null)return 0
return A.hm(a)},
$S:24}
A.ih.prototype={
$1(a){var s,r,q
if(a==null)return 0
for(s=a.length,r=0,q=0;q<6;++q){r*=10
if(q<s){if(!(q<s))return A.a(a,q)
r+=a.charCodeAt(q)^48}}return r},
$S:24}
A.bG.prototype={
aC(a,b){if(b==null)return!1
return b instanceof A.bG&&this.a===b.a},
ga1(a){return B.a.ga1(this.a)},
be(a,b){return B.a.be(this.a,t.fu.a(b).a)},
n(a){var s,r,q,p=this.a,o=p%36e8,n=B.a.t(o,6e7)
o%=6e7
s=n<10?"0":""
r=B.a.t(o,1e6)
q=r<10?"0":""
return""+(p/36e8|0)+":"+s+n+":"+q+r+"."+B.e.cN(B.a.n(o%1e6),6,"0")},
$iaE:1}
A.kf.prototype={
n(a){return this.bp()}}
A.L.prototype={
gbE(){return A.rq(this)}}
A.eU.prototype={
n(a){var s=this.a
if(s!=null)return"Assertion failed: "+A.fb(s)
return"Assertion failed"}}
A.bs.prototype={}
A.aQ.prototype={
gdq(){return"Invalid argument"+(!this.a?"(s)":"")},
gdn(){return""},
n(a){var s=this,r=s.c,q=r==null?"":" ("+r+")",p=s.d,o=p==null?"":": "+A.r(p),n=s.gdq()+q+o
if(!s.a)return n
return n+s.gdn()+": "+A.fb(s.gei())},
gei(){return this.b}}
A.bq.prototype={
gei(){return A.oW(this.b)},
gdq(){return"RangeError"},
gdn(){var s,r=this.e,q=this.f
if(r==null)s=q!=null?": Not less than or equal to "+A.r(q):""
else if(q==null)s=": Not greater than or equal to "+A.r(r)
else if(q>r)s=": Not in inclusive range "+A.r(r)+".."+A.r(q)
else s=q<r?": Valid value range is empty":": Only valid value is "+A.r(r)
return s}}
A.fe.prototype={
gei(){return A.H(this.b)},
gdq(){return"RangeError"},
gdn(){if(A.H(this.b)<0)return": index must not be negative"
var s=this.f
if(s===0)return": no indices are valid"
return": index should be less than "+s},
$ibq:1,
gi(a){return this.f}}
A.e3.prototype={
n(a){return"Unsupported operation: "+this.a}}
A.fC.prototype={
n(a){var s=this.a
return s!=null?"UnimplementedError: "+s:"UnimplementedError"}}
A.bR.prototype={
n(a){return"Bad state: "+this.a}}
A.f3.prototype={
n(a){var s=this.a
if(s==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+A.fb(s)+"."}}
A.fu.prototype={
n(a){return"Out of Memory"},
gbE(){return null},
$iL:1}
A.dY.prototype={
n(a){return"Stack Overflow"},
gbE(){return null},
$iL:1}
A.kg.prototype={
n(a){return"Exception: "+this.a}}
A.ay.prototype={
n(a){var s,r,q,p,o,n,m,l,k,j,i,h=this.a,g=""!==h?"FormatException: "+h:"FormatException",f=this.c,e=this.b
if(typeof e=="string"){if(f!=null)s=f<0||f>e.length
else s=!1
if(s)f=null
if(f==null){if(e.length>78)e=B.e.aS(e,0,75)+"..."
return g+"\n"+e}for(r=e.length,q=1,p=0,o=!1,n=0;n<f;++n){if(!(n<r))return A.a(e,n)
m=e.charCodeAt(n)
if(m===10){if(p!==n||!o)++q
p=n+1
o=!1}else if(m===13){++q
p=n+1
o=!0}}g=q>1?g+(" (at line "+q+", character "+(f-p+1)+")\n"):g+(" (at character "+(f+1)+")\n")
for(n=f;n<r;++n){if(!(n>=0))return A.a(e,n)
m=e.charCodeAt(n)
if(m===10||m===13){r=n
break}}l=""
if(r-p>78){k="..."
if(f-p<75){j=p+75
i=p}else{if(r-f<75){i=r-75
j=r
k=""}else{i=f-36
j=f+36}l="..."}}else{j=r
i=p
k=""}return g+l+B.e.aS(e,i,j)+k+"\n"+B.e.b7(" ",f-i+l.length)+"^\n"}else return f!=null?g+(" (at offset "+A.r(f)+")"):g}}
A.h.prototype={
bC(a,b,c){var s=A.y(this)
return A.oc(this,s.M(c).h("1(h.E)").a(b),s.h("h.E"),c)},
a9(a,b){var s
for(s=this.gI(this);s.u();)if(J.T(s.gC(),b))return!0
return!1},
gi(a){var s,r=this.gI(this)
for(s=0;r.u();)++s
return s},
gY(a){return!this.gI(this).u()},
au(a,b){var s,r
A.bN(b,"index")
s=this.gI(this)
for(r=b;s.u();){if(r===0)return s.gC();--r}throw A.d(A.mi(b,b-r,this,"index"))},
n(a){return A.rd(this,"(",")")}}
A.a7.prototype={
n(a){return"MapEntry("+A.r(this.a)+": "+A.r(this.b)+")"}}
A.W.prototype={
ga1(a){return A.m.prototype.ga1.call(this,0)},
n(a){return"null"}}
A.m.prototype={$im:1,
aC(a,b){return this===b},
ga1(a){return A.dV(this)},
n(a){return"Instance of '"+A.fw(this)+"'"},
gae(a){return A.lz(this)},
toString(){return this.n(this)}}
A.hc.prototype={
n(a){return this.a},
$ib2:1}
A.cN.prototype={
gI(a){return new A.fx(this.a)}}
A.fx.prototype={
gC(){return this.d},
u(){var s,r,q,p=this,o=p.b=p.c,n=p.a,m=n.length
if(o===m){p.d=-1
return!1}if(!(o<m))return A.a(n,o)
s=n.charCodeAt(o)
r=o+1
if((s&64512)===55296&&r<m){if(!(r<m))return A.a(n,r)
q=n.charCodeAt(r)
if((q&64512)===56320){p.c=r+1
p.d=65536+((s&1023)<<10)+(q&1023)
return!0}}p.c=r
p.d=s
return!0},
$iC:1}
A.bS.prototype={
gi(a){return this.a.length},
n(a){var s=this.a
return s.charCodeAt(0)==0?s:s},
$irz:1}
A.iy.prototype={
n(a){return"Promise was rejected with a value of `"+(this.a?"undefined":"null")+"`."}}
A.lW.prototype={
$1(a){return this.a.cA(this.b.h("0/?").a(a))},
$S:10}
A.lX.prototype={
$1(a){if(a==null)return this.a.c_(new A.iy(a===undefined))
return this.a.c_(a)},
$S:10}
A.h0.prototype={
is(){var s=self.crypto
if(s!=null)if(s.getRandomValues!=null)return
throw A.d(A.ao("No source of cryptographically secure random numbers available."))},
hV(a){var s,r,q,p,o,n,m,l,k=null
if(a<=0||a>4294967296)throw A.d(new A.bq(k,k,!1,k,k,"max must be in range 0 < max \u2264 2^32, was "+a))
if(a>255)if(a>65535)s=a>16777215?4:3
else s=2
else s=1
r=this.a
r.$flags&2&&A.b(r,11)
r.setUint32(0,0,!1)
q=4-s
p=A.H(Math.pow(256,s))
for(o=a-1,n=(a&o)>>>0===0;;){crypto.getRandomValues(J.ak(B.K.gN(r),q,s))
m=r.getUint32(0,!1)
if(n)return(m&o)>>>0
l=m%a
if(m-l+a<p)return l}},
$irt:1}
A.fa.prototype={}
A.dd.prototype={
m(a,b){var s,r=this.b,q=b.a,p=r.l(0,q)
if(p!=null){B.b.D(this.a,p,b)
return}s=this.a
B.b.m(s,b)
r.D(0,q,s.length-1)},
gi(a){return this.a.length},
gY(a){return this.a.length===0},
gI(a){var s=this.a
return new J.at(s,s.length,A.F(s).h("at<1>"))}}
A.bc.prototype={
ghO(){var s=this.f
return s===$?this.f=B.a.t(Date.now(),1000):s},
hC(){var s,r
if(this.ax!=null)return
s=this.at
if(s!=null){r=s.c7().B()
this.ax=new A.bH(r)}}}
A.be.prototype={
bp(){return"CompressionType."+this.b}}
A.hZ.prototype={}
A.eX.prototype={
gi(a){return this.e},
aq(a,b,c){var s,r,q,p,o,n,m=this
if(c<=b)return
s=m.d
r=s.length
q=r+c-b
p=new Uint8Array(q)
B.c.V(p,0,r,s)
B.c.H(p,r,q,a,b)
m.e=m.e+(c-b)
s=m.c
o=A.kY(p,s.a,s.c,s.b)
n=o.a
s.c=o.b
s.b=o.c
s.a+=n
m.b.aq(p,0,n)
m.d=new Uint8Array(A.N(A.Q(p,n,null)))},
ah(a,b){t.L.a(a)
return this.aq(a,0,a.length)},
v(a){return this.ah(a,null)},
j(a){var s=new Uint8Array(1)
s[0]=a
return this.aq(s,0,1)},
ai(a,b){return A.j(A.ao("filtered output cannot be read back"))},
aQ(a){return this.ai(a,null)}}
A.i1.prototype={
dH(){var s=this.a,r=s.gP()
if(r){this.e=!0
return 0}return s.G()},
a_(a){var s,r,q,p,o=this
if(a===0)return 0
if(o.d===0){o.d=8
o.c=o.dH()}for(s=0;r=o.d,a>r;){q=B.a.p(s,r)
p=o.c
if(!(r>=0&&r<9))return A.a(B.Q,r)
s=q+(p&B.Q[r])
a-=r
o.d=8
o.c=o.dH()}if(a>0){if(r===0){o.d=8
o.c=o.dH()}r=B.a.p(s,a)
q=o.c
p=o.d-a
q=B.a.b3(q,p)
if(!(a<9))return A.a(B.Q,a)
s=r+(q&B.Q[a])
o.d=p}return s}}
A.i2.prototype={
v(a){var s,r
t.L.a(a)
for(s=a.length,r=0;r<s;++r)this.a7(8,a[r])},
a7(a,b){var s,r=this,q=r.c,p=q===8
if(p&&a===8){r.a.j(b&255)
return}if(p&&a===16){q=r.a
q.j(B.a.k(b,8)&255)
q.j(b&255)
return}if(p&&a===24){q=r.a
q.j(B.a.k(b,16)&255)
q.j(B.a.k(b,8)&255)
q.j(b&255)
return}if(p&&a===32){q=r.a
q.j(B.a.k(b,24)&255)
q.j(B.a.k(b,16)&255)
q.j(B.a.k(b,8)&255)
q.j(b&255)
return}for(p=r.a;a>0;){--a
s=B.a.aJ(b,a)
s=(r.b<<1|s&1)>>>0
r.b=s
q=r.c=q-1
if(q===0){p.j(s)
r.c=8
r.b=0
q=8}}}}
A.dh.prototype={
geS(){var s=this.z
if(s===$)s=this.z=new A.bQ(this.a,new Uint8Array(65536),B.d)
return s},
bH(){var s,r,q,p,o,n,m,l=this
l.eQ()
for(s=l.Q;r=l.e,q=l.d,r-=q,r>0;){p=A.Q(l.b,q,q+r)
r=p.length
o=0
n=!1
for(;;){if(!(o<r&&!n))break
if(!(o<r))return A.a(p,o)
s.eK(p[o])
q=s.w
q===$&&A.c()
m=s.d
m===$&&A.c()
n=q>=m;++o}l.d+=o
l.w+=o
if(n)if(!s.cE())A.j(A.p("bzip2: a block could not be coded"))}},
bf(){this.eQ()
var s=this.Q
if(!s.cE())A.j(A.p("bzip2: a block could not be coded"))
s.hI()
this.geS().aT()},
eQ(){var s=this
if(s.as)return
s.as=!0
s.Q.hq(s.geS(),9)}}
A.hx.prototype={
hz(a,b,c){return A.eO(b,c,new A.hz(this,!1,!1,a))},
lf(a,b){return this.hz(a,b,null)},
j0(a,b,c){for(;;){if(!this.iI(a,b,!1))return!1
if(a.gP())return!0
if(A.qM(a.a6(4,a.gA()).B()))return!0}},
iI(a,b,c){var s,r,q,p,o=this,n=new A.i1(a)
o.cx=o.CW=o.ch=o.ay=0
if(n.a_(8)!==66||n.a_(8)!==90||n.a_(8)!==104)return!1
s=o.a=n.a_(8)-48
if(s<1||s>9)return!1
for(r=0;!a.gP();){q=o.kf(n)
if(q<0)return!1
if(q===0){n.a_(8)
n.a_(8)
n.a_(8)
n.a_(8)
p=o.kh(n,b)
if(p<0||n.e)return!1
r=(r<<1|r>>>31)^p^4294967295}else if(q===2){if(n.d+a.gi(a)*8<32)return!1
n.a_(8)
n.a_(8)
n.a_(8)
n.a_(8)
if(n.e)return!1
b.T()
return!0}}return!1},
kf(a){var s,r,q,p
for(s=!0,r=!0,q=0;q<6;++q){p=a.a_(8)
if(p!==B.at[q])r=!1
if(p!==B.aj[q])s=!1
if(!s&&!r)return-1}return r?0:2},
kh(d6,d7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2=this,d3=4294967295,d4=d6.a_(1),d5=((d6.a_(8)<<8|d6.a_(8))<<8|d6.a_(8))>>>0
d2.c=new Uint8Array(16)
for(s=0;s<16;++s){r=d2.c
q=d6.a_(1)
r.$flags&2&&A.b(r)
r[s]=q}d2.d=new Uint8Array(256)
for(s=0,p=0;s<16;++s,p+=16)if(d2.c[s]!==0)for(o=0;o<16;++o){r=d2.d
q=p+o
n=d6.a_(1)
r.$flags&2&&A.b(r)
if(!(q<256))return A.a(r,q)
r[q]=n}d2.jM()
r=d2.fx
if(r===0)return-1
m=r+2
l=d6.a_(3)
if(l<2||l>6)return-1
r=d6.a_(15)
d2.ax=r
if(r<1)return-1
d2.w=new Uint8Array(18002)
d2.x=new Uint8Array(18002)
for(s=0;r=d2.ax,s<r;++s){for(o=0;;){if(d6.a_(1)===0)break;++o
if(o>=l)return-1}if(s<18002){r=d2.w
r.$flags&2&&A.b(r)
r[s]=o}}if(r>18002)d2.ax=18002
k=new Uint8Array(6)
for(s=0;s<l;++s){if(!(s<6))return A.a(k,s)
k[s]=s}for(r=d2.ax,q=d2.x,n=d2.w,j=q.$flags|0,s=0;s<r;++s){if(!(s<18002))return A.a(n,s)
i=n[s]
if(!(i<6))return A.a(k,i)
h=k[i]
for(;i>0;i=g){g=i-1
k[i]=k[g]}k[0]=h
j&2&&A.b(q)
q[s]=h}d2.fr=t.B.a(A.b_(6,$.nn(),!1,t.p))
for(f=0;f<l;++f){r=d2.fr
B.b.D(r,f,new Uint8Array(258))
e=d6.a_(5)
for(s=0;s<m;++s){for(;;){if(e<1||e>20)return-1
if(d6.a_(1)===0)break
e=d6.a_(1)===0?e+1:e-1}r=d2.fr
if(!(f<6))return A.a(r,f)
r=r[f]
r.$flags&2&&A.b(r)
if(!(s<r.length))return A.a(r,s)
r[s]=e}}r=$.nm()
q=t.w
n=t.A
d2.y=n.a(A.b_(6,r,!1,q))
d2.z=n.a(A.b_(6,r,!1,q))
d2.Q=n.a(A.b_(6,r,!1,q))
d2.as=new Int32Array(6)
for(f=0;f<l;++f){r=d2.y
B.b.D(r,f,new Int32Array(258))
r=d2.z
B.b.D(r,f,new Int32Array(258))
r=d2.Q
B.b.D(r,f,new Int32Array(258))
for(r=d2.fr,d=32,c=0,s=0;s<m;++s){if(!(f<6))return A.a(r,f)
q=r[f]
if(!(s<q.length))return A.a(q,s)
b=q[s]
if(b>c)c=b
if(b<d)d=b}q=d2.y
if(!(f<6))return A.a(q,f)
d2.ju(q[f],d2.z[f],d2.Q[f],r[f],d,c,m)
r=d2.as
r.$flags&2&&A.b(r)
r[f]=d}a=d2.fx+1
r=d2.a
r===$&&A.c()
a0=1e5*r
d2.at=new Int32Array(256)
r=d2.f=new Uint8Array(4096)
q=new Int32Array(16)
d2.r=q
for(a1=4095,a2=15;a2>=0;--a2){for(n=a2*16,a3=15;a3>=0;--a3){if(!(a1>=0&&a1<4096))return A.a(r,a1)
r[a1]=n+a3;--a1}q[a2]=a1+1}d2.ay=0
d2.ch=-1
a4=d2.dA(d6)
if(a4<0)return-1
for(a5=0;;){if(a4===a)break
if(a4===0||a4===1){a6=-1
a7=1
do{if(a7>=2097152)return-1
if(a4===0)a6+=a7
else if(a4===1)a6+=2*a7
a7*=2
a4=d2.dA(d6)}while(a4===0||a4===1);++a6
r=d2.e
r===$&&A.c()
q=d2.f
n=d2.r[0]
if(!(n>=0&&n<4096))return A.a(q,n)
n=q[n]
if(!(n>=0&&n<256))return A.a(r,n)
a8=r[n]
n=d2.at
if(!(a8<256))return A.a(n,a8)
r=n[a8]
n.$flags&2&&A.b(n)
n[a8]=r+a6
r=a5+a6
a9=d2.b
if(a9===$)a9=d2.b=new Uint32Array(16384)
if(r>a9.length)d2.fs(r,a0)
while(a6>0){if(a5>=a0)return-1
a9=d2.b
if(a9===$)a9=d2.b=new Uint32Array(16384)
a9.$flags&2&&A.b(a9)
if(!(a5>=0&&a5<a9.length))return A.a(a9,a5)
a9[a5]=a8;++a5;--a6}continue}else{if(a5>=a0)return-1
b0=a4-1
r=d2.r
q=d2.f
if(b0<16){b1=r[0]
r=b1+b0
if(!(r>=0&&r<4096))return A.a(q,r)
a8=q[r]
for(r=q.$flags|0;b0>3;){b2=b1+b0
n=b2-1
if(!(n>=0&&n<4096))return A.a(q,n)
j=q[n]
r&2&&A.b(q)
if(!(b2>=0&&b2<4096))return A.a(q,b2)
q[b2]=j
j=b2-2
if(!(j>=0))return A.a(q,j)
q[n]=q[j]
n=b2-3
if(!(n>=0))return A.a(q,n)
q[j]=q[n]
j=b2-4
if(!(j>=0))return A.a(q,j)
q[n]=q[j]
b0-=4}while(b0>0){n=b1+b0
j=n-1
if(!(j>=0&&j<4096))return A.a(q,j)
j=q[j]
r&2&&A.b(q)
if(!(n>=0&&n<4096))return A.a(q,n)
q[n]=j;--b0}r&2&&A.b(q)
if(!(b1>=0&&b1<4096))return A.a(q,b1)
q[b1]=a8}else{b3=B.a.t(b0,16)
b4=B.a.E(b0,16)
if(!(b3>=0&&b3<16))return A.a(r,b3)
b1=r[b3]+b4
if(!(b1>=0&&b1<4096))return A.a(q,b1)
a8=q[b1]
for(n=q.$flags|0;j=r[b3],b1>j;b1=b5){b5=b1-1
if(!(b5>=0))return A.a(q,b5)
j=q[b5]
n&2&&A.b(q)
if(!(b1>=0))return A.a(q,b1)
q[b1]=j}r.$flags&2&&A.b(r)
r[b3]=j+1
while(b3>0){r[b3]=r[b3]-1
j=r[b3];--b3
b6=r[b3]+16-1
if(!(b6>=0&&b6<4096))return A.a(q,b6)
b6=q[b6]
n&2&&A.b(q)
if(!(j>=0&&j<4096))return A.a(q,j)
q[j]=b6}r[0]=r[0]-1
j=r[0]
n&2&&A.b(q)
if(!(j>=0&&j<4096))return A.a(q,j)
q[j]=a8
if(r[0]===0)for(a1=4095,a2=15;a2>=0;--a2){for(a3=15;a3>=0;--a3){n=r[a2]+a3
if(!(n>=0&&n<4096))return A.a(q,n)
n=q[n]
if(!(a1>=0&&a1<4096))return A.a(q,a1)
q[a1]=n;--a1}r[a2]=a1+1}}r=d2.at
q=d2.e
q===$&&A.c()
if(!(a8>=0&&a8<256))return A.a(q,a8)
q=q[a8]
if(!(q<256))return A.a(r,q)
n=r[q]
r.$flags&2&&A.b(r)
r[q]=n+1
a9=d2.b
if(a9===$)a9=d2.b=new Uint32Array(16384)
if(a5===a9.length)d2.fs(a5+1,a0)
a9=d2.b
if(a9===$)a9=d2.b=new Uint32Array(16384)
r=d2.e[a8]
a9.$flags&2&&A.b(a9)
if(!(a5>=0&&a5<a9.length))return A.a(a9,a5)
a9[a5]=r;++a5
a4=d2.dA(d6)
continue}}if(d5>=a5)return-1
for(r=d2.at,s=0;s<=255;++s){q=r[s]
if(q<0||q>a5)return-1}r=d2.dy=new Int32Array(257)
r[0]=0
for(q=d2.at,s=1;s<=256;++s)r[s]=q[s-1]
for(s=1;s<=256;++s)r[s]=r[s]+r[s-1]
for(s=0;s<=256;++s){q=r[s]
if(q<0||q>a5)return-1}for(s=1;s<=256;++s)if(r[s-1]>r[s])return-1
for(s=0;s<a5;++s){a9=d2.b
if(a9===$){a9=d2.b=new Uint32Array(16384)
b7=a9}else b7=a9
if(!(s<a9.length))return A.a(a9,s)
a8=a9[s]&255
r=d2.dy
q=r[a8]
if(!(q>=0&&q<b7.length))return A.a(b7,q)
n=b7[q]
b7.$flags&2&&A.b(b7)
b7[q]=(n|s<<8)>>>0
n=r[a8]
r.$flags&2&&A.b(r)
r[a8]=n+1}r=d2.gbd()
if(!(d5<r.length))return A.a(r,d5)
b8=r[d5]>>>8
r=d4!==0
if(r){if(b8>=1e5*d2.a)return-1
q=d2.gbd()
if(!(b8<q.length))return A.a(q,b8)
b8=q[b8]
b9=b8>>>8
c0=b8&255^0
b8=b9
c1=618
c2=1}else{if(b8>=1e5*d2.a)return d3
q=d2.gbd()
if(!(b8<q.length))return A.a(q,b8)
b8=q[b8]
c0=b8&255
b8=b8>>>8
c1=0
c2=0}c3=a5+1
c4=d3
if(r)for(c5=0,c6=0,c7=1;;c6=c0,c0=c9){for(r=c6&255;;){if(c5===0)break
d7.j(c6)
q=c4>>>24&255^r
if(!(q<256))return A.a(B.o,q)
c4=(c4<<8^B.o[q])>>>0;--c5}if(c7===c3)return c4
if(c7>c3)return-1
a9=d2.b
if(a9===$){a9=d2.b=new Uint32Array(16384)
b7=a9}else b7=a9
if(!(b8>=0&&b8<a9.length))return A.a(a9,b8)
b8=a9[b8]
b9=b8>>>8
if(c1===0){if(!(c2<512))return A.a(B.x,c2)
c1=B.x[c2];++c2
if(c2===512)c2=0}--c1
r=c1===1?1:0
c8=b8&255^r;++c7
c5=1
if(c7===c3){c9=c0
b8=b9
continue}if(c8!==c0){c9=c8
b8=b9
continue}r=b7.length
if(!(b9<r))return A.a(b7,b9)
b8=b7[b9]
b9=b8>>>8
if(c1===0){if(!(c2<512))return A.a(B.x,c2)
c1=B.x[c2];++c2
if(c2===512)c2=0}--c1
q=c1===1?1:0
c8=b8&255^q;++c7
if(c7===c3){c9=c0
b8=b9
c5=2
continue}if(c8!==c0){c9=c8
b8=b9
c5=2
continue}if(!(b9<r))return A.a(b7,b9)
b8=b7[b9]
b9=b8>>>8
if(c1===0){if(!(c2<512))return A.a(B.x,c2)
c1=B.x[c2];++c2
if(c2===512)c2=0}--c1
q=c1===1?1:0
c8=b8&255^q;++c7
if(c7===c3){c9=c0
b8=b9
c5=3
continue}if(c8!==c0){c9=c8
b8=b9
c5=3
continue}if(!(b9<r))return A.a(b7,b9)
b8=b7[b9]
b9=b8>>>8
if(c1===0){if(!(c2<512))return A.a(B.x,c2)
c1=B.x[c2];++c2
if(c2===512)c2=0}--c1
q=c1===1?1:0
c5=(b8&255^q)+4
if(!(b9<r))return A.a(b7,b9)
b8=b7[b9]
b9=b8>>>8
if(c1===0){if(!(c2<512))return A.a(B.x,c2)
c1=B.x[c2];++c2
if(c2===512)c2=0}--c1
r=c1===1?1:0
c9=b8&255^r
c7=c7+1+1
b8=b9}else for(d0=c0,c5=0,c6=0,c7=1;;c6=d0,d0=d1){if(c5>0){for(r=c6&255;;){if(c5===1)break
d7.j(c6)
q=c4>>>24&255^r
if(!(q<256))return A.a(B.o,q)
c4=c4<<8^B.o[q];--c5}d7.j(c6)
r=c4>>>24&255^r
if(!(r<256))return A.a(B.o,r)
c4=(c4<<8^B.o[r])>>>0}if(c7>c3)return-1
if(c7===c3)return c4
r=1e5*d2.a
if(b8>=r)return-1
a9=d2.b
if(a9===$){a9=d2.b=new Uint32Array(16384)
b7=a9}else b7=a9
if(!(b8>=0&&b8<a9.length))return A.a(a9,b8)
b8=a9[b8]
c8=b8&255
b8=b8>>>8;++c7
c5=0
if(c8!==d0){d7.j(d0)
r=c4>>>24&255^d0&255
if(!(r<256))return A.a(B.o,r)
c4=(c4<<8^B.o[r])>>>0
d1=c8
continue}if(c7===c3){d7.j(d0)
r=c4>>>24&255^d0&255
if(!(r<256))return A.a(B.o,r)
c4=(c4<<8^B.o[r])>>>0
d1=d0
continue}if(b8>=r)return-1
q=b7.length
if(!(b8<q))return A.a(b7,b8)
b8=b7[b8]
c8=b8&255
b8=b8>>>8;++c7
if(c7===c3){d1=d0
c5=2
continue}if(c8!==d0){d1=c8
c5=2
continue}if(b8>=r)return-1
if(!(b8<q))return A.a(b7,b8)
b8=b7[b8]
c8=b8&255
b8=b8>>>8;++c7
if(c7===c3){d1=d0
c5=3
continue}if(c8!==d0){d1=c8
c5=3
continue}if(b8>=r)return-1
if(!(b8<q))return A.a(b7,b8)
b8=b7[b8]
b9=b8>>>8
c5=(b8&255)+4
if(b9>=r)return-1
if(!(b9<q))return A.a(b7,b9)
b8=b7[b9]
d1=b8&255
b8=b8>>>8
c7=c7+1+1}return c4},
dA(a){var s,r,q,p,o=this,n=o.ay
if(n===0){n=++o.ch
s=o.ax
s===$&&A.c()
if(n>=s)return-1
s=o.ay=50
r=o.x
r===$&&A.c()
if(!(n>=0&&n<18002))return A.a(r,n)
n=r[n]
o.CW=n
r=o.as
r===$&&A.c()
if(!(n<6))return A.a(r,n)
o.cx=r[n]
r=o.y
r===$&&A.c()
o.cy=r[n]
r=o.Q
r===$&&A.c()
o.db=r[n]
r=o.z
r===$&&A.c()
o.dx=r[n]
n=s}o.ay=n-1
q=o.cx
p=a.a_(q)
for(;;){if(q>20)return-1
n=o.cy
n===$&&A.c()
if(!(q>=0&&q<n.length))return A.a(n,q)
if(p<=n[q])break;++q
p=(p<<1|a.a_(1))>>>0}n=o.dx
n===$&&A.c()
if(!(q>=0&&q<n.length))return A.a(n,q)
n=p-n[q]
if(n<0||n>=258)return-1
s=o.db
s===$&&A.c()
if(!(n>=0&&n<s.length))return A.a(s,n)
return s[n]},
ju(a,b,c,d,e,f,g){var s,r,q,p,o,n,m,l,k,j
for(s=d.length,r=c.$flags|0,q=e,p=0;q<=f;++q)for(o=0;o<g;++o){if(!(o<s))return A.a(d,o)
if(d[o]===q){r&2&&A.b(c)
if(!(p>=0&&p<c.length))return A.a(c,p)
c[p]=o;++p}}for(r=b.$flags|0,q=0;q<23;++q){r&2&&A.b(b)
if(!(q<b.length))return A.a(b,q)
b[q]=0}for(n=b.length,q=0;q<g;++q){if(!(q<s))return A.a(d,q)
m=d[q]+1
if(!(m>=0&&m<n))return A.a(b,m)
l=b[m]
r&2&&A.b(b)
b[m]=l+1}for(q=1;q<23;++q){if(!(q<n))return A.a(b,q)
s=b[q]
m=q-1
if(!(m<n))return A.a(b,m)
m=b[m]
r&2&&A.b(b)
b[q]=s+m}for(s=a.$flags|0,q=0;q<23;++q){s&2&&A.b(a)
if(!(q<a.length))return A.a(a,q)
a[q]=0}for(q=e,k=0;q<=f;q=j){j=q+1
if(!(j>=0&&j<n))return A.a(b,j)
m=b[j]
if(!(q>=0&&q<n))return A.a(b,q)
k+=m-b[q]
s&2&&A.b(a)
if(!(q<a.length))return A.a(a,q)
a[q]=k-1
k=k<<1>>>0}for(q=e+1,s=a.length;q<=f;++q){m=q-1
if(!(m>=0&&m<s))return A.a(a,m)
m=a[m]
if(!(q>=0&&q<n))return A.a(b,q)
l=b[q]
r&2&&A.b(b)
b[q]=(m+1<<1>>>0)-l}},
jM(){var s,r,q,p=this
p.fx=0
p.e=new Uint8Array(256)
for(s=0;s<256;++s){r=p.d
r===$&&A.c()
if(r[s]!==0){r=p.e
q=p.fx++
r.$flags&2&&A.b(r)
if(!(q<256))return A.a(r,q)
r[q]=s}}},
fs(a,b){var s,r=this,q=r.gbd().length*2
if(q<a)q=a
if(q>b)q=b
if(q>r.gbd().length){s=new Uint32Array(q)
B.f.V(s,0,r.gbd().length,r.gbd())
r.b=s}},
gbd(){var s=this.b
if(s===$)s=this.b=new Uint32Array(16384)
return s}}
A.hz.prototype={
$1(a){var s=this,r=s.b
return A.d8("bzip2",r,s.c,new A.hy(s.a,s.d,a,r))},
$S:5}
A.hy.prototype={
$0(){var s=this
return s.a.j0(s.b,s.c,s.d)},
$S:3}
A.hA.prototype={
c0(a,b){var s,r,q,p,o,n,m,l,k,j=this
j.b=a instanceof A.a6?a.gi(0):-1
j.hq(b,9)
for(s=null;!a.gP();){r=a.gi(a)
q=r>0&&r<65536?r:65536
p=a.c5(q)
if(p==null){if(s==null)s=new Uint8Array(65536)
o=a.az(s,0,q)
if(o<=0)break
p=A.Q(s,0,o)}for(n=p.length,m=0;m<n;++m){j.eK(p[m])
l=j.w
l===$&&A.c()
k=j.d
k===$&&A.c()
if(l>=k&&!j.cE())return!1}}j.hI()
return!0},
hq(a,b){var s,r,q,p,o,n,m=this
if(b<1||b>9)throw A.d(A.aZ(b,"blockSize100k","Must be 1 to 9"))
s=new A.i2(a)
m.c=s
s.v(B.ae)
m.c.a7(8,48+b)
r=1e5*b
m.d=r-19
m.z=30
m.e=0
q=m.b
m.b=-1
if(q>=0&&q+B.a.k(q,2)+64<r)r=q+B.a.k(q,2)+64
m.at=new Uint32Array(r)
s=new Uint32Array(r+34)
m.ax=s
m.ay=new Uint32Array(65537)
m.ch=J.ak(B.f.gN(s),0,null)
m.cx=J.nE(B.f.gN(m.at),0,null)
m.dy=new Uint8Array(256)
m.as=m.y=0
m.id=new Uint8Array(18002)
m.k1=new Uint8Array(18002)
m.fr=t.B.a(A.b_(6,$.nn(),!1,t.p))
s=$.nm()
p=t.w
o=t.A
m.fx=o.a(A.b_(6,s,!1,p))
m.fy=o.a(A.b_(6,s,!1,p))
for(n=0;n<6;++n){s=m.fr
B.b.D(s,n,new Uint8Array(258))
s=m.fx
B.b.D(s,n,new Int32Array(258))
s=m.fy
B.b.D(s,n,new Int32Array(258))}m.go=t.fb.a(A.b_(258,$.pS(),!1,t.ai))
for(n=0;n<258;++n){s=m.go
B.b.D(s,n,new Uint32Array(4))}m.h0()},
cE(){var s=this,r=s.w
r===$&&A.c()
if(r===0){r=s.f
r===$&&A.c()
r=r===256}else r=!1
if(r)return!0
r=s.f
r===$&&A.c()
if(r<256)s.eM()
s.f=256
s.r=0
r=s.x
r===$&&A.c()
s.x=(r^4294967295)>>>0
if(!s.iJ())return!1
r=s.e
r=(r<<1|r>>>31)>>>0
s.e=r
s.e=(r^s.x)>>>0
r=s.y
r===$&&A.c()
s.y=r+1
s.h0()
return!0},
hI(){var s,r,q=this
if(!q.cE())throw A.d(A.p("bzip2: a block could not be coded"))
s=q.c
s===$&&A.c()
s.v(B.aj)
q.c.a7(32,q.e)
s=q.c
r=s.c
if(r!==8)s.a7(r,0)},
h0(){var s=this
s.CW=new Uint8Array(256)
s.w=0
s.x=4294967295
s.f=256
s.r=0},
iJ(){var s,r=this,q=r.w
q===$&&A.c()
if(q>0)if(!r.iD())return!1
if(r.w>0){q=r.c
q===$&&A.c()
q.v(B.at)
q=r.c
s=r.x
s===$&&A.c()
q.a7(32,s)
r.c.a7(1,0)
s=r.c
q=r.as
q===$&&A.c()
s.a7(24,q)
if(!r.jp())return!1
if(!r.kv())return!1}return!0},
jp(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=new Uint8Array(256)
a1.cy=0
for(s=0;s<256;++s){r=a1.CW
r===$&&A.c()
if(r[s]!==0){r=a1.dy
r===$&&A.c()
q=a1.cy
r.$flags&2&&A.b(r)
r[s]=q
a1.cy=q+1}}r=a1.cy
p=r+1
a1.dx=new Int32Array(258)
for(s=0;s<r;++s){if(!(s<256))return A.a(a2,s)
a2[s]=s}q=a1.w
q===$&&A.c()
o=a1.cx
n=a1.dx
m=a1.dy
l=a1.ch
k=a1.at
j=n.$flags|0
i=0
h=0
s=0
for(;s<q;++s){if(i>s)return!1
k===$&&A.c()
if(!(s<k.length))return A.a(k,s)
g=k[s]-1
if(g<0)g+=q
m===$&&A.c()
l===$&&A.c()
if(!(g<l.length))return A.a(l,g)
f=l[g]
if(!(f<256))return A.a(m,f)
e=m[f]
if(e>=r)return!1
if(a2[0]===e)++h
else{if(h>0){--h
for(;;i=d){d=i+1
if((h&1)!==0){o===$&&A.c()
o.$flags&2&&A.b(o)
if(!(i>=0&&i<o.length))return A.a(o,i)
o[i]=1
f=n[1]
j&2&&A.b(n)
n[1]=f+1}else{o===$&&A.c()
o.$flags&2&&A.b(o)
if(!(i>=0&&i<o.length))return A.a(o,i)
o[i]=0
f=n[0]
j&2&&A.b(n)
n[0]=f+1}if(h<2){i=d
break}h=B.a.t(h-2,2)}h=0}c=a2[1]
a2[1]=a2[0]
for(b=1;e!==c;c=a){++b
if(!(b<256))return A.a(a2,b)
a=a2[b]
a2[b]=c}a2[0]=c
o===$&&A.c()
f=b+1
o.$flags&2&&A.b(o)
if(!(i>=0&&i<o.length))return A.a(o,i)
o[i]=f;++i
if(!(f<258))return A.a(n,f)
a0=n[f]
j&2&&A.b(n)
n[f]=a0+1}}if(h>0){--h
for(;;i=d){d=i+1
if((h&1)!==0){o===$&&A.c()
o.$flags&2&&A.b(o)
if(!(i>=0&&i<o.length))return A.a(o,i)
o[i]=1
r=n[1]
j&2&&A.b(n)
n[1]=r+1}else{o===$&&A.c()
o.$flags&2&&A.b(o)
if(!(i>=0&&i<o.length))return A.a(o,i)
o[i]=0
r=n[0]
j&2&&A.b(n)
n[0]=r+1}if(h<2){i=d
break}h=B.a.t(h-2,2)}}o===$&&A.c()
o.$flags&2&&A.b(o)
if(!(i>=0&&i<o.length))return A.a(o,i)
o[i]=p
if(!(p<258))return A.a(n,p)
r=n[p]
j&2&&A.b(n)
n[p]=r+1
a1.db=i+1
return!0},
kv(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7=this,b8={},b9=new Uint16Array(6),c0=new Int32Array(6),c1=b7.cy
c1===$&&A.c()
s=c1+2
for(c1=b7.fr,r=0;r<6;++r)for(q=0;q<s;++q){c1===$&&A.c()
p=c1[r]
p.$flags&2&&A.b(p)
if(!(q<p.length))return A.a(p,q)
p[q]=15}c1=b7.db
c1===$&&A.c()
if(c1<=0)return!1
if(c1<200)o=2
else if(c1<600)o=3
else if(c1<1200)o=4
else o=c1<2400?5:6
b8.a=0
for(p=s-1,n=c1,m=o,c1=0;m>0;c1=g){l=B.a.a2(n,m)
k=c1-1
j=b7.dx
i=0
for(;;){if(!(i<l&&k<p))break;++k
j===$&&A.c()
if(!(k>=0&&k<258))return A.a(j,k)
i+=j[k]}if(k>c1&&m!==o&&m!==1&&B.a.E(o-m,2)===1){j===$&&A.c()
if(!(k>=0&&k<258))return A.a(j,k)
i-=j[k];--k}for(j=b7.fr,--m,q=0;q<s;++q)if(q>=c1&&q<=k){j===$&&A.c()
h=j[m]
h.$flags&2&&A.b(h)
if(!(q<h.length))return A.a(h,q)
h[q]=0}else{j===$&&A.c()
h=j[m]
h.$flags&2&&A.b(h)
if(!(q<h.length))return A.a(h,q)
h[q]=15}g=k+1
b8.a=g
n-=i}for(c1=o===6,f=0,e=0;e<4;++e){for(r=0;r<o;++r)c0[r]=0
for(p=b7.fy,r=0;r<o;++r)for(q=0;q<s;++q){p===$&&A.c()
j=p[r]
j.$flags&2&&A.b(j)
if(!(q<j.length))return A.a(j,q)
j[q]=0}if(c1)for(p=b7.go,j=b7.fr,q=0;q<s;++q){p===$&&A.c()
if(!(q<258))return A.a(p,q)
h=p[q]
j===$&&A.c()
d=j[1]
if(!(q<d.length))return A.a(d,q)
d=d[q]
c=j[0]
if(!(q<c.length))return A.a(c,q)
c=c[q]
h.$flags&2&&A.b(h)
b=h.length
if(0>=b)return A.a(h,0)
h[0]=(d<<16|c)>>>0
c=j[3]
if(!(q<c.length))return A.a(c,q)
c=c[q]
d=j[2]
if(!(q<d.length))return A.a(d,q)
d=d[q]
if(1>=b)return A.a(h,1)
h[1]=(c<<16|d)>>>0
d=j[5]
if(!(q<d.length))return A.a(d,q)
d=d[q]
c=j[4]
if(!(q<c.length))return A.a(c,q)
c=c[q]
if(2>=b)return A.a(h,2)
h[2]=(d<<16|c)>>>0}b8.a=0
for(f=0,a=0,a0=0;;a0=g){a1={}
p=b7.db
if(a0>=p)break
k=a0+50-1
if(k>=p)k=p-1
for(r=0;r<o;++r)b9[r]=0
if(c1&&50===k-a0+1){p={}
p.a=p.b=p.c=0
j=new A.hX(b8,p,b7)
j.$1(0)
j.$1(1)
j.$1(2)
j.$1(3)
j.$1(4)
j.$1(5)
j.$1(6)
j.$1(7)
j.$1(8)
j.$1(9)
j.$1(10)
j.$1(11)
j.$1(12)
j.$1(13)
j.$1(14)
j.$1(15)
j.$1(16)
j.$1(17)
j.$1(18)
j.$1(19)
j.$1(20)
j.$1(21)
j.$1(22)
j.$1(23)
j.$1(24)
j.$1(25)
j.$1(26)
j.$1(27)
j.$1(28)
j.$1(29)
j.$1(30)
j.$1(31)
j.$1(32)
j.$1(33)
j.$1(34)
j.$1(35)
j.$1(36)
j.$1(37)
j.$1(38)
j.$1(39)
j.$1(40)
j.$1(41)
j.$1(42)
j.$1(43)
j.$1(44)
j.$1(45)
j.$1(46)
j.$1(47)
j.$1(48)
j.$1(49)
j=p.c
b9[0]=j&65535
b9[1]=j>>>16
j=p.b
b9[2]=j&65535
b9[3]=j>>>16
p=p.a
b9[4]=p&65535
b9[5]=p>>>16}else for(p=b7.fr,j=b7.cx;a0<=k;++a0){j===$&&A.c()
if(!(a0>=0&&a0<j.length))return A.a(j,a0)
a2=j[a0]
for(r=0;r<o;++r){h=b9[r]
p===$&&A.c()
d=p[r]
if(!(a2<d.length))return A.a(d,a2)
b9[r]=h+d[a2]}}a1.a=-1
for(a3=999999999,r=0;r<o;++r){a4=b9[r]
if(a4<a3){a1.a=r
a3=a4}}a+=a3
p=a1.a
if(!(p>=0&&p<6))return A.a(c0,p)
c0[p]=c0[p]+1
j=b7.id
j===$&&A.c()
j.$flags&2&&A.b(j)
if(!(f<18002))return A.a(j,f)
j[f]=p;++f
if(c1&&50===k-b8.a+1){p=new A.hY(a1,b8,b7)
p.$1(0)
p.$1(1)
p.$1(2)
p.$1(3)
p.$1(4)
p.$1(5)
p.$1(6)
p.$1(7)
p.$1(8)
p.$1(9)
p.$1(10)
p.$1(11)
p.$1(12)
p.$1(13)
p.$1(14)
p.$1(15)
p.$1(16)
p.$1(17)
p.$1(18)
p.$1(19)
p.$1(20)
p.$1(21)
p.$1(22)
p.$1(23)
p.$1(24)
p.$1(25)
p.$1(26)
p.$1(27)
p.$1(28)
p.$1(29)
p.$1(30)
p.$1(31)
p.$1(32)
p.$1(33)
p.$1(34)
p.$1(35)
p.$1(36)
p.$1(37)
p.$1(38)
p.$1(39)
p.$1(40)
p.$1(41)
p.$1(42)
p.$1(43)
p.$1(44)
p.$1(45)
p.$1(46)
p.$1(47)
p.$1(48)
p.$1(49)}else for(a0=b8.a,j=b7.fy,h=b7.cx;a0<=k;++a0){j===$&&A.c()
d=j[p]
h===$&&A.c()
if(!(a0>=0&&a0<h.length))return A.a(h,a0)
c=h[a0]
if(!(c<d.length))return A.a(d,c)
b=d[c]
d.$flags&2&&A.b(d)
d[c]=b+1}g=k+1
b8.a=g}for(r=0;r<o;++r){p=b7.fr
p===$&&A.c()
p=p[r]
j=b7.fy
j===$&&A.c()
if(!b7.jv(p,j[r],s,17))return!1}}if(!(f<32768&&f<=18002))return!1
a5=new Uint8Array(6)
for(a0=0;a0<o;++a0)a5[a0]=a0
for(p=b7.k1,j=b7.id,a0=0;a0<f;++a0){j===$&&A.c()
if(!(a0<18002))return A.a(j,a0)
a6=j[a0]
a7=a5[0]
for(a8=0;a6!==a7;a7=a9){++a8
if(!(a8<6))return A.a(a5,a8)
a9=a5[a8]
a5[a8]=a7}a5[0]=a7
p===$&&A.c()
p.$flags&2&&A.b(p)
p[a0]=a8}for(r=0;r<o;++r){for(p=b7.fr,b0=32,b1=0,a0=0;a0<s;++a0){p===$&&A.c()
j=p[r]
if(!(a0<j.length))return A.a(j,a0)
b2=j[a0]
if(b2>b1)b1=b2
if(b2<b0)b0=b2}if(b1>17)return!1
if(b0<1)return!1
j=b7.fx
j===$&&A.c()
j=j[r]
p===$&&A.c()
b7.jt(j,p[r],b0,b1,s)}b3=new Uint8Array(16)
for(p=b7.CW,a0=0;a0<16;++a0){b3[a0]=0
for(j=a0*16,a8=0;a8<16;++a8){p===$&&A.c()
h=j+a8
if(!(h<256))return A.a(p,h)
if(p[h]!==0)b3[a0]=1}}for(a0=0;a0<16;++a0){p=b3[a0]
j=b7.c
if(p!==0){j===$&&A.c()
j.a7(1,1)}else{j===$&&A.c()
j.a7(1,0)}}for(a0=0;a0<16;++a0)if(b3[a0]!==0)for(p=a0*16,a8=0;a8<16;++a8){j=b7.CW
j===$&&A.c()
h=p+a8
if(!(h<256))return A.a(j,h)
h=j[h]
j=b7.c
if(h!==0){j===$&&A.c()
j.a7(1,1)}else{j===$&&A.c()
j.a7(1,0)}}p=b7.c
p===$&&A.c()
p.a7(3,o)
b7.c.a7(15,f)
for(a0=0;a0<f;++a0){a8=0
for(;;){p=b7.k1
p===$&&A.c()
if(!(a0<18002))return A.a(p,a0)
if(!(a8<p[a0]))break
b7.c.a7(1,1);++a8}b7.c.a7(1,0)}for(r=0;r<o;++r){p=b7.fr
p===$&&A.c()
p=p[r]
if(0>=p.length)return A.a(p,0)
b4=p[0]
b7.c.a7(5,b4)
for(a0=0;a0<s;++a0){for(;;){p=b7.fr[r]
if(!(a0<p.length))return A.a(p,a0)
if(!(b4<p[a0]))break
b7.c.a7(2,2);++b4}for(;;){p=b7.fr[r]
if(!(a0<p.length))return A.a(p,a0)
if(!(b4>p[a0]))break
b7.c.a7(2,3);--b4}b7.c.a7(1,0)}}b8.a=0
for(b5=0,a0=0;;a0=g){p=b7.db
if(a0>=p)break
k=a0+50-1
if(k>=p)k=p-1
p=b7.id
p===$&&A.c()
if(!(b5<18002))return A.a(p,b5)
p=p[b5]
if(p>=o)return!1
if(c1&&50===k-a0+1){j={}
j.a=null
h=b7.fr
h===$&&A.c()
if(!(p>=0))return A.a(h,p)
b6=h[p]
h=b7.fx
h===$&&A.c()
p=new A.hW(j,b8,b7,b6,h[p])
p.$1(0)
p.$1(1)
p.$1(2)
p.$1(3)
p.$1(4)
p.$1(5)
p.$1(6)
p.$1(7)
p.$1(8)
p.$1(9)
p.$1(10)
p.$1(11)
p.$1(12)
p.$1(13)
p.$1(14)
p.$1(15)
p.$1(16)
p.$1(17)
p.$1(18)
p.$1(19)
p.$1(20)
p.$1(21)
p.$1(22)
p.$1(23)
p.$1(24)
p.$1(25)
p.$1(26)
p.$1(27)
p.$1(28)
p.$1(29)
p.$1(30)
p.$1(31)
p.$1(32)
p.$1(33)
p.$1(34)
p.$1(35)
p.$1(36)
p.$1(37)
p.$1(38)
p.$1(39)
p.$1(40)
p.$1(41)
p.$1(42)
p.$1(43)
p.$1(44)
p.$1(45)
p.$1(46)
p.$1(47)
p.$1(48)
p.$1(49)}else for(;a0<=k;++a0){p=b7.c
j=b7.fr
j===$&&A.c()
h=b7.id[b5]
if(!(h>=0&&h<6))return A.a(j,h)
j=j[h]
d=b7.cx
d===$&&A.c()
if(!(a0>=0&&a0<d.length))return A.a(d,a0)
d=d[a0]
if(!(d<j.length))return A.a(j,d)
j=j[d]
c=b7.fx
c===$&&A.c()
h=c[h]
if(!(d<h.length))return A.a(h,d)
p.a7(j,h[d])}g=k+1
b8.a=g;++b5}return b5===f},
jv(a,b,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f={},e=new Int32Array(260),d=new Int32Array(516),c=new Int32Array(516)
f.a=0
for(s=b.length,r=0;r<a0;r=q){q=r+1
if(!(r<s))return A.a(b,r)
p=b[r]
if(p===0)p=1
if(!(q<516))return A.a(d,q)
d[q]=p<<8>>>0}o=new A.hN(e,d)
n=new A.hL(f,e,d)
m=new A.hJ(new A.hO(),new A.hM(),new A.hK())
for(;;){f.a=0
if(0>=260)return A.a(e,0)
e[0]=0
if(0>=516)return A.a(d,0)
d[0]=0
if(0>=516)return A.a(c,0)
c[0]=-2
for(r=1;r<=a0;++r){if(!(r<516))return A.a(c,r)
c[r]=-1
s=++f.a
if(!(s>=0&&s<260))return A.a(e,s)
e[s]=r
o.$1(s)}if(f.a>=260)return!1
for(l=a0;s=f.a,s>1;){k=e[1]
if(!(s<260))return A.a(e,s)
e[1]=e[s]
f.a=s-1
n.$1(1)
j=e[1]
s=f.a
if(!(s>=0&&s<260))return A.a(e,s)
e[1]=e[s]
f.a=s-1
n.$1(1);++l
if(!(j>=0&&j<516))return A.a(c,j)
c[j]=l
if(!(k>=0&&k<516))return A.a(c,k)
c[k]=l
if(!(k<516))return A.a(d,k)
s=d[k]
if(!(j<516))return A.a(d,j)
B.c8.D(d,l,m.$2(s,d[j]))
if(!(l<516))return A.a(c,l)
c[l]=-1
s=++f.a
if(!(s>=0&&s<260))return A.a(e,s)
e[s]=l
o.$1(s)}if(l>=516)return!1
for(s=a.$flags|0,i=!1,r=1;r<=a0;++r){h=r
g=0
for(;;){if(!(h>=0&&h<516))return A.a(c,h)
h=c[h]
if(!(h>=0))break;++g}p=r-1
s&2&&A.b(a)
if(!(p<a.length))return A.a(a,p)
a[p]=g
if(g>a1)i=!0}if(!i)break
for(r=1;r<=a0;++r){if(!(r<516))return A.a(d,r)
g=B.a.k(d[r],8)
if(!(r<516))return A.a(d,r)
d[r]=1+(g/2|0)<<8>>>0}}return!0},
jt(a,b,c,d,e){var s,r,q,p,o
for(s=b.length,r=a.$flags|0,q=c,p=0;q<=d;++q){for(o=0;o<e;++o){if(!(o<s))return A.a(b,o)
if(b[o]===q){r&2&&A.b(a)
if(!(o<a.length))return A.a(a,o)
a[o]=p;++p}}p=p<<1>>>0}},
iD(){var s,r,q,p,o,n,m=this,l=m.w
l===$&&A.c()
if(l<1e4){s=m.at
s===$&&A.c()
r=m.ax
r===$&&A.c()
q=m.ay
q===$&&A.c()
m.fl(s,r,q,l)}else{p=l+34
if((p&1)!==0)++p
l=m.ch
l===$&&A.c()
o=J.nE(B.c.gN(l),p,null)
l=m.z
l===$&&A.c()
if(l<1)n=1
else n=l
if(n>100)n=100
l=m.w
m.Q=l*B.a.t(n-1,3)
s=m.at
s===$&&A.c()
r=m.ch
q=m.ay
q===$&&A.c()
if(!m.jL(s,r,o,q,l))return!1
if(m.Q<0){l=m.at
s=m.ax
s===$&&A.c()
m.fl(l,s,m.ay,m.w)}}m.as=-1
for(l=m.w,s=m.at,p=0;p<l;++p){s===$&&A.c()
if(!(p<s.length))return A.a(s,p)
if(s[p]===0){m.as=p
break}}return m.as!==-1},
fl(a3,a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=new Int32Array(257),d=new Int32Array(256),c=J.ak(B.f.gN(a4),0,null),b=new A.hG(a5),a=new A.hE(a5),a0=new A.hF(a5),a1=new A.hI(a5),a2=new A.hH()
for(s=0;s<257;++s){if(!(s<257))return A.a(e,s)
e[s]=0}for(r=c.length,s=0;s<a6;++s){if(!(s<r))return A.a(c,s)
q=c[s]
if(!(q<257))return A.a(e,q)
p=e[q]
if(!(q<257))return A.a(e,q)
e[q]=p+1}for(s=0;s<256;++s){q=e[s]
if(!(s<256))return A.a(d,s)
d[s]=q}for(s=1;s<257;++s){q=e[s]
p=e[s-1]
if(!(s<257))return A.a(e,s)
e[s]=q+p}for(q=a3.$flags|0,s=0;s<a6;++s){if(!(s<r))return A.a(c,s)
o=c[s]
if(!(o<257))return A.a(e,o)
n=e[o]-1
if(!(o<257))return A.a(e,o)
e[o]=n
q&2&&A.b(a3)
if(!(n>=0&&n<a3.length))return A.a(a3,n)
a3[n]=s}m=2+B.a.t(a6,32)
for(q=a5.$flags|0,s=0;s<m;++s){q&2&&A.b(a5)
if(!(s<65537))return A.a(a5,s)
a5[s]=0}for(s=0;s<256;++s)b.$1(e[s])
for(s=0;s<32;++s){q=a6+2*s
b.$1(q)
a.$1(q+1)}for(q=a3.length,p=a4.length,l=1;;){for(o=0,s=0;s<a6;++s){if(a0.$1(s))o=s
if(!(s<q))return A.a(a3,s)
n=a3[s]-l
if(n<0)n+=a6
a4.$flags&2&&A.b(a4)
if(!(n>=0&&n<p))return A.a(a4,n)
a4[n]=o}for(k=0,j=-1;;){n=j+1
for(;;){if(!(a0.$1(n)&&a2.$1(n)))break;++n}if(a0.$1(n)){while(J.T(a1.$1(n),4294967295))n+=32
while(a0.$1(n))++n}i=n-1
if(i>=a6)break
for(;;){if(!(!a0.$1(n)&&a2.$1(n)))break;++n}if(!a0.$1(n)){while(J.T(a1.$1(n),0))n+=32
while(!a0.$1(n))++n}j=n-1
if(j>=a6)break
if(j>i){k+=j-i+1
if(!this.jd(a3,a4,i,j))return!1
for(s=i,h=-1;s<=j;++s){if(!(s>=0&&s<q))return A.a(a3,s)
g=a3[s]
if(!(g<p))return A.a(a4,g)
f=a4[g]
if(h!==f){b.$1(s)
h=f}}}}l*=2
if(l>a6||k===0)break}for(p=c.$flags|0,o=0,s=0;s<a6;++s){for(;;){if(!(o>=0&&o<256))return A.a(d,o)
g=d[o]
if(!(g===0))break;++o}if(!(o<256))return A.a(d,o)
d[o]=g-1
if(!(s<q))return A.a(a3,s)
g=a3[s]
p&2&&A.b(c)
if(!(g<r))return A.a(c,g)
c[g]=o}return o<256},
jd(a5,a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2={},a3=new Int32Array(100),a4=new Int32Array(100)
a2.a=0
s=new A.hC(a2,a3,a4)
r=new A.hB()
q=new A.hD(a5)
s.$2(a7,a8)
for(p=a5.length,o=a5.$flags|0,n=a6.length,m=0;l=a2.a,l>0;){if(l>=99)return!1
k=a2.a=l-1
j=a3[k]
i=a4[k]
if(i-j<10){this.je(a5,a6,j,i)
continue}m=(m*7621+1)%32768
h=B.a.E(m,3)
if(h===0){if(!(j>=0&&j<p))return A.a(a5,j)
l=a5[j]
if(!(l<n))return A.a(a6,l)
g=a6[l]}else if(h===1){l=B.a.k(j+i,1)
if(!(l<p))return A.a(a5,l)
l=a5[l]
if(!(l<n))return A.a(a6,l)
g=a6[l]}else{if(!(i>=0&&i<p))return A.a(a5,i)
l=a5[i]
if(!(l<n))return A.a(a6,l)
g=a6[l]}for(f=i,e=f,d=j,c=d;;){for(;;){if(c>e)break
if(!(c>=0&&c<p))return A.a(a5,c)
l=a5[c]
if(!(l<n))return A.a(a6,l)
b=a6[l]-g
if(b===0){if(!(d>=0&&d<p))return A.a(a5,d)
a=a5[d]
o&2&&A.b(a5)
a5[c]=a
a5[d]=l;++d;++c
continue}if(b>0)break;++c}for(;;){if(c>e)break
if(!(e>=0&&e<p))return A.a(a5,e)
l=a5[e]
if(!(l<n))return A.a(a6,l)
b=a6[l]-g
if(b===0){if(!(f>=0&&f<p))return A.a(a5,f)
a=a5[f]
o&2&&A.b(a5)
a5[e]=a
a5[f]=l;--f;--e
continue}if(b<0)break;--e}if(c>e)break
if(!(c>=0&&c<p))return A.a(a5,c)
a0=a5[c]
if(!(e>=0&&e<p))return A.a(a5,e)
l=a5[e]
o&2&&A.b(a5)
a5[c]=l
a5[e]=a0;++c;--e}if(e!==c-1)return!1
if(f<d)continue
b=r.$2(d-j,c-d)
q.$3(j,c-b,b)
l=f-e
a1=r.$2(i-f,l)
q.$3(c,i-a1+1,a1)
b=j+c-d-1
a1=i-l+1
if(b-j>i-a1){s.$2(j,b)
s.$2(a1,i)}else{s.$2(a1,i)
s.$2(j,b)}}return!0},
je(a,b,c,d){var s,r,q,p,o,n,m,l,k
if(c===d)return
if(d-c>3)for(s=d-4,r=a.$flags|0,q=a.length,p=b.length;s>=c;--s){if(!(s>=0&&s<q))return A.a(a,s)
o=a[s]
if(!(o<p))return A.a(b,o)
n=b[o]
m=s+4
for(;;){if(m<=d){if(!(m<q))return A.a(a,m)
l=a[m]
if(!(l<p))return A.a(b,l)
l=n>b[l]}else l=!1
if(!l)break
l=m-4
if(!(m<q))return A.a(a,m)
k=a[m]
r&2&&A.b(a)
if(!(l<q))return A.a(a,l)
a[l]=k
m+=4}l=m-4
r&2&&A.b(a)
if(!(l<q))return A.a(a,l)
a[l]=o}for(s=d-1,r=a.$flags|0,q=a.length,p=b.length;s>=c;--s){if(!(s>=0&&s<q))return A.a(a,s)
o=a[s]
if(!(o<p))return A.a(b,o)
n=b[o]
m=s+1
for(;;){if(m<=d){if(!(m<q))return A.a(a,m)
l=a[m]
if(!(l<p))return A.a(b,l)
l=n>b[l]}else l=!1
if(!l)break
l=m-1
if(!(m<q))return A.a(a,m)
k=a[m]
r&2&&A.b(a)
if(!(l<q))return A.a(a,l)
a[l]=k;++m}l=m-1
r&2&&A.b(a)
if(!(l<q))return A.a(a,l)
a[l]=o}},
jL(b3,b4,b5,b6,b7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7=this,a8=new Int32Array(256),a9=new Uint8Array(256),b0=new Int32Array(256),b1=new Int32Array(256),b2=new A.hV(a7)
for(s=b6.$flags|0,r=65536;r>=0;--r){s&2&&A.b(b6)
if(!(r<65537))return A.a(b6,r)
b6[r]=0}q=b4.length
if(0>=q)return A.a(b4,0)
p=b4[0]<<8
r=b7-1
for(o=b5.$flags|0,n=r;n>=3;n-=4){o&2&&A.b(b5)
m=b5.length
if(!(n<m))return A.a(b5,n)
b5[n]=0
if(!(n<q))return A.a(b4,n)
p=(p>>>8|b4[n]<<8)>>>0
if(!(p<65537))return A.a(b6,p)
l=b6[p]
s&2&&A.b(b6)
if(!(p<65537))return A.a(b6,p)
b6[p]=l+1
l=n-1
if(!(l<m))return A.a(b5,l)
b5[l]=0
if(!(l<q))return A.a(b4,l)
p=(p>>>8|b4[l]<<8)>>>0
if(!(p<65537))return A.a(b6,p)
l=b6[p]
if(!(p<65537))return A.a(b6,p)
b6[p]=l+1
l=n-2
if(!(l<m))return A.a(b5,l)
b5[l]=0
if(!(l<q))return A.a(b4,l)
p=(p>>>8|b4[l]<<8)>>>0
if(!(p<65537))return A.a(b6,p)
l=b6[p]
if(!(p<65537))return A.a(b6,p)
b6[p]=l+1
l=n-3
if(!(l<m))return A.a(b5,l)
b5[l]=0
if(!(l<q))return A.a(b4,l)
p=(p>>>8|b4[l]<<8)>>>0
if(!(p<65537))return A.a(b6,p)
l=b6[p]
if(!(p<65537))return A.a(b6,p)
b6[p]=l+1}for(;n>=0;--n){o&2&&A.b(b5)
if(!(n<b5.length))return A.a(b5,n)
b5[n]=0
if(!(n<q))return A.a(b4,n)
p=(p>>>8|b4[n]<<8)>>>0
if(!(p<65537))return A.a(b6,p)
m=b6[p]
s&2&&A.b(b6)
if(!(p<65537))return A.a(b6,p)
b6[p]=m+1}for(m=b4.$flags|0,n=0;n<34;++n){l=b7+n
if(!(n<q))return A.a(b4,n)
k=b4[n]
m&2&&A.b(b4)
if(!(l<q))return A.a(b4,l)
b4[l]=k
o&2&&A.b(b5)
if(!(l<b5.length))return A.a(b5,l)
b5[l]=0}for(n=1;n<=65536;++n){o=b6[n]
m=b6[n-1]
s&2&&A.b(b6)
if(!(n<65537))return A.a(b6,n)
b6[n]=o+m}j=b4[0]<<8
for(o=b3.$flags|0,n=r;n>=3;n-=4){if(!(n<q))return A.a(b4,n)
j=(j>>>8|b4[n]<<8)>>>0
if(!(j<65537))return A.a(b6,j)
p=b6[j]-1
s&2&&A.b(b6)
if(!(j<65537))return A.a(b6,j)
b6[j]=p
o&2&&A.b(b3)
m=b3.length
if(!(p>=0&&p<m))return A.a(b3,p)
b3[p]=n
l=n-1
if(!(l<q))return A.a(b4,l)
j=(j>>>8|b4[l]<<8)>>>0
if(!(j<65537))return A.a(b6,j)
p=b6[j]-1
if(!(j<65537))return A.a(b6,j)
b6[j]=p
if(!(p>=0&&p<m))return A.a(b3,p)
b3[p]=l
l=n-2
if(!(l<q))return A.a(b4,l)
j=(j>>>8|b4[l]<<8)>>>0
if(!(j<65537))return A.a(b6,j)
p=b6[j]-1
if(!(j<65537))return A.a(b6,j)
b6[j]=p
if(!(p>=0&&p<m))return A.a(b3,p)
b3[p]=l
l=n-3
if(!(l<q))return A.a(b4,l)
j=(j>>>8|b4[l]<<8)>>>0
if(!(j<65537))return A.a(b6,j)
p=b6[j]-1
if(!(j<65537))return A.a(b6,j)
b6[j]=p
if(!(p>=0&&p<m))return A.a(b3,p)
b3[p]=l}for(;n>=0;--n){if(!(n<q))return A.a(b4,n)
j=(j>>>8|b4[n]<<8)>>>0
if(!(j<65537))return A.a(b6,j)
p=b6[j]-1
s&2&&A.b(b6)
if(!(j<65537))return A.a(b6,j)
b6[j]=p
o&2&&A.b(b3)
if(!(p>=0&&p<b3.length))return A.a(b3,p)
b3[p]=n}for(n=0;n<=255;++n){if(!(n<256))return A.a(a9,n)
a9[n]=0
if(!(n<256))return A.a(a8,n)
a8[n]=n}i=1
do i=3*i+1
while(i<=256)
do{i=B.a.t(i,3)
for(s=i-1,n=i;n<=255;++n){h=a8[n]
p=n
for(;;){g=p-i
if(!(g>=0))return A.a(a8,g)
o=b2.$1(a8[g])
m=b2.$1(h)
if(typeof o!=="number")return o.eC()
if(typeof m!=="number")return A.Z(m)
if(!(o>m))break
o=a8[g]
if(!(p>=0))return A.a(a8,p)
a8[p]=o
if(g<=s){p=g
break}p=g}if(!(p>=0))return A.a(a8,p)
a8[p]=h}}while(i!==1)
for(s=b3.length,n=0,f=0;n<=255;++n){e=a8[n]
for(o=e<<8>>>0,p=0;p<=255;++p)if(p!==e){d=o+p
m=a7.ay
m===$&&A.c()
if(!(d<65537))return A.a(m,d)
l=m[d]
if((l&2097152)===0){c=(l&4292870143)>>>0
l=d+1
if(!(l<65537))return A.a(m,l)
b=((m[l]&4292870143)>>>0)-1
if(b>c){if(!a7.jJ(b3,b4,b5,b7,c,b,2))return!1
f+=b-c+1
m=a7.Q
m===$&&A.c()
if(m<0)return!0}}m=a7.ay
l=m[d]
m.$flags&2&&A.b(m)
m[d]=(l|2097152)>>>0}if(!(e>=0&&e<256))return A.a(a9,e)
if(a9[e]!==0)return!1
for(m=a7.ay,p=0;p<=255;++p){m===$&&A.c()
l=(p<<8>>>0)+e
if(!(l<65537))return A.a(m,l)
k=m[l]
if(!(p<256))return A.a(b0,p)
b0[p]=(k&4292870143)>>>0;++l
if(!(l<65537))return A.a(m,l)
l=m[l]
if(!(p<256))return A.a(b1,p)
b1[p]=((l&4292870143)>>>0)-1}m===$&&A.c()
if(!(o<65537))return A.a(m,o)
p=(m[o]&4292870143)>>>0
l=b3.$flags|0
for(;p<b0[e];++p){if(!(p<s))return A.a(b3,p)
a=b3[p]-1
if(a<0)a+=b7
if(!(a>=0&&a<q))return A.a(b4,a)
a0=b4[a]
if(!(a0<256))return A.a(a9,a0)
if(a9[a0]===0){k=b0[a0]
if(!(a0<256))return A.a(b0,a0)
b0[a0]=k+1
l&2&&A.b(b3)
if(!(k>=0&&k<s))return A.a(b3,k)
b3[k]=a}}k=e+1<<8>>>0
if(!(k<65537))return A.a(m,k)
p=((m[k]&4292870143)>>>0)-1
for(;a1=b1[e],p>a1;--p){if(!(p>=0&&p<s))return A.a(b3,p)
a=b3[p]-1
if(a<0)a+=b7
if(!(a>=0&&a<q))return A.a(b4,a)
a0=b4[a]
if(!(a0<256))return A.a(a9,a0)
if(a9[a0]===0){a1=b1[a0]
if(!(a0<256))return A.a(b1,a0)
b1[a0]=a1-1
l&2&&A.b(b3)
if(!(a1>=0&&a1<s))return A.a(b3,a1)
b3[a1]=a}}l=b0[e]
if(l-1!==a1)l=l===0&&a1===r
else l=!0
if(!l)return!1
for(p=0;p<=255;++p){l=(p<<8>>>0)+e
if(!(l<65537))return A.a(m,l)
a1=m[l]
m.$flags&2&&A.b(m)
m[l]=(a1|2097152)>>>0}if(!(e<256))return A.a(a9,e)
a9[e]=1
if(n<255){a2=(m[o]&4292870143)>>>0
a3=((m[k]&4292870143)>>>0)-a2
if(a3>0){for(a4=0;B.a.k(a3,a4)>65534;)++a4
for(p=a3-1,o=b5.$flags|0,g=p;g>=0;--g){m=a2+g
if(!(m<s))return A.a(b3,m)
a5=b3[m]
a6=B.a.k(g,a4)&65535
o&2&&A.b(b5)
m=b5.length
if(!(a5<m))return A.a(b5,a5)
b5[a5]=a6
if(a5<34){l=a5+b7
if(!(l<m))return A.a(b5,l)
b5[l]=a6}if(B.a.k(p,a4)>65535)return!1}}}}return!0},
jJ(b2,b3,b4,b5,b6,b7,b8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5={},a6=new Int32Array(100),a7=new Int32Array(100),a8=new Int32Array(100),a9=new Int32Array(3),b0=new Int32Array(3),b1=new Int32Array(3)
a5.a=0
s=new A.hT(a5,a6,a7,a8)
r=new A.hP()
q=new A.hU(b2)
p=new A.hQ()
o=new A.hR(b0,a9)
n=new A.hS(a9,b0,b1)
s.$3(b6,b7,b8)
for(m=b2.length,l=b2.$flags|0,k=b3.length;j=a5.a,j>0;){if(j>=98)return!1
i=a5.a=j-1
h=a6[i]
g=a7[i]
f=a8[i]
if(g-h<20||f>14){this.jK(b2,b3,b4,b5,h,g,f)
j=this.Q
j===$&&A.c()
if(j<0)return!0
continue}if(!(h>=0&&h<m))return A.a(b2,h)
j=b2[h]+f
if(!(j>=0&&j<k))return A.a(b3,j)
j=b3[j]
if(!(g>=0&&g<m))return A.a(b2,g)
e=b2[g]+f
if(!(e>=0&&e<k))return A.a(b3,e)
e=b3[e]
d=B.a.k(h+g,1)
if(!(d<m))return A.a(b2,d)
d=b2[d]+f
if(!(d>=0&&d<k))return A.a(b3,d)
c=r.$3(j,e,b3[d])
for(b=g,a=b,a0=h,a1=a0;;){for(;;){if(a1>a)break
if(!(a1>=0&&a1<m))return A.a(b2,a1)
j=b2[a1]
e=j+f
if(!(e>=0&&e<k))return A.a(b3,e)
a2=b3[e]-c
if(a2===0){if(!(a0>=0&&a0<m))return A.a(b2,a0)
e=b2[a0]
l&2&&A.b(b2)
b2[a1]=e
b2[a0]=j;++a0;++a1
continue}if(a2>0)break;++a1}for(;;){if(a1>a)break
if(!(a>=0&&a<m))return A.a(b2,a)
j=b2[a]
e=j+f
if(!(e>=0&&e<k))return A.a(b3,e)
a2=b3[e]-c
if(a2===0){if(!(b>=0&&b<m))return A.a(b2,b)
e=b2[b]
l&2&&A.b(b2)
b2[a]=e
b2[b]=j;--b;--a
continue}if(a2<0)break;--a}if(a1>a)break
if(!(a1>=0&&a1<m))return A.a(b2,a1)
a3=b2[a1]
if(!(a>=0&&a<m))return A.a(b2,a)
j=b2[a]
l&2&&A.b(b2)
b2[a1]=j
b2[a]=a3;++a1;--a}if(a!==a1-1)return!1
if(b<a0){s.$3(h,g,f+1)
continue}a2=p.$2(a0-h,a1-a0)
q.$3(h,a1-a2,a2)
j=b-a
a4=p.$2(g-b,j)
q.$3(a1,g-a4+1,a4)
a2=h+a1-a0-1
a4=g-j+1
if(0>=3)return A.a(a9,0)
a9[0]=h
if(0>=3)return A.a(b0,0)
b0[0]=a2
if(0>=3)return A.a(b1,0)
b1[0]=f
if(1>=3)return A.a(a9,1)
a9[1]=a4
if(1>=3)return A.a(b0,1)
b0[1]=g
if(1>=3)return A.a(b1,1)
b1[1]=f
if(2>=3)return A.a(a9,2)
a9[2]=a2+1
if(2>=3)return A.a(b0,2)
b0[2]=a4-1
if(2>=3)return A.a(b1,2)
b1[2]=f+1
j=o.$1(0)
e=o.$1(1)
if(typeof j!=="number")return j.ar()
if(typeof e!=="number")return A.Z(e)
if(j<e)n.$2(0,1)
j=o.$1(1)
e=o.$1(2)
if(typeof j!=="number")return j.ar()
if(typeof e!=="number")return A.Z(e)
if(j<e)n.$2(1,2)
j=o.$1(0)
e=o.$1(1)
if(typeof j!=="number")return j.ar()
if(typeof e!=="number")return A.Z(e)
if(j<e)n.$2(0,1)
j=o.$1(0)
e=o.$1(1)
if(typeof j!=="number")return j.ar()
if(typeof e!=="number")return A.Z(e)
if(j<e)return!1
j=o.$1(1)
e=o.$1(2)
if(typeof j!=="number")return j.ar()
if(typeof e!=="number")return A.Z(e)
if(j<e)return!1
s.$3(a9[0],b0[0],b1[0])
s.$3(a9[1],b0[1],b1[1])
s.$3(a9[2],b0[2],b1[2])}return!0},
jK(a,b,c,d,e,f,a0){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=f-e+1
if(g<2)return
s=0
for(;;){if(!(s<14))return A.a(B.X,s)
if(!(B.X[s]<g))break;++s}--s
for(r=a.$flags|0,q=a.length;s>=0;--s){p=B.X[s]
o=e+p
for(n=o-1;;){if(o>f)break
if(!(o>=0&&o<q))return A.a(a,o)
m=a[o]
l=m+a0
k=o
for(;;){j=k-p
if(!(j>=0&&j<q))return A.a(a,j)
if(!h.dD(a[j]+a0,l,b,c,d))break
i=a[j]
r&2&&A.b(a)
if(!(k>=0&&k<q))return A.a(a,k)
a[k]=i
if(j<=n){k=j
break}k=j}r&2&&A.b(a)
if(!(k>=0&&k<q))return A.a(a,k)
a[k]=m;++o
if(o>f)break
if(!(o<q))return A.a(a,o)
m=a[o]
l=m+a0
k=o
for(;;){j=k-p
if(!(j>=0&&j<q))return A.a(a,j)
if(!h.dD(a[j]+a0,l,b,c,d))break
i=a[j]
if(!(k>=0&&k<q))return A.a(a,k)
a[k]=i
if(j<=n){k=j
break}k=j}if(!(k>=0&&k<q))return A.a(a,k)
a[k]=m;++o
if(o>f)break
if(!(o<q))return A.a(a,o)
m=a[o]
l=m+a0
k=o
for(;;){j=k-p
if(!(j>=0&&j<q))return A.a(a,j)
if(!h.dD(a[j]+a0,l,b,c,d))break
i=a[j]
if(!(k>=0&&k<q))return A.a(a,k)
a[k]=i
if(j<=n){k=j
break}k=j}if(!(k>=0&&k<q))return A.a(a,k)
a[k]=m;++o
l=h.Q
l===$&&A.c()
if(l<0)return}}},
dD(a,b,c,d,e){var s,r,q,p,o,n,m,l
if(a===b)return!1
s=c.length
if(!(a>=0&&a<s))return A.a(c,a)
r=c[a]
if(!(b>=0&&b<s))return A.a(c,b)
q=c[b]
if(r!==q)return r>q;++a;++b
if(!(a<s))return A.a(c,a)
r=c[a]
if(!(b<s))return A.a(c,b)
q=c[b]
if(r!==q)return r>q;++a;++b
if(!(a<s))return A.a(c,a)
r=c[a]
if(!(b<s))return A.a(c,b)
q=c[b]
if(r!==q)return r>q;++a;++b
if(!(a<s))return A.a(c,a)
r=c[a]
if(!(b<s))return A.a(c,b)
q=c[b]
if(r!==q)return r>q;++a;++b
if(!(a<s))return A.a(c,a)
r=c[a]
if(!(b<s))return A.a(c,b)
q=c[b]
if(r!==q)return r>q;++a;++b
if(!(a<s))return A.a(c,a)
r=c[a]
if(!(b<s))return A.a(c,b)
q=c[b]
if(r!==q)return r>q;++a;++b
if(!(a<s))return A.a(c,a)
r=c[a]
if(!(b<s))return A.a(c,b)
q=c[b]
if(r!==q)return r>q;++a;++b
if(!(a<s))return A.a(c,a)
r=c[a]
if(!(b<s))return A.a(c,b)
q=c[b]
if(r!==q)return r>q;++a;++b
if(!(a<s))return A.a(c,a)
r=c[a]
if(!(b<s))return A.a(c,b)
q=c[b]
if(r!==q)return r>q;++a;++b
if(!(a<s))return A.a(c,a)
r=c[a]
if(!(b<s))return A.a(c,b)
q=c[b]
if(r!==q)return r>q;++a;++b
if(!(a<s))return A.a(c,a)
r=c[a]
if(!(b<s))return A.a(c,b)
q=c[b]
if(r!==q)return r>q;++a;++b
if(!(a<s))return A.a(c,a)
r=c[a]
if(!(b<s))return A.a(c,b)
q=c[b]
if(r!==q)return r>q;++a;++b
p=e+8
o=d.length
do{if(!(a>=0&&a<s))return A.a(c,a)
r=c[a]
if(!(b>=0&&b<s))return A.a(c,b)
q=c[b]
if(r!==q)return r>q
if(!(a<o))return A.a(d,a)
n=d[a]
if(!(b<o))return A.a(d,b)
m=d[b]
if(n!==m)return n>m;++a;++b
if(!(a<s))return A.a(c,a)
r=c[a]
if(!(b<s))return A.a(c,b)
q=c[b]
if(r!==q)return r>q
if(!(a<o))return A.a(d,a)
n=d[a]
if(!(b<o))return A.a(d,b)
m=d[b]
if(n!==m)return n>m;++a;++b
if(!(a<s))return A.a(c,a)
r=c[a]
if(!(b<s))return A.a(c,b)
q=c[b]
if(r!==q)return r>q
if(!(a<o))return A.a(d,a)
n=d[a]
if(!(b<o))return A.a(d,b)
m=d[b]
if(n!==m)return n>m;++a;++b
if(!(a<s))return A.a(c,a)
r=c[a]
if(!(b<s))return A.a(c,b)
q=c[b]
if(r!==q)return r>q
if(!(a<o))return A.a(d,a)
n=d[a]
if(!(b<o))return A.a(d,b)
m=d[b]
if(n!==m)return n>m;++a;++b
if(!(a<s))return A.a(c,a)
r=c[a]
if(!(b<s))return A.a(c,b)
q=c[b]
if(r!==q)return r>q
if(!(a<o))return A.a(d,a)
n=d[a]
if(!(b<o))return A.a(d,b)
m=d[b]
if(n!==m)return n>m;++a;++b
if(!(a<s))return A.a(c,a)
r=c[a]
if(!(b<s))return A.a(c,b)
q=c[b]
if(r!==q)return r>q
if(!(a<o))return A.a(d,a)
n=d[a]
if(!(b<o))return A.a(d,b)
m=d[b]
if(n!==m)return n>m;++a;++b
if(!(a<s))return A.a(c,a)
r=c[a]
if(!(b<s))return A.a(c,b)
q=c[b]
if(r!==q)return r>q
if(!(a<o))return A.a(d,a)
n=d[a]
if(!(b<o))return A.a(d,b)
m=d[b]
if(n!==m)return n>m;++a;++b
if(!(a<s))return A.a(c,a)
r=c[a]
if(!(b<s))return A.a(c,b)
q=c[b]
if(r!==q)return r>q
if(!(a<o))return A.a(d,a)
n=d[a]
if(!(b<o))return A.a(d,b)
m=d[b]
if(n!==m)return n>m;++a;++b
if(a>=e)a-=e
if(b>=e)b-=e
p-=8
l=this.Q
l===$&&A.c()
this.Q=l-1}while(p>=0)
return!1},
eK(a){var s,r,q=this,p=q.f
p===$&&A.c()
s=a===p
if(!s){r=q.r
r===$&&A.c()
r=r===1}else r=!1
if(r){s=q.x
s===$&&A.c()
q.x=A.qN(p,s)
s=q.CW
s===$&&A.c()
p=q.f
s.$flags&2&&A.b(s)
if(p>>>0!==p||p>=256)return A.a(s,p)
s[p]=1
s=q.ch
s===$&&A.c()
r=q.w
r===$&&A.c()
s.$flags&2&&A.b(s)
if(!(r<s.length))return A.a(s,r)
s[r]=p
q.w=r+1
q.f=a}else{if(s){s=q.r
s===$&&A.c()
s=s===255}else s=!0
if(s){if(p<256)q.eM()
q.f=a
q.r=1}else{p=q.r
p===$&&A.c()
q.r=p+1}}},
eM(){var s,r,q,p,o,n=this,m=0
for(;;){s=n.r
s===$&&A.c()
if(!(m<s))break
s=n.f
s===$&&A.c()
r=n.x
r===$&&A.c()
s=r>>>24&255^s&255
if(!(s<256))return A.a(B.o,s)
n.x=(r<<8^B.o[s])>>>0;++m}r=n.CW
r===$&&A.c()
q=n.f
q===$&&A.c()
r.$flags&2&&A.b(r)
if(!(q<256))return A.a(r,q)
r[q]=1
p=n.ch
o=n.w
switch(s){case 1:p===$&&A.c()
o===$&&A.c()
p.$flags&2&&A.b(p)
if(!(o<p.length))return A.a(p,o)
p[o]=q
n.w=o+1
break
case 2:p===$&&A.c()
o===$&&A.c()
p.$flags&2&&A.b(p)
s=p.length
if(!(o<s))return A.a(p,o)
p[o]=q;++o
n.w=o
if(!(o<s))return A.a(p,o)
p[o]=q
n.w=o+1
break
case 3:p===$&&A.c()
o===$&&A.c()
p.$flags&2&&A.b(p)
s=p.length
if(!(o<s))return A.a(p,o)
p[o]=q;++o
n.w=o
if(!(o<s))return A.a(p,o)
p[o]=q;++o
n.w=o
if(!(o<s))return A.a(p,o)
p[o]=q
n.w=o+1
break
default:s-=4
if(!(s>=0&&s<256))return A.a(r,s)
r[s]=1
p===$&&A.c()
o===$&&A.c()
p.$flags&2&&A.b(p)
r=p.length
if(!(o<r))return A.a(p,o)
p[o]=q;++o
n.w=o
if(!(o<r))return A.a(p,o)
p[o]=q;++o
n.w=o
if(!(o<r))return A.a(p,o)
p[o]=q;++o
n.w=o
if(!(o<r))return A.a(p,o)
p[o]=q;++o
n.w=o
if(!(o<r))return A.a(p,o)
p[o]=s
n.w=o+1
break}}}
A.hX.prototype={
$1(a){var s,r,q,p=this.c,o=p.cx
o===$&&A.c()
s=this.a.a+a
if(!(s>=0&&s<o.length))return A.a(o,s)
r=o[s]
s=this.b
o=s.c
p=p.go
p===$&&A.c()
if(!(r<258))return A.a(p,r)
p=p[r]
q=p.length
if(0>=q)return A.a(p,0)
s.c=o+p[0]
o=s.b
if(1>=q)return A.a(p,1)
s.b=o+p[1]
o=s.a
if(2>=q)return A.a(p,2)
s.a=o+p[2]},
$S:7}
A.hY.prototype={
$1(a){var s,r=this.c,q=r.fy
q===$&&A.c()
s=this.a.a
if(!(s>=0&&s<6))return A.a(q,s)
s=q[s]
r=r.cx
r===$&&A.c()
q=this.b.a+a
if(!(q>=0&&q<r.length))return A.a(r,q)
q=r[q]
if(!(q<s.length))return A.a(s,q)
r=s[q]
s.$flags&2&&A.b(s)
s[q]=r+1},
$S:7}
A.hW.prototype={
$1(a){var s,r,q=this,p=q.c,o=p.cx
o===$&&A.c()
s=q.b.a+a
if(!(s>=0&&s<o.length))return A.a(o,s)
r=o[s]
q.a.a=r
p=p.c
p===$&&A.c()
s=q.d
if(!(r<s.length))return A.a(s,r)
s=s[r]
o=q.e
if(!(r<o.length))return A.a(o,r)
p.a7(s,o[r])},
$S:7}
A.hN.prototype={
$1(a){var s,r,q,p,o,n,m,l=this.a
if(!(a>=0&&a<260))return A.a(l,a)
s=l[a]
r=this.b
if(!(s>=0&&s<516))return A.a(r,s)
q=l.$flags|0
p=a
for(;;){o=r[s]
n=B.a.k(p,1)
if(!(n<260))return A.a(l,n)
m=l[n]
if(!(m>=0&&m<516))return A.a(r,m)
if(!(o<r[m]))break
q&2&&A.b(l)
if(!(p>=0&&p<260))return A.a(l,p)
l[p]=m
p=n}q&2&&A.b(l)
if(!(p>=0&&p<260))return A.a(l,p)
l[p]=s},
$S:7}
A.hL.prototype={
$1(a){var s,r,q,p,o,n,m,l,k=this.b
if(!(a<260))return A.a(k,a)
s=k[a]
for(r=k.$flags|0,q=this.c,p=this.a.a,o=a;;o=n){n=o<<1>>>0
if(n>p)break
if(n<p){m=n+1
if(!(m<260))return A.a(k,m)
m=k[m]
if(!(m>=0&&m<516))return A.a(q,m)
m=q[m]
if(!(n<260))return A.a(k,n)
l=k[n]
if(!(l>=0&&l<516))return A.a(q,l)
l=m<q[l]
m=l}else m=!1
if(m)++n
if(!(s>=0&&s<516))return A.a(q,s)
m=q[s]
if(!(n<260))return A.a(k,n)
l=k[n]
if(!(l>=0&&l<516))return A.a(q,l)
if(m<q[l])break
r&2&&A.b(k)
if(!(o>=0&&o<260))return A.a(k,o)
k[o]=l}r&2&&A.b(k)
if(!(o>=0&&o<260))return A.a(k,o)
k[o]=s},
$S:7}
A.hO.prototype={
$1(a){return(a&4294967040)>>>0},
$S:4}
A.hK.prototype={
$1(a){return a&255},
$S:4}
A.hM.prototype={
$2(a,b){return a>b?a:b},
$S:8}
A.hJ.prototype={
$2(a,b){var s,r=this.a,q=r.$1(a)
r=r.$1(b)
if(typeof q!=="number")return q.R()
if(typeof r!=="number")return A.Z(r)
s=this.c
s=this.b.$2(s.$1(a),s.$1(b))
if(typeof s!=="number")return A.Z(s)
return(q+r|1+s)>>>0},
$S:8}
A.hG.prototype={
$1(a){var s,r=this.a,q=B.a.k(a,5)
if(!(q<65537))return A.a(r,q)
s=(r[q]|1<<(a&31))>>>0
r.$flags&2&&A.b(r)
r[q]=s
return s},
$S:4}
A.hE.prototype={
$1(a){var s,r=this.a,q=a>>>5
if(!(q<65537))return A.a(r,q)
s=(r[q]&~(1<<(a&31)))>>>0
r.$flags&2&&A.b(r)
r[q]=s
return s},
$S:4}
A.hF.prototype={
$1(a){var s=this.a,r=B.a.k(a,5)
if(!(r<65537))return A.a(s,r)
return(s[r]&1<<(a&31))>>>0!==0},
$S:13}
A.hI.prototype={
$1(a){var s=this.a,r=B.a.k(a,5)
if(!(r<65537))return A.a(s,r)
return s[r]},
$S:4}
A.hH.prototype={
$1(a){return(a&31)!==0},
$S:13}
A.hC.prototype={
$2(a,b){var s=this.b,r=this.a,q=r.a
s.$flags&2&&A.b(s)
if(!(q>=0&&q<100))return A.a(s,q)
s[q]=a
s=this.c
s.$flags&2&&A.b(s)
s[q]=b
r.a=q+1},
$S:25}
A.hB.prototype={
$2(a,b){return a<b?a:b},
$S:8}
A.hD.prototype={
$3(a,b,c){var s,r,q,p,o
for(s=this.a,r=s.length,q=s.$flags|0;c>0;){if(!(a>=0&&a<r))return A.a(s,a)
p=s[a]
if(!(b>=0&&b<r))return A.a(s,b)
o=s[b]
q&2&&A.b(s)
s[a]=o
s[b]=p;++a;++b;--c}},
$S:14}
A.hV.prototype={
$1(a){var s,r,q=this.a.ay
q===$&&A.c()
s=a+1<<8>>>0
if(!(s<65537))return A.a(q,s)
s=q[s]
r=a<<8>>>0
if(!(r<65537))return A.a(q,r)
return s-q[r]},
$S:4}
A.hT.prototype={
$3(a,b,c){var s=this,r=s.b,q=s.a,p=q.a
r.$flags&2&&A.b(r)
if(!(p>=0&&p<100))return A.a(r,p)
r[p]=a
r=s.c
r.$flags&2&&A.b(r)
r[p]=b
r=s.d
r.$flags&2&&A.b(r)
r[p]=c
q.a=p+1},
$S:14}
A.hP.prototype={
$3(a,b,c){var s
if(a>b){s=b
b=a
a=s}if(b>c)b=a>c?a:c
return b},
$S:26}
A.hU.prototype={
$3(a,b,c){var s,r,q,p,o
for(s=this.a,r=s.length,q=s.$flags|0;c>0;){if(!(a>=0&&a<r))return A.a(s,a)
p=s[a]
if(!(b>=0&&b<r))return A.a(s,b)
o=s[b]
q&2&&A.b(s)
s[a]=o
s[b]=p;++a;++b;--c}},
$S:14}
A.hQ.prototype={
$2(a,b){return a<b?a:b},
$S:8}
A.hR.prototype={
$1(a){var s=this.a
if(!(a<3))return A.a(s,a)
return s[a]-this.b[a]},
$S:4}
A.hS.prototype={
$2(a,b){var s,r,q=this.a
if(!(a<3))return A.a(q,a)
s=q[a]
if(!(b<3))return A.a(q,b)
r=q[b]
q.$flags&2&&A.b(q)
q[a]=r
q[b]=s
q=this.b
s=q[a]
r=q[b]
q.$flags&2&&A.b(q)
q[a]=r
q[b]=s
q=this.c
s=q[a]
r=q[b]
q.$flags&2&&A.b(q)
q[a]=r
q[b]=s},
$S:25}
A.is.prototype={
ir(){var s,r,q,p=this
for(s=p.r,r=0;r<12;++r){q=new Uint16Array(16)
B.j.F(q,0,16,1024)
B.b.m(s,new A.cM(q))}s=A.bM(12)
p.w!==$&&A.da()
p.w=s
s=A.bM(12)
p.x!==$&&A.da()
p.x=s
for(s=p.y,r=0;r<12;++r){q=new Uint16Array(16)
B.j.F(q,0,16,1024)
B.b.m(s,new A.cM(q))}s=A.bM(12)
p.z!==$&&A.da()
p.z=s
s=A.bM(12)
p.Q!==$&&A.da()
p.Q=s
s=p.a
q=A.bM(514)
p.at!==$&&A.da()
p.at=new A.h3(s,q)
q=A.bM(514)
p.ax!==$&&A.da()
p.ax=new A.h3(s,q)
q=A.bM(396)
p.ay!==$&&A.da()
p.ay=new A.ke(s,q)
p.a0()},
ew(a){var s,r,q,p,o,n=this,m=n.dy
if(m<=a+(a>>>2))return
s=n.b
r=n.c
q=B.a.p(1,s>r?s:r)-1
p=((a+q&~q)>>>0)+((m&q)>>>0)
o=n.dx
B.c.H(o,0,p,o,m-p)
n.dy=p},
cO(a,b,c,d){var s,r,q,p,o,n=this,m=1024
n.b=c==null?n.b:c
s=b==null?n.c:b
n.c=s
r=a==null?n.d:a
n.d=r
n.e=8-r
n.f=B.a.p(1,s)-1
n.db=B.a1
n.cy=n.cx=n.CW=n.ch=0
q=B.a.p(1,s+r)*768
if(n.as.a.length!==q)n.as=A.bM(q)
for(s=n.r,r=s.length,p=0;p<s.length;s.length===r||(0,A.O)(s),++p){o=s[p].a
B.j.F(o,0,o.length,m)}s=n.w
s===$&&A.c()
s=s.a
B.j.F(s,0,s.length,m)
s=n.x
s===$&&A.c()
s=s.a
B.j.F(s,0,s.length,m)
for(s=n.y,r=s.length,p=0;p<s.length;s.length===r||(0,A.O)(s),++p){o=s[p].a
B.j.F(o,0,o.length,m)}s=n.z
s===$&&A.c()
s=s.a
B.j.F(s,0,s.length,m)
s=n.Q
s===$&&A.c()
s=s.a
B.j.F(s,0,s.length,m)
s=n.as.a
B.j.F(s,0,s.length,m)
s=n.at
s===$&&A.c()
s=s.b.a
B.j.F(s,0,s.length,m)
s=n.ax
s===$&&A.c()
s=s.b.a
B.j.F(s,0,s.length,m)
s=n.ay
s===$&&A.c()
s=s.b.a
B.j.F(s,0,s.length,m)
if(d){n.dx=new Uint8Array(0)
n.dy=0}},
a0(){return this.cO(null,null,null,!1)},
eu(a){return this.cO(null,null,null,a)},
dT(a){var s,r,q=this,p=q.dy,o=p+a,n=q.dx,m=n.length
if(o>m){if(m===0)m=o
while(m<o)m*=2
s=q.fr
if(s>0&&m>s&&s>=o)m=s
r=new Uint8Array(m)
if(p>0)B.c.V(r,0,p,n)
q.dx=r}return p},
f5(a){var s,r,q,p,o,n,m=this,l=B.a.q(1,m.b)-1
m.go=a
s=m.a
r=m.r
for(;;){q=m.dy
if(!(q<a&&s.d<=s.e-48))break
p=(q&l)>>>0
o=m.db.a
if(!(o<r.length))return A.a(r,o)
if(s.b5(r[o].a,p)===0)m.f2()
else{o=m.w
o===$&&A.c()
if(s.b5(o.a,m.db.a)===0)m.f4(p)
else m.f6(p)}}for(;n=m.dy,n<a;q=n){if(s.d>s.e){m.dy=q
return}p=(n&l)>>>0
o=m.db.a
if(!(o<r.length))return A.a(r,o)
if(s.b5(r[o].a,p)===0)m.f2()
else{o=m.w
o===$&&A.c()
if(s.b5(o.a,m.db.a)===0)m.f4(p)
else m.f6(p)}}if(s.d>s.e)m.dy=q
if(m.fy)m.dy=m.id},
hB(a,b,c){var s,r,q,p=this
if(b>2097152){p.iX(a,b,c)
return}s=p.a
s.eD(a.B())
s.hM()
r=p.fy=!1
q=p.dy
p.dT(b)
p.f5(q+b)
c.aq(p.dx,q,p.dy)
if(s.d>s.e?!p.fy:r)throw A.d(A.p("LZMA data is truncated or corrupt"))},
iX(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=e.a
d.eD(A.oa(a,65536))
d.hM()
e.fy=!1
s=e.dy
r=s+b
q=s
for(;;){if(!(q<r&&!e.fy))break
if(d.e-d.d<65536&&!a.gP()){q=A.oa(a,65536)
p=d.e
o=d.d
n=p-o
p=n+q.length
m=p+64
l=d.c
if(l.length<m)k=new Uint8Array(m)
else k=l
B.c.H(k,0,n,l,o)
B.c.V(k,n,p,q)
B.c.F(k,p,m,0)
d.c=k
d.d=0
d.e=p}q=e.dy
j=r-q
i=j<2048?j:2048
h=q+i
g=r-h
e.dT(i+(g<272?g:272))
e.f5(h)
if(d.d>d.e||e.dy>r)break
q=e.dy
if(q-s>=65536){c.aq(e.dx,s,q)
f=e.dy
q=e.fx
if(q>0)e.ew(q)
s=e.dy
r-=f-s
q=s}}if(d.d<=d.e&&!e.fy&&e.dy!==r)throw A.d(A.p("LZMA output exceeds the declared size"))
c.aq(e.dx,s,e.dy)
if(d.d>d.e&&!e.fy)throw A.d(A.p("LZMA data is truncated or corrupt"))},
f2(){var s,r,q,p,o,n,m,l=this,k=l.dy
if(k>0){s=l.dx
r=k-1
if(!(r<s.length))return A.a(s,r)
q=s[r]}else q=0
p=(B.a.b3(q,l.e)+B.a.p((k&l.f)>>>0,l.d))*768
o=l.as.a
if(l.db.a<7)n=l.a.l9(o,p)
else{m=k-l.ch-1
if(m<0)throw A.d(A.p("LZMA match byte refers outside the dictionary"))
k=l.dx
if(!(m<k.length))return A.a(k,m)
n=l.a.le(o,p,k[m])}k=l.dx
s=l.dy
k.$flags&2&&A.b(k)
if(!(s>=0&&s<k.length))return A.a(k,s)
k[s]=n
l.dy=s+1
s=l.db.a
if(!(s<12))return A.a(B.ag,s)
s=B.ag[s]
if(!(s<12))return A.a(B.ak,s)
l.db=B.ak[s]},
f4(a){var s,r,q,p=this,o=p.at
o===$&&A.c()
s=o.a.hy(o.b.a,a)
o=p.ay
o===$&&A.c()
r=s-2
if(r>3)r=3
q=o.a.lc(o.b.a,r)
if(q===4294967295){p.fy=!0
p.id=p.dy
p.dy=p.go
return}p.dS(q,s)
p.cy=p.cx
p.cx=p.CW
p.CW=p.ch
p.ch=q
p.db=p.db.a<7?B.az:B.ay},
f6(a){var s,r,q,p=this,o=p.a,n=p.x
n===$&&A.c()
if(o.b5(n.a,p.db.a)===0){n=p.y
s=p.db.a
if(!(s<n.length))return A.a(n,s)
s=o.b5(n[s].a,a)
r=p.ch
if(s===0){p.dS(r,1)
p.db=p.db.a<7?B.aB:B.a2
return}}else{n=p.z
n===$&&A.c()
if(o.b5(n.a,p.db.a)===0){r=p.CW
p.CW=p.ch
p.ch=r}else{n=p.Q
n===$&&A.c()
n=o.b5(n.a,p.db.a)
r=p.cx
if(n===0){p.cx=p.CW
p.CW=p.ch
p.ch=r}else{q=p.cy
p.cy=r
p.cx=p.CW
p.CW=p.ch
p.ch=q
r=q}}}o=p.ax
o===$&&A.c()
p.dS(r,o.a.hy(o.b.a,a))
p.db=p.db.a<7?B.aA:B.a2},
dS(a,b){var s,r,q,p,o,n,m,l=this,k=l.dy,j=k-a-1,i=!0
if(j>=0)if(k+b<=l.dx.length){i=l.fx
i=i>0&&a>=i}if(i)throw A.d(A.p("LZMA match refers outside the dictionary"))
if(a===0){i=l.dx
if(!(j>=0&&j<i.length))return A.a(i,j)
B.c.F(i,k,k+b,i[j])
l.dy+=b}else if(a>=b){s=k+b
if(b<=16){for(i=l.dx,r=i.length,q=i.$flags|0,p=j;k<s;k=o,p=n){o=k+1
n=p+1
if(!(p>=0&&p<r))return A.a(i,p)
m=i[p]
q&2&&A.b(i)
if(!(k>=0&&k<r))return A.a(i,k)
i[k]=m}l.dy=s}else{i=l.dx
B.c.H(i,k,s,i,j)
l.dy+=b}}else{s=k+b
for(i=l.dx,r=i.length,q=i.$flags|0,p=j;k<s;k=o,p=n){o=k+1
n=p+1
if(!(p>=0&&p<r))return A.a(i,p)
m=i[p]
q&2&&A.b(i)
if(!(k>=0&&k<r))return A.a(i,k)
i[k]=m}l.dy=s}},
sll(a){this.fx=A.H(a)}}
A.aw.prototype={
bp(){return"_LzmaState."+this.b}}
A.h3.prototype={}
A.ke.prototype={}
A.cM.prototype={}
A.iE.prototype={
eD(a){var s=this,r=a.length,q=r+64,p=s.c
if(p.length<q)p=s.c=new Uint8Array(q)
B.c.V(p,0,r,a)
B.c.F(p,r,q,0)
s.d=0
s.e=r},
hM(){var s,r,q,p,o,n=this
n.b=0
n.a=4294967295
s=++n.d
for(r=s,q=0,s=0;q<4;++q,s=r,r=o){p=n.c
o=r+1
n.d=o
if(!(r<p.length))return A.a(p,r)
r=(s<<8|p[r])>>>0
n.b=r}},
b5(a,b){var s,r,q,p,o,n=this,m=n.a
if(m<16777216){m=n.a=m<<8>>>0
s=n.b
r=n.c
q=n.d++
if(!(q<r.length))return A.a(r,q)
n.b=(s<<8|r[q])>>>0}if(!(b<a.length))return A.a(a,b)
p=a[b]
o=B.a.k(m,11)*p
s=n.b
if(s<o){n.a=o
m=B.a.k(2048-p,5)
a.$flags&2&&A.b(a)
a[b]=p+m
return 0}n.a=m-o
n.b=s-o
a.$flags&2&&A.b(a)
a[b]=p-(p>>>5)
return 1},
l9(a,b){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.c,g=i.d,f=i.a,e=i.b
for(s=a.$flags|0,r=a.length,q=h.length,p=1,o=0;o<8;++o){if(f<16777216){f=f<<8>>>0
n=g+1
if(!(g<q))return A.a(h,g)
e=(e<<8|h[g])>>>0
g=n}m=b+p
if(!(m>=0&&m<r))return A.a(a,m)
l=a[m]
k=B.a.k(f,11)*l
p=p<<1>>>0
if(e<k){j=B.a.k(2048-l,5)
s&2&&A.b(a)
a[m]=l+j
f=k}else{f-=k
e-=k
s&2&&A.b(a)
a[m]=l-(l>>>5)
p=(p|1)>>>0}}i.a=f
i.b=e
i.d=g
return p&255},
le(a,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=f.c,d=f.d,c=f.a,b=f.b
for(s=a.$flags|0,r=a0+256,q=a.length,p=e.length,o=1,n=7;n>=0;){if(c<16777216){c=c<<8>>>0
m=d+1
if(!(d<p))return A.a(e,d)
b=(b<<8|e[d])>>>0
d=m}l=B.a.b3(a1,n)&1
k=r+(l<<8)+o
if(!(k>=0&&k<q))return A.a(a,k)
j=a[k]
i=B.a.k(c,11)*j
if(b<i){h=B.a.k(2048-j,5)
s&2&&A.b(a)
a[k]=j+h
c=i
g=0}else{c-=i
b-=i
s&2&&A.b(a)
a[k]=j-(j>>>5)
g=1}o=(o<<1|g)>>>0;--n
if(g!==l)break}while(n>=0){if(c<16777216){c=c<<8>>>0
m=d+1
if(!(d<p))return A.a(e,d)
b=(b<<8|e[d])>>>0
d=m}k=a0+o
if(!(k>=0&&k<q))return A.a(a,k)
j=a[k]
i=B.a.k(c,11)*j
o=o<<1>>>0
if(b<i){r=B.a.k(2048-j,5)
s&2&&A.b(a)
a[k]=j+r
c=i}else{c-=i
b-=i
s&2&&A.b(a)
a[k]=j-(j>>>5)
o=(o|1)>>>0}--n}f.a=c
f.b=b
f.d=d
return o&255},
hy(a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=e.c,c=e.d,b=e.a,a=e.b
if(b<16777216){b=b<<8>>>0
s=c+1
if(!(c<d.length))return A.a(d,c)
a=(a<<8|d[c])>>>0
c=s}r=a0.length
if(0>=r)return A.a(a0,0)
q=a0[0]
p=B.a.k(b,11)*q
o=a0.$flags|0
if(a<p){n=B.a.k(2048-q,5)
o&2&&A.b(a0)
a0[0]=q+n
b=p
m=0}else{b-=p
a-=p
o&2&&A.b(a0)
a0[0]=q-(q>>>5)
m=1}l=3
if(m===0){k=2+(a1<<3>>>0)
j=2}else{if(b<16777216){b=b<<8>>>0
s=c+1
if(!(c<d.length))return A.a(d,c)
a=(a<<8|d[c])>>>0
c=s}if(1>=r)return A.a(a0,1)
q=a0[1]
p=B.a.k(b,11)*q
if(a<p){n=B.a.k(2048-q,5)
o&2&&A.b(a0)
a0[1]=q+n
b=p
m=0}else{b-=p
a-=p
o&2&&A.b(a0)
a0[1]=q-(q>>>5)
m=1}if(m===0){k=130+(a1<<3>>>0)
j=10}else{k=258
l=8
j=18}}for(n=d.length,i=1,h=0;h<l;++h){if(b<16777216){b=b<<8>>>0
s=c+1
if(!(c<n))return A.a(d,c)
a=(a<<8|d[c])>>>0
c=s}g=k+i
if(!(g>=0&&g<r))return A.a(a0,g)
q=a0[g]
p=B.a.k(b,11)*q
i=i<<1>>>0
if(a<p){f=B.a.k(2048-q,5)
o&2&&A.b(a0)
a0[g]=q+f
b=p}else{b-=p
a-=p
o&2&&A.b(a0)
a0[g]=q-(q>>>5)
i=(i|1)>>>0}}e.a=b
e.b=a
e.d=c
return j+i-B.a.q(1,l)},
lc(a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=c.c,a=c.d,a0=c.a,a1=c.b,a2=a4<<6>>>0
for(s=a3.$flags|0,r=a3.length,q=b.length,p=1,o=0;o<6;++o){if(a0<16777216){a0=a0<<8>>>0
n=a+1
if(!(a<q))return A.a(b,a)
a1=(a1<<8|b[a])>>>0
a=n}m=a2+p
if(!(m>=0&&m<r))return A.a(a3,m)
l=a3[m]
k=B.a.k(a0,11)*l
p=p<<1>>>0
if(a1<k){j=B.a.k(2048-l,5)
s&2&&A.b(a3)
a3[m]=l+j
a0=k}else{a0-=k
a1-=k
s&2&&A.b(a3)
a3[m]=l-(l>>>5)
p=(p|1)>>>0}}i=p-64
if(i<4){c.a=a0
c.b=a1
c.d=a
return i}h=B.a.k(i,1)-1
if(i<14){g=256+B.c0[i-4]
f=h
e=0}else{for(o=h-4,e=0;o>0;--o){if(a0<16777216){a0=a0<<8>>>0
n=a+1
if(!(a<q))return A.a(b,a)
a1=(a1<<8|b[a])>>>0
a=n}a0=B.a.k(a0,1)
e=e<<1>>>0
if(!(a1<a0)){a1-=a0;++e}}e=e<<4
g=380
f=4}for(p=1,o=0;o<f;++o){if(a0<16777216){a0=a0<<8>>>0
n=a+1
if(!(a<q))return A.a(b,a)
a1=(a1<<8|b[a])>>>0
a=n}m=g+p
if(!(m>=0&&m<r))return A.a(a3,m)
l=a3[m]
k=B.a.k(a0,11)*l
if(a1<k){j=B.a.k(2048-l,5)
s&2&&A.b(a3)
a3[m]=l+j
a0=k
d=0}else{a0-=k
a1-=k
s&2&&A.b(a3)
a3[m]=l-(l>>>5)
d=1}p=(p<<1|d)>>>0
e|=B.a.q(d,o)}c.a=a0
c.b=a1
c.d=a
return(B.a.p(i&1|2,h)|e)>>>0}}
A.e5.prototype={
gb4(){var s=this.z
if(s===$)s=this.z=new A.bQ(this.a,new Uint8Array(65536),B.d)
return s},
gfn(){switch(2){case 2:break}return 4},
bH(){while(this.e-this.d>=65536)this.hc(65536)},
bf(){var s=this,r=s.e-s.d
if(r>0)s.hc(r)
s.hg()
if(s.as){s.gb4().j(0);++s.ax
s.kL()}s.kP()
s.gb4().aT()},
hc(a){var s,r,q,p=this
p.hg()
p.kM()
s=p.b
r=p.d
q=A.Q(s,r,r+a)
p.jl(q)
r=p.gb4()
r.j(p.ay===0?1:2)
s=a-1
r.j(B.a.k(s,8)&255)
r.j(s&255)
r.v(q)
p.ax=p.ax+(a+3)
p.ay+=a
p.a5(0,a)},
jl(a){switch(2){case 2:this.CW.a.ex(t.L.a(a))
break}},
hg(){var s,r,q,p=this
if(p.Q)return
p.Q=!0
s=p.gb4()
r=t.t
s.v(A.i([253,55,122,88,90,0],r))
q=new Uint8Array(A.N(A.i([0,p.gfn()],r)))
s.v(q)
s.L(A.I(q,0))},
kM(){var s,r,q,p,o,n=this
if(n.as)return
n.as=!0
s=A.a8(32768)
s.j(33)
s.j(1)
s.j(A.pN(8388608))
r=6+s.b
while(B.a.E(r,4)!==0)++r
q=A.a8(32768)
q.j(B.a.t(r,4)-1)
q.j(0)
q.v(s.Z())
for(p=r-4;q.b<p;)q.j(0)
o=q.Z()
n.at=r
p=n.gb4()
p.v(o)
p.L(A.I(o,0))},
kL(){var s,r=this
for(s=0;B.a.E(r.at+r.ax+s,4)!==0;){r.gb4().j(0);++s}switch(2){case 2:r.gb4().v(r.CW.gbv())
break}B.b.m(r.cy,new A.h5(r.at+r.ax+8,r.ay))},
kP(){var s,r,q,p,o,n,m,l=A.a8(32768)
l.j(0)
s=this.cy
l.v(A.ne(s.length))
for(r=s.length,q=0;q<s.length;s.length===r||(0,A.O)(s),++q){p=s[q]
l.v(A.ne(p.a))
l.v(A.ne(p.b))}while(B.a.E(l.b,4)!==0)l.j(0)
o=l.Z()
s=this.gb4()
s.v(o)
s.L(A.I(o,0))
n=A.a8(32768)
n.L(B.a.t(o.length+4,4)-1)
n.j(0)
n.j(this.gfn())
m=n.Z()
s.L(A.I(m,0))
s.v(m)
s.v(A.i([89,90],t.t))}}
A.h5.prototype={}
A.iW.prototype={
l4(a,b){var s
this.r=null
s=a.a
a.a=B.d
try{for(;;){if(!this.kU(a,b))return!1
if(!this.kA(a))return!1
if(a.gP())return!0}}finally{a.sbu(s)}},
kU(a,b){var s,r,q,p=this
p.f=a.gA()
p.c=0
B.b.bw(p.e)
s=p.b
s.fx=s.fr=0
s.eu(!0)
if(!p.kk(a,b))return!1
while(!a.gP()){r=a.a6(1,a.gA()).G()
if(r===0){q=p.kl(a)
if(q<0)return!1
return p.kj(a,q)}if(!p.lV(a,b,(r+1)*4))return!1}if(p.r==null)p.r="Stream ended without a footer"
return!1},
kA(a){var s,r
for(s=0;!a.gP();){if(a.a6(1,a.gA()).G()!==0)break
a.a5(0,1);++s}r=B.a.E(s,4)===0
if(!r)if(this.r==null)this.r="Stream padding is not a multiple of four bytes"
return r},
kk(a,b){var s,r,q,p,o,n=this,m="Invalid stream flags"
if(a.gi(a)<12){if(n.r==null)n.r="Truncated stream header"
return!1}s=a.K(6).B()
r=s.length
if(0>=r)return A.a(s,0)
q=!1
if(s[0]===253){if(1>=r)return A.a(s,1)
if(s[1]===55){if(2>=r)return A.a(s,2)
if(s[2]===122){if(3>=r)return A.a(s,3)
if(s[3]===88){if(4>=r)return A.a(s,4)
if(s[4]===90){if(5>=r)return A.a(s,5)
r=s[5]===0}else r=q}else r=q}else r=q
q=r}}if(!q){if(n.r==null)n.r="Invalid XZ stream header signature"
return!1}p=a.K(2)
if(p.G()!==0){if(n.r==null)n.r=m
return!1}r=p.G()
n.c=r
if((r&240)!==0){if(n.r==null)n.r=m
return!1}p.a0()
o=a.J()
if(A.I(p.B(),0)!==o){if(n.r==null)n.r="Invalid stream header CRC checksum"
return!1}return!0},
lV(b0,b1,b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8=this,a9=b0.gA()
if(!a8.lW(b0,b2))return!1
f=a8.z
e=a8.Q
s=a8.as
r=a8.at
q=a8.ax
d=b0.gA()
p=b1.gi(b1)
c=a8.c&15
o=null
b=b1 instanceof A.bg
a=!b
if(a)if(o==null)a0=r&&!0
else a0=!0
else a0=!1
if(a0){a1=o
n=a1==null?b1:a1
if(r){b=n
a=q
a2=new A.eX(b,new A.hZ(a,a-5),new Uint8Array(0),b.a)}else a2=null
m=a2
try{b=m
if(b==null)b=n
if(!a8.dN(b0,b,s))return!1
b=m
if(b!=null){a=b.b
a0=b.d
a.aq(a0,0,a0.length)
b.d=new Uint8Array(0)}}finally{b=o
if(b!=null)b.T()}}else if(r&&a){l=A.a8(e!=null&&e<=a8.w?e:null)
k=null
try{k=a8.dN(b0,l,s)}catch(a3){j=l.Z()
if(r){b=q
g=A.kY(j,b,0,b-5).a}else g=J.B(j)
i=g
b1.v(A.Q(j,0,i))
throw a3}a4=l.Z()
i=a4.length
if(r){b=q
i=A.kY(a4,b,0,b-5).a}if(!k){b1.v(A.Q(a4,0,i))
return!1}b1.v(a4)}else{h=!1
try{h=a8.dN(b0,b1,s)
if(!h)return!1}finally{if(r){a=q
g=A.kY(b1.aQ(p),a,0,a-5).a
if(!h&&b){b=p
a=g
if(typeof b!=="number")return b.R()
if(typeof a!=="number")return A.Z(a)
b1.b=b+a}}}}b=b0.gA()
a=b1.gi(b1)
a0=p
if(typeof a0!=="number")return A.Z(a0)
a5=a-a0
if(f!=null&&f!==b-d){if(a8.r==null)a8.r="Compressed data doesn't match the length in the block header"
return!1}if(e==null)e=a5
if(e!==a5){if(a8.r==null)a8.r="Uncompressed data doesn't match the length in the block header"
return!1}a6=a8.dP(b0,a8.f)
if(a6<0){if(a8.r==null)a8.r="Invalid block padding"
return!1}if(b0.gi(b0)<A.w_(c)){if(a8.r==null)a8.r="Block check is truncated"
return!1}switch(c){case 0:break
case 1:if(o!=null)b0.eo(4).B()
b0.J()
break
case 2:case 3:b0.a5(0,4)
break
case 4:a7=b0.K(8).B()
if(o!=null)if(!o.hv(a7)){if(a8.r==null)a8.r="CRC64 check failed"
return!1}break
case 5:case 6:b0.a5(0,8)
break
case 7:case 8:case 9:b0.a5(0,16)
break
case 10:a7=b0.K(32).B()
if(o!=null)if(!o.hv(a7)){if(a8.r==null)a8.r="SHA-256 check failed"
return!1}break
case 11:case 12:b0.a5(0,32)
break
case 13:case 14:case 15:b0.a5(0,64)
break}B.b.m(a8.e,new A.hg(b0.gA()-a9-a6,e))
return!0},
lW(a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=this,a4="Invalid filter in block header",a5="Invalid LZMA dictionary size"
if(a6.gi(a6)<a7){if(a3.r==null)a3.r="Truncated block header"
return!1}s=a6.K(a7-4)
s.a5(0,1)
r=s.G()
if((r&60)!==0){if(a3.r==null)a3.r="Reserved bit is set in the block flags"
return!1}q=(r&3)+1
if((r&64)!==0){p=a3.b9(s)
if(p<0){if(a3.r==null)a3.r="Invalid compressed length in block header"
return!1}}else p=null
if((r&128)!==0){o=a3.b9(s)
if(o<0){if(a3.r==null)a3.r="Invalid uncompressed length in block header"
return!1}}else o=null
n=A.i([],t.t)
for(m=a3.ay,l=0,k=0;k<q;++k){j=a3.b9(s)
i=a3.b9(s)
if(j<0||i<0){if(a3.r==null)a3.r=a4
return!1}h=s.K(i).B()
g=h.length
if(g!==i){if(a3.r==null)a3.r=a4
return!1}if(j===3){if(i!==1){if(a3.r==null)a3.r="Invalid delta filter distance"
return!1}if(0>=g)return A.a(h,0)
f=h[0]
B.b.m(n,j)
B.b.m(n,f)}else if(j===4){if(i!==0&&i!==4){if(a3.r==null)a3.r="Invalid x86 filter start offset"
return!1}if(i===4){if(0>=g)return A.a(h,0)
e=h[0]
if(1>=g)return A.a(h,1)
d=h[1]
if(2>=g)return A.a(h,2)
c=h[2]
if(3>=g)return A.a(h,3)
b=(e|d<<8|c<<16|h[3]<<24)>>>0}else b=0
B.b.m(n,j)
B.b.m(n,b)}else if(j===33){if(i!==1){if(a3.r==null)a3.r=a5
return!1}if(0>=g)return A.a(h,0)
a=h[0]
if(a>40){if(a3.r==null)a3.r=a5
return!1}else l=a===40?4294967295:B.a.q(a&1|2,(a>>>1)+11)
if(l>m){if(a3.r==null)a3.r="LZMA dictionary size "+l+" exceeds maxDictionarySize "+m
return!1}B.b.m(n,j)
B.b.m(n,l)}else{B.b.m(n,j)
B.b.m(n,0)}}m=a3.b
m.fx=l
if(l>0&&l<1073741824)m.fr=l+(l>>>2)+2097152+16
if(a3.ki(s)<0){if(a3.r==null)a3.r="Invalid block header padding"
return!1}s.a0()
a0=a6.J()
if(A.I(s.B(),0)!==a0){if(a3.r==null)a3.r="Invalid block header CRC checksum"
return!1}m=n.length
a1=!1
if(m===4){if(0>=m)return A.a(n,0)
if(n[0]===4){if(2>=m)return A.a(n,2)
g=n[2]===33
a1=g}}if(!a1)m=m!==2||B.b.gc3(n)!==33
else m=!1
if(m){if(a3.r==null)a3.r="Unsupported filter chain; only LZMA2, optionally behind the x86 BCJ filter, is supported"
return!1}if(a1){if(1>=n.length)return A.a(n,1)
a2=n[1]}else a2=0
a3.z=p
a3.Q=o
a3.as=l
a3.at=a1
a3.ax=a2
return!0},
dN(a,b,c){var s,r=this
r.y=r.x=!0
while(!a.gP()){s=r.lX(a,b,c)
if(s!=null)return s}if(r.r==null)r.r="LZMA2 data ended without an end marker"
return!1},
lX(a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a="Truncated LZMA2 chunk",a0=null
if(a1.gP()){if(b.r==null)b.r=a
return!1}s=a1.G()
r=s===0
if(!r){q=s<128?s===1:(s>>>5&3)===3
if(b.x&&!q){if(b.r==null)b.r="The first LZMA2 chunk does not reset the dictionary"
return!1}b.x=!1
if(q)b.y=!0}if(s>=192)p=6
else if(s>=128)p=5
else{o=s>0?2:0
p=o}if(a1.gi(a1)<p){if(b.r==null)b.r=a
return!1}if((s&128)===0)if(r){b.b.eu(!0)
return!0}else{r=s===1
if(r||s===2){if(r)b.b.eu(!0)
n=((a1.G()<<8|a1.G())>>>0)+1
m=a1.gi(a1)<n?a1.gi(a1):n
r=b.b
o=a1.K(m)
if(m<0)A.j(A.p("Invalid LZMA2 uncompressed chunk size"))
l=o.K(m).B()
o=l.length
if(o!==m)A.j(A.p("Truncated LZMA2 uncompressed chunk"))
k=r.dT(m)
B.c.ab(r.dx,k,l)
r.dy+=o
a2.v(l)
r.ew(a3)
if(m<n){if(b.r==null)b.r=a
return!1}}else{if(b.r==null)b.r="Unknown LZMA2 control code "+s
return!1}}else{j=s>>>5&3
if(j<2&&b.y){if(b.r==null)b.r="LZMA2 chunk does not set new properties after a dictionary reset"
return!1}r=a1.G()
o=a1.G()
i=a1.G()
h=a1.G()
if(j>=2){g=a1.G()
if(g>224){if(b.r==null)b.r="Invalid LZMA properties byte"
return!1}f=g/45|0
g-=f*45
e=B.a.t(g,9)
d=g-e*9
if(d+e>4){if(b.r==null)b.r="Invalid LZMA literal context and position bits"
return!1}b.y=!1}else{f=a0
e=f
d=e}if(j>0)b.b.cO(d,e,f,j===3)
if(a1.eo(1).G()!==0){if(b.r==null)b.r="LZMA2 range coder does not start with 0"
return!1}c=b.b
c.hB(a1.K(((i<<8|h)>>>0)+1),(((s&31)<<16|r<<8|o)>>>0)+1,a2)
if(c.fy||c.a.b!==0){if(b.r==null)b.r="LZMA data is corrupt"
return!1}c.ew(a3)}return a0},
kl(a){var s,r,q,p,o,n,m,l,k,j=this,i=a.gA()
a.a5(0,1)
s=j.b9(a)
r=j.e
if(s!==r.length){if(j.r==null)j.r="Stream index block count mismatch"
return-1}for(q=0;q<s;++q){p=j.b9(a)
o=j.b9(a)
if(!(q<r.length))return A.a(r,q)
n=r[q]
if(n.a!==p){if(j.r==null)j.r="Stream index compressed length mismatch"
return-1}if(n.b!==o){if(j.r==null)j.r="Stream index uncompressed length mismatch"
return-1}}if(j.dP(a,j.f)<0){if(j.r==null)j.r="Invalid stream index padding"
return-1}m=a.gA()-i
a.cQ(m)
l=a.K(m)
if(a.gi(a)<4){if(j.r==null)j.r="Truncated stream index"
return-1}k=a.J()
if(A.I(l.B(),0)!==k){if(j.r==null)j.r="Invalid stream index CRC checksum"
return-1}return m+4},
kj(a,b){var s,r,q,p,o=this
if(a.gi(a)<12){if(o.r==null)o.r="Truncated stream footer"
return!1}s=a.J()
r=a.K(6)
if((r.J()+1)*4!==b){if(o.r==null)o.r="Stream footer has invalid index size"
return!1}if(r.G()!==0){if(o.r==null)o.r="Invalid stream footer flags"
return!1}if(r.G()!==o.c){if(o.r==null)o.r="Stream footer flags don't match the header flags"
return!1}r.a0()
if(A.I(r.B(),0)!==s){if(o.r==null)o.r="Invalid stream footer CRC checksum"
return!1}q=a.K(2).B()
p=q.length
if(0>=p)return A.a(q,0)
if(q[0]===89){if(1>=p)return A.a(q,1)
p=q[1]!==90}else p=!0
if(p){if(o.r==null)o.r="Invalid XZ stream footer signature"
return!1}return!0},
b9(a){var s,r,q,p
for(s=0,r=1,q=0;q<9;++q){if(a.gP())return-1
p=a.G()
s+=(p&127)*r
if((p&128)===0){if(p===0&&q>0)return-1
return s}r*=128}return-1},
dP(a,b){var s
for(s=0;B.a.E(a.gA()-b,4)!==0;){if(a.gP()||a.G()!==0)return-1;++s}return s},
ki(a){return this.dP(a,0)}}
A.hg.prototype={}
A.iZ.prototype={
gi(a){return this.r+this.f},
j(a){var s,r=this,q=r.e,p=q.length
if(r.f===p)r.T()
s=r.f++
q.$flags&2&&A.b(q)
if(!(s<p))return A.a(q,s)
q[s]=a},
ah(a,b){var s,r,q=this
t.L.a(a)
b=a.length
if(b<=0)return
s=q.e
r=s.length
if(b>=r){q.T()
s=A.Q(a,0,b)
q.hh(s)
return}if(q.f+b>r)q.T()
r=q.f
B.c.V(s,r,r+b,a)
q.f+=b},
v(a){return this.ah(a,null)},
T(){var s=this,r=s.f
if(r===0)return
s.hh(A.Q(s.e,0,r))
s.f=0},
hh(a){var s,r=this,q=a.length
if(q===0)return
s=r.d
if(s===1)r.w=A.I(a,r.w)
else if(s===4)r.y.a.ex(t.L.a(a))
else if(s===10)r.x.ag(a,0,q)
r.b.$2(r.c+r.r,a)
r.r+=q},
hv(a){var s,r,q,p,o=this,n=o.d
if(n===10){n=a.length
if(n!==32)return!1
s=o.x.hE()
for(r=0;r<32;++r){q=s[r]
if(!(r<n))return A.a(a,r)
if(q!==a[r])return!1}return!0}if(n!==1&&n!==4)return!0
if(n===4)return a.length===8&&o.y.lI(a,0)
n=a.length
if(n===0)return!1
for(r=n-1,p=0;r>=0;--r)p=(p<<8|a[r])>>>0
return p===o.w},
ai(a,b){return A.j(A.ao("An xz worker sink cannot be read back"))},
aQ(a){return this.ai(a,null)}}
A.iT.prototype={
ea(a,b,c){var s=this.iZ(a,b,!1,!0,null)
return s},
iZ(a,b,c,d,e){return A.eO(b,e,new A.iV(this,a,!1,d))},
j_(a,b,c,d){return A.d8("XZ",!1,d,new A.iU(new A.iW(!1,A.o9(),A.i([],t.ey),this.a,this.b),a,b,!1))}}
A.iV.prototype={
$1(a){var s=this
return s.a.j_(s.b,a,s.c,s.d)},
$S:5}
A.iU.prototype={
$0(){var s,r,q=this
try{if(q.a.l4(q.b,q.c))return!0}catch(r){s=A.G(r)
A.pD(s)
if(!A.hn(s))throw r
throw A.d(A.p("Invalid XZ archive: "+A.r(s)))}throw A.d(A.rD(q.a.r,q.d))},
$S:3}
A.iS.prototype={
bp(){return"XZCheck."+this.b}}
A.fH.prototype={
c0(a,b){var s=B.ct,r=b.a
b.a=B.d
try{this.j9(a,b,s)}finally{b.sbu(r)}},
j9(a,b,c){var s,r,q,p,o,n,m,l,k,j=0
switch(c.a){case 0:break
case 1:j=1
break
case 2:j=4
break
case 3:j=10
break}s=t.t
b.v(A.i([253,55,122,88,90,0],s))
r=A.a8(64)
r.j(0)
r.j(j)
q=r.Z()
b.v(q)
b.L(A.I(q,0))
p=A.i([],t.c5)
o=a.gi(a)
if(o>0)B.b.m(p,new A.eF(this.kK(b,a,j),o))
n=b.gi(b)
this.kS(b,p)
m=b.gi(b)
l=A.a8(16)
l.L(B.a.t(m-n,4)-1)
l.j(0)
l.j(j)
k=l.Z()
b.L(A.I(k,0))
b.v(k)
b.v(A.i([89,90],s))
b.T()},
kK(a7,a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this,a5=a8.gi(a8),a6=a5
if(typeof a6!=="number")return a6.R()
B.w.t(a6+65536-1,65536)
a6=a5
if(typeof a6!=="number")return a6.R()
j=A.a8(24)
i=A.i([],t.g1)
h=A.a8(16)
a4.bY(h,33)
a4.bY(h,1)
h.j(A.pN(8388608))
B.b.m(i,h)
g=6+j.b
for(a6=i.length,f=0;f<a6;++f)g+=i[f].b
while(B.a.E(g,4)!==0)++g
e=A.a8(64)
e.j(B.a.t(g,4)-1)
e.j((a6-1|0)>>>0)
e.v(j.Z())
for(a6=i.length,f=0;f<i.length;i.length===a6||(0,A.O)(i),++f)e.v(i[f].Z())
a4.he(e)
d=e.Z()
c=a7.gi(a7)
a7.v(d)
a7.L(A.I(d,0))
s=0
r=new A.f4(new A.f5())
q=A.ol()
p=a8.gA()
o=null
try{n=0
a6=a9&15
b=t.L
for(;;){a=n
a0=a5
if(typeof a!=="number")return a.ar()
if(typeof a0!=="number")return A.Z(a0)
if(!(a<a0))break
a=a5
a0=n
if(typeof a!=="number")return a.bI()
if(typeof a0!=="number")return A.Z(a0)
if(a-a0<65536){a=a5
a0=n
if(typeof a!=="number")return a.bI()
if(typeof a0!=="number")return A.Z(a0)
a1=a-a0}else a1=65536
m=a1
l=a8.c5(m)
if(l==null){if(o==null)o=new Uint8Array(65536)
k=a8.az(o,0,m)
a=k
if(typeof a!=="number")return a.bD()
if(a<=0)break
l=A.Q(o,0,k)}switch(a6){case 1:s=A.I(l,s)
break
case 4:a=b.a(l)
r.a.ex(a)
break
case 10:q.ag(l,0,l.length)
break}a4.kQ(a7,l,J.T(n,0))
a=n
if(typeof a!=="number")return a.R()
n=a+65536}}finally{a8.S(p)}a7.j(0)
a2=a4.hf(a7,c)
a3=a9&15
switch(a3){case 0:break
case 1:a7.L(s)
break
case 4:a7.v(r.gbv())
break
case 10:a7.v(q.hE())
break
default:throw A.d("Unknown check type "+a3)}return a7.gi(a7)-c-a2},
kQ(a,b,c){var s,r,q,p=b.length,o=c,n=0
do{s=p-n
s=s<65536?s:65536
a.j(o?1:2)
r=s-1
a.j(B.a.k(r,8)&255)
a.j(r&255)
q=n+s
a.v(A.Q(b,n,q))
if(q<p){n=q
o=!1
continue}else break}while(!0)},
kS(a,b){var s,r,q,p,o,n=this
t.fz.a(b)
s=A.a8(64)
s.j(0)
n.bY(s,b.length)
for(r=b.length,q=0;q<b.length;b.length===r||(0,A.O)(b),++q){p=b[q]
n.bY(s,p.a)
n.bY(s,p.b)}n.he(s)
o=s.Z()
a.v(o)
a.L(A.I(o,0))},
bY(a,b){var s
for(s=b;s>=128;){a.j(s&127|128)
s=B.a.k(s,7)}a.j(s)},
hf(a,b){var s
for(s=0;B.a.E(a.gi(a)-b,4)!==0;){a.j(0);++s}return s},
he(a){return this.hf(a,0)}}
A.eF.prototype={}
A.j8.prototype={
hL(a,b,c,d){var s=!0
return new A.bx(this.lB(a,b,c,d),t.as)},
lB(a,b,c,d){var s=this
return function(){var r=a,q=b,p=c,o=d
var n=0,m=1,l=[],k=[],j,i,h,g,f,e
return function $async$hL(a0,a1,a2){if(a1===1){l.push(a2)
n=m}for(;;)switch(n){case 0:f=!0
e=r.c
m=2
i=s.ft(r,p,o,f,q),h=i.$ti,i=new A.cp(i.a(),h.h("cp<1>")),h=h.c
case 5:if(!i.u()){n=6
break}g=i.b
j=g==null?h.a(g):g
r.c=A.H(e)
n=7
return a0.b=j,1
case 7:n=5
break
case 6:k.push(4)
n=3
break
case 2:k=[1]
case 3:m=1
r.c=A.H(e)
n=k.pop()
break
case 4:return 0
case 1:return a0.c=l.at(-1),3}}}},
ft(a,b,c,d,e){return new A.bx(this.jw(a,b,c,!0,e),t.as)},
jw(a,b,c,d,e){var s=this
return function(){var r=a,q=b,p=c,o=d,n=e
var m=0,l=2,k=[],j,i,h,g,f,a0,a1,a2,a3,a4,a5
return function $async$ft(a6,a7,a8){if(a7===1){k.push(a8)
m=l}for(;;)switch(m){case 0:a5=s.a=s.jj(r)
if(a5<0){m=1
break}r.c=a5
if(r.J()!==101010256){m=1
break}r.O()
r.O()
r.O()
s.e=r.O()
s.f=r.J()
s.r=r.J()
j=r.O()
if(p&&j>r.gi(0))throw A.d(A.p("zip: archive comment is truncated"))
if(j>0)r.hZ(j,!1)
s.km(r)
i=s.fM(r)
a5=s.r
if(i>a5&&!s.bW(r,a5,33639248)){h=i-s.r
s.r=i}else h=0
a5=s.r
g=!0
if(a5>=0){f=s.f
a0=s.a
if(a5<=a0)g=p&&f>a0-a5}if(g){if(p)throw A.d(A.p("zip: central directory is damaged"))
m=1
break}g=s.f
a1=r.aR(Math.min(g,1024),g,a5)
a2=p?r.a6(s.r,0):r
a3=0
case 3:a5=a1.c
g=a1.d
g===$&&A.c()
if(!(a5<g)){m=4
break}g=a1.b
if(((g==null?0:g.length-a5)>=46?a1.J():0)!==33639248){if(p&&s.fM(r)<0)throw A.d(A.p("zip: central directory is damaged"))
m=4
break}a4=new A.e8()
a4.lU(a1,a2,n,q,h,p);++a3
m=5
return a6.b=a4,1
case 5:m=3
break
case 4:if(p&&B.a.E(a3,65536)!==B.a.E(s.e,65536))throw A.d(A.p("zip: central directory entry count does not match"))
case 1:return 0
case 2:return a6.c=k.at(-1),3}}}},
fM(a){var s,r=this,q=r.a,p=q-20
if(p>=0){a.c=p
if(a.J()===117853008)q=p-56}s=q-r.f
if(s<0||s===r.r)return-1
return r.bW(a,s,33639248)?s:-1},
bW(a,b,c){if(b<0)return!1
a.c=b
return a.gi(0)>=4&&a.J()===c},
km(a){var s,r,q,p,o,n,m=this,l=101075792,k=a.c,j=m.a-20
if(j<0)return
s=a.a6(20,j)
if(s.J()!==117853008){a.c=k
return}s.J()
r=s.aA()
s.J()
q=j-56
if(r<q&&!m.bW(a,r,l)&&m.bW(a,q,l))r=q
if(!m.bW(a,r,l))throw A.d(A.p("Invalid zip64 end of central directory offset"))
if(a.gi(0)<52){a.c=k
return}a.c=r
if(a.J()!==101075792){a.c=k
return}a.aA()
a.O()
a.O()
a.J()
a.J()
a.aA()
p=a.aA()
o=a.aA()
n=a.aA()
m.e=p
m.f=o
m.r=n
a.c=k},
jj(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=a.b,e=(f==null?0:f.length)-22
f=e
if(typeof f!=="number")return f.ar()
if(f<0)return-1
s=a.c
try{f=e
if(typeof f!=="number")return f.bI()
r=f-65535
f=e
if(typeof f!=="number")return f.R()
q=f+4
p=1024
o=-1
for(;;){f=q
i=p
if(typeof f!=="number")return f.bI()
if(typeof i!=="number")return A.Z(i)
n=Math.max(0,f-i)
a.c=A.H(n)
i=q
f=n
if(typeof i!=="number")return i.bI()
if(typeof f!=="number")return A.Z(f)
h=a.a6(i-f,a.gA())
a.S(a.gA()+h.gi(0))
m=h.B()
l=J.B(m)-4
for(;;){f=l
if(typeof f!=="number")return f.cW()
if(!(f>=0))break
A:{f=!0
if(J.bi(m,l)===80){i=l
if(typeof i!=="number")return i.R()
if(J.bi(m,i+1)===75){i=l
if(typeof i!=="number")return i.R()
if(J.bi(m,i+2)===5){f=l
if(typeof f!=="number")return f.R()
f=J.bi(m,f+3)!==6}}}if(f)break A
f=n
i=l
if(typeof f!=="number")return f.R()
if(typeof i!=="number")return A.Z(i)
k=f+i
f=o
if(typeof f!=="number")return f.ar()
o=f<0?k:o
i=k
if(typeof i!=="number")return i.R()
a.c=i+20
j=a.O()
f=k
if(typeof f!=="number")return f.R()
i=j
if(typeof i!=="number")return A.Z(i)
g=a.b
g=g==null?0:g.length
if(f+22+i===g)return k}f=l
if(typeof f!=="number")return f.bI()
l=f-1}f=n
i=r
if(typeof f!=="number")return f.bD()
if(typeof i!=="number")return A.Z(i)
if(f<=i){f=o
if(typeof f!=="number")return f.cW()
if(f>=0){f=o
return f}f=p
if(typeof f!=="number")return f.b7()
p=Math.min(f*2,65536)}if(J.T(n,0))break
f=n
if(typeof f!=="number")return f.R()
q=f+4-1}f=o
return f}finally{a.c=A.H(s)}}}
A.j5.prototype={}
A.e7.prototype={
bp(){return"ZipEncryptionMode."+this.b}}
A.bT.prototype={
gej(){return this.ax!=null&&this.c!==B.l},
ghK(){var s=this.CW
return(s==null?null:s.a)!==2},
lT(a7,a8,a9,b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=this,a4=null,a5="zip: local header of ",a6="zip: data descriptor of "
if((a7.c>=0&&a7.gi(0)>=30?a7.J():0)!==67324752){if(b0){s=a3.z.at
throw A.d(A.p(a5+s+" is damaged"))}r=a3.z
a3.x=r.at
a3.f=r.r
a3.r=r.w
a3.w=r.x
a3.d=r.e
a3.e=r.f
return}a7.O()
a3.b=a7.O()
q=a7.O()
s=B.Y.l(0,q)
a3.c=s==null?B.l:s
a3.d=a7.O()
a3.e=a7.O()
a3.f=a7.J()
a3.r=a7.J()
a3.w=a7.J()
p=a7.O()
o=a7.O()
if(b0&&p+o>a7.gi(0)){s=a3.z.at
throw A.d(A.p(a5+s+" is damaged"))}r=a3.z
a7.a5(0,p)
a3.x=r.at
a3.y=a7.K(o).B()
s=r.w
a3.r=s
n=r.x
a3.w=n
if(b0)n=s>a7.gi(0)
else n=!1
if(n)throw A.d(A.p("zip: content of "+a3.x+" is truncated"))
a3.ch=(a3.b&1)!==0?B.a_:B.A
a3.cx=a9
a3.ax=a7.K(s)
if(a3.ch!==B.A&&o>2){s=a3.y
s.toString
m=A.U(s,B.d,a4,a4)
for(;;){s=m.b
if(!((s==null?0:s.length-m.c)>=4))break
l=m.O()
k=m.O()
s=m.b
if(k>(s==null?0:s.length-m.c))break
j=m.a6(k,m.gA())
m.S(m.gA()+j.gi(0))
if(l===39169&&k>=7){i=j.O()
j.er(2)
h=j.G()
g=j.O()
a3.ch=B.a0
a3.CW=new A.j5(i,h,g)
s=B.Y.l(0,g)
a3.c=s==null?B.l:s}}}s=a3.CW
f=s==null?a4:s.d
if(f==null)f=q
a3.at=B.Y.a3(f)?a4:f
if(b0&&(a3.b&8)!==0&&a7.gi(0)<12){s=r.at
throw A.d(A.p(a6+s+" is damaged"))}if((a3.b&8)!==0&&a7.gi(0)>=12){e=a7.J()
d=A.rJ(a3.y)
c=e===134695760
if(c){s=r.r
s=s===e}else s=!1
if(s){b=a7.eo(d?16:8)
s=b.gi(b)
if(s===(d?16:8)){a=d?b.aA():b.J()
a0=d?b.aA():b.J()
if(a===a3.r&&a0===a3.w)c=!1}}s=d?16:8
n=c?4:0
if(b0&&a7.gi(0)<s+n){s=r.at
throw A.d(A.p(a6+s+" is damaged"))}if(c)a3.f=a7.J()
else a3.f=e
a1=d?a7.aA():a7.J()
a2=d?a7.aA():a7.J()
s=r.w
if(s===0)a3.r=a1
s=r.x
if(s===0)a3.w=a2}},
hD(a){A.d8("zip",this.Q,this.as,new A.jm(this,a))},
jI(a){var s,r
t.gg.a(a)
try{s=a.$0()
return s}catch(r){if(this.db)throw A.d(A.nJ("macs don't match"))
throw r}},
f9(){var s,r,q,p=this
if(p.ch!==B.A){r=p.ax
if(r.gi(r)<=0)p.ch=B.A
else{s=p.ax.gA()
try{r=p.ch
if(r===B.a_){r=p.ax
r.toString
p.ax=p.j1(r)}else if(r===B.a0){r=p.ax
r.toString
p.ax=p.iV(r)}}catch(q){p.ax.S(s)
throw q}p.ch=B.A}}},
f8(a){var s=this,r=s.ax,q=s.ch,p=r==null?null:s.j3()
if(p!=null){s.ax=p
s.ch=B.A}s.db=!1
try{s.j2(a)}finally{if(p!=null){s.ax=r
s.ch=q}}if(s.db)throw A.d(A.nJ("macs don't match"))},
j3(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0=this,b1=null,b2=b0.ax
b2.toString
s=b2
if(b0.ch===B.A||J.B(s)<=0)return b1
r=s.gA()
try{b2=b0.ch
if(b2===B.a_){if(J.B(s)<12)return b1
q=(b0.b&8)!==0?b0.d>>>8&255:b0.f>>>24
p=A.i([],t.a)
for(b2=b0.cl(),a4=b2.length,a5=0;a5<b2.length;b2.length===a4||(0,A.O)(b2),++a5){o=b2[a5]
if(o!=null&&b0.cu(o,r)===q)J.hr(p,o)}n=p
if(J.B(n)!==1)return b1
b0.cu(J.qz(n),r)
m=J.B(s)
l=s.a6(m,s.gA())
p=A.nX(new A.eg(l,new A.je(b0),new A.jf(),new Uint8Array(16384))).a6(m,0)
return p}if(b2!==B.a0)return b1
k=b0.CW.c
if(J.T(k,1))a6=16
else a6=J.T(k,2)?24:32
j=a6
p=j
if(typeof p!=="number")return p.a2()
i=B.w.t(p,2)
p=J.B(s)
b2=i
if(typeof b2!=="number")return A.Z(b2)
h=p-b2-2-10
p=h
if(typeof p!=="number")return p.ar()
if(p<0)return b1
g=s.K(i).B()
f=s.K(2).B()
e=s.gA()
d=null
c=0
for(p=b0.cl(),b2=p.length,a5=0;a5<p.length;p.length===b2||(0,A.O)(p),++a5){b=p[a5]
if(b==null)continue
a=A.pG(b,g,1000,j*2+2)
a4=a
a7=j
if(typeof a7!=="number")return a7.b7()
a7*=2
a8=j
if(typeof a8!=="number")return a8.b7()
a0=new Uint8Array(a4.subarray(a7,A.d3(a7,a8*2+2,J.B(a4))))
if(A.iR(a0,f)){a4=c
if(typeof a4!=="number")return a4.R()
c=a4+1
a4=a
a4=new Uint8Array(A.N(new Uint8Array(a4.subarray(0,A.d3(0,A.oU(j),J.B(a4))))))
a7=a
a8=j
if(typeof a8!=="number")return a8.b7()
a9=A.H(j)
d=A.nH(a4,new Uint8Array(A.N(new Uint8Array(a7.subarray(a9,A.d3(a9,a8*2,J.B(a7)))))),j,!1)}}if(!J.T(c,1))return b1
p=d
p.toString
a1=p
p=e
b2=h
if(typeof p!=="number")return p.R()
if(typeof b2!=="number")return A.Z(b2)
a2=s.a6(10,p+b2)
a3=s.a6(h,e)
p=A.nX(new A.eg(a3,new A.jg(a1),new A.jh(b0,a1,a2),new Uint8Array(16384))).a6(h,0)
return p}finally{s.S(r)}},
j2(a){var s,r,q,p,o=this
if(o.ax==null)return
o.eV()
o.f9()
s=o.c
if(s===B.u){r=o.ax.gA()
s=o.ax
s.toString
new A.e6().lg(s,a,!0,!0)
o.ax.S(r)}else if(s===B.H){r=o.ax.gA()
s=A.nK()
q=o.ax
q.toString
p=s.lf(q,a)
o.ax.S(r)
if(!p)throw A.d(A.p("Invalid bzip2 data for "+o.x))}else if(s===B.D)o.f3(a)
else if(s===B.z||s===B.E)o.f7(a)
else{r=o.ax.gA()
s=o.ax
s.toString
a.b6(s)
o.ax.S(r)}},
f7(a){var s,r,q=this.ax
q.toString
s=q
r=s.gA()
try{if(this.c===B.z)new A.jv(134217728,null).ea(s,a,!0)
else new A.iT(268435456,268435456).ea(s,a,!0)}finally{s.S(r)}},
f3(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=f.ax
e.toString
s=e
r=s.gA()
try{J.m9(s,2)
q=s.O()
p=s.K(q).B()
if(J.B(p)<5||J.bi(p,0)>=225){e=A.p("Invalid LZMA properties for "+f.x)
throw A.d(e)}o=J.bi(p,0)
n=(J.bi(p,1)|J.bi(p,2)<<8|J.bi(p,3)<<16|J.bi(p,4)<<24)>>>0
k=A.o9()
e=n
if(typeof e!=="number")return e.ar()
k.sll(e<4096?4096:n)
j=o
if(typeof j!=="number")return j.E()
j=B.w.E(j,9)
i=o
if(typeof i!=="number")return i.a2()
i=B.a.E(B.w.t(i,9),5)
h=o
if(typeof h!=="number")return h.a2()
k.cO(j,i,B.w.t(h,45),!0)
m=k
m.hB(s,f.w,a)}catch(g){e=A.G(g)
if(e instanceof A.aP)throw g
else{l=e
if(!A.hn(l))throw g
e=A.p("Invalid LZMA data for "+f.x+": "+A.r(l))
throw A.d(e)}}finally{s.S(r)}},
gi(a){var s=this.ax
s=s==null?null:s.gi(s)
return s==null?0:s},
am(a){var s={}
s.a=A.U(new Uint8Array(0),B.d,null,null)
A.d8("zip",this.Q,this.as,new A.jn(s,this,a))
return s.a},
c7(){return this.am(!0)},
jr(a){var s,r,q,p,o,n,m,l,k,j=this,i=null
if(j.ax==null)return A.U(new Uint8Array(0),B.d,i,i)
j.f9()
if(!a){s=j.ax
s.toString
return s}j.eV()
s=j.c
if(s===B.u){r=j.ax.gA()
q=A.mH()
s=j.ax
s=s.gi(s)
p=j.ax
if(s<=524288e3){o=p.B()
s=j.w
q.b=A.ji(new A.e6().la(o,s,!0,!0))}else{a=A.a8(A.w0(j.w,p.gi(p)))
s=j.ax
s.toString
p=j.w
new A.e6().li(s,a,p,!0,!0)
q.b=a.Z()}j.ax.S(r)
return A.U(q.dO(),B.d,i,i)}else if(s===B.H){n=j.dY()
r=j.ax.gA()
s=A.nK()
p=j.ax
p.toString
m=j.w
l=s.hz(p,n,m)
q=A.ji(n.Z())
j.ax.S(r)
if(!l)throw A.d(A.p("Invalid bzip2 data for "+j.x))
return A.U(q,B.d,i,i)}else if(s===B.D){n=j.dY()
j.f3(n)
return A.U(A.ji(n.Z()),B.d,i,i)}else if(s===B.z||s===B.E){n=j.dY()
s=j.w
A.eO(n,s,new A.jj(j))
return A.U(A.ji(n.Z()),B.d,i,i)}else{k=j.w
if(j.as){s=j.ax
s=s.gi(s)>k
s=s}else s=!1
if(s)throw A.d(A.p("The decoded data is larger than the "+k+" bytes allowed"))
s=j.ax
return s.d1(s.gA())}},
dY(){var s=this.w
return A.a8(s>0&&s<32768?s:null)},
n(a){return this.x},
cl(){var s=A.i([null],t.ff)
return s},
jB(a){var s,r=this.cy
B.b.D(r,0,305419896)
B.b.D(r,1,591751049)
B.b.D(r,2,878082192)
for(r=a.length,s=0;s<r;++s)this.ct(a[s])},
ct(a){var s,r=this.cy
B.b.D(r,0,A.pA(r[0],a))
s=r[1]+(r[0]&255)>>>0
B.b.D(r,1,s*33797+((s*2056&65535)<<16>>>0)+1>>>0)
B.b.D(r,2,A.pA(r[2],r[1]>>>24))},
dj(){var s=this.cy[2]&65535|2
return s*(s^1)>>>8&255},
j1(a){var s,r,q,p,o,n,m,l,k=this,j=null,i=k.ax
if(i==null)return A.U(new Uint8Array(0),B.d,j,j)
s=i.gA()
r=(k.b&8)!==0?k.d>>>8&255:k.f>>>24
i=t.a
q=A.i([],i)
for(p=k.cl(),o=p.length,n=0;n<p.length;p.length===o||(0,A.O)(p),++n){m=p[n]
if(m!=null)q.push(m)}i=A.i([],i)
for(p=q.length,n=0;n<q.length;q.length===p||(0,A.O)(q),++n){m=q[n]
if(k.cu(m,s)===r)i.push(m)}p=i.length
if(p>1){for(n=0;o=i.length,n<o;i.length===p||(0,A.O)(i),++n){l=k.e3(i[n],s)
if(k.fL(l)===k.f){i=new A.a6(B.d)
i.bn(l,B.d,j,j)
return i}}p=o}if(p===0){for(i=q.length,n=0;n<q.length;q.length===i||(0,A.O)(q),++n){l=k.e3(q[n],s)
if(k.fL(l)===k.f){i=new A.a6(B.d)
i.bn(l,B.d,j,j)
return i}}throw A.d(A.qL("zip: wrong or missing password for "+k.x))}return A.U(k.e3(B.b.gc3(i),s),B.d,j,j)},
cu(a,b){var s,r,q,p=this
p.ax.S(b)
p.jB(a)
for(s=0,r=0;r<12;++r,s=q){q=p.ax.G()^p.dj()
p.ct(q)}return s},
e3(a,b){var s,r,q,p,o=this
o.cu(a,b)
s=o.ax
r=s instanceof A.a6?new Uint8Array(A.N(s.B())):s.B()
for(s=r.length,q=0;q<s;++q){p=r[q]^o.dj()
o.ct(p)
r.$flags&2&&A.b(r)
r[q]=p}return r},
fL(a){var s,r,q=this,p=q.ax,o=q.ch
q.ax=A.U(a,B.d,null,null)
q.ch=B.A
try{s=A.I(q.c7().B(),0)
return s}catch(r){return null}finally{q.ax=p
q.ch=o}},
iV(a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=null,a1=a3.gA(),a2=this.CW.c
if(a2===1){s=a3.K(8).B()
r=16}else if(a2===2){s=a3.K(12).B()
r=24}else{s=a3.K(16).B()
r=32}q=a3.K(2).B()
if(a3.gi(a3)<10){a3.S(a1)
throw A.d(A.p("zip: content of "+this.x+" is truncated"))}p=a3.K(a3.gi(a3)-10)
o=a3.K(10)
n=new A.dg("password error",a0,a0)
for(a2=this.cl(),m=a2.length,l=p instanceof A.a6,k=r*2,j=k+2,i=0;i<a2.length;a2.length===m||(0,A.O)(a2),++i){h=a2[i]
if(h==null)continue
g=A.pG(h,s,1000,j)
f=g.length
e=new Uint8Array(A.N(new Uint8Array(g.subarray(0,A.d3(0,r,f)))))
d=new Uint8Array(A.N(new Uint8Array(g.subarray(r,A.d3(r,k,f)))))
if(!A.iR(new Uint8Array(g.subarray(k,A.d3(k,j,f))),q))continue
c=l?new Uint8Array(A.N(p.B())):p.B()
b=A.nH(e,d,r,!1)
b.lR(c,0,c.length)
f=o.B()
a=b.f
a===$&&A.c()
if(!A.iR(f,a)){n=new A.df("macs don't match",a0,a0)
continue}a2=new A.a6(B.d)
a2.bn(c,B.d,a0,a0)
return a2}a3.S(a1)
throw A.d(n)},
eU(a){var s,r=this
if(r.ghK())if(a===r.f)s=a!==r.z.r
else s=!0
else s=!1
if(s)throw A.d(A.qK("zip: CRC32 of "+r.x+" does not match"))},
eV(){if(this.at!=null)throw A.d(A.p("zip: unsupported compression method for "+this.x))},
da(a){if(a!==this.w)throw A.d(A.p("zip: uncompressed size of "+this.x+" does not match"))}}
A.jm.prototype={
$0(){var s=this.a
return s.jI(new A.jl(s,this.b))},
$S:3}
A.jl.prototype={
$0(){var s=this.a,r=s.w
return A.eO(this.b,r,new A.jk(s))},
$S:3}
A.jk.prototype={
$1(a){var s,r,q,p=this.a
if(!p.Q){s=a.gi(a)
p.f8(a)
if(p.as)p.da(a.gi(a)-s)
return!0}r=new A.fU(a)
q=new A.bQ(r,new Uint8Array(65536),B.d)
p.f8(q)
q.aT()
p.da(q.c)
p.eU(r.b)
return!0},
$S:5}
A.je.prototype={
$1(a){var s,r,q=0,p=a.length,o=this.a
for(;;){r=q
if(typeof r!=="number")return r.ar()
if(!(r<p))break
s=B.c.l(a,q)^o.dj()
o.ct(s)
B.c.D(a,q,s)
r=q
if(typeof r!=="number")return r.R()
q=r+1}},
$S:23}
A.jf.prototype={
$0(){},
$S:0}
A.jg.prototype={
$1(a){return this.a.hY(a,0,a.length)},
$S:23}
A.jh.prototype={
$0(){var s,r=this.b
r.hJ()
s=this.c.B()
r=r.f
r===$&&A.c()
this.a.db=!A.iR(s,r)},
$S:0}
A.jn.prototype={
$0(){var s=this.b,r=this.c,q=s.jr(r),p=this.a
p.a=q
if((s.Q||s.as)&&r)s.da(q.gi(q))
if(s.Q&&r){r=p.a
if(!(r instanceof A.a6)&&r.gi(r)<=1048576)p.a=A.U(p.a.B(),B.d,null,null)
s.eU(A.rI(p.a))}return!0},
$S:3}
A.jj.prototype={
$1(a){this.a.f7(a)
return!0},
$S:5}
A.eg.prototype={
lb(a){var s,r,q,p,o=this
if(o.e)return!1
s=o.a
r=o.d
q=s.az(r,0,16384)
if(q>0){p=A.Q(r,0,q)
o.b.$1(p)
a.v(p)}if(q<=0||s.gP()){o.e=!0
o.c.$0()
return!1}return!0},
$iqT:1}
A.fU.prototype={
m(a,b){t.L.a(b)
this.b=A.I(b,this.b)
this.a.v(b)},
$iS:1}
A.e8.prototype={
lU(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k,j=this,i={}
j.a=a.O()
a.O()
j.c=a.O()
a.O()
j.e=a.O()
j.f=a.O()
j.r=a.J()
j.w=a.J()
j.x=a.J()
s=a.O()
r=a.O()
q=a.O()
j.y=a.O()
a.O()
j.Q=a.J()
j.as=a.J()
if(f&&s+r+q>a.gi(0))throw A.d(A.p("zip: central directory header is damaged"))
p=a.K(s).B()
j.at=A.w1(p,j.c,c)
i.a=null
if(r>0){o=a.K(r).B()
j.ax=o
if(r>=4){n=A.U(o,B.d,null,null)
for(;;){o=n.b
if(!((o==null?0:o.length-n.c)>=4))break
m=n.O()
l=n.O()
k=n.a6(l,n.gA())
n.S(n.gA()+k.gi(0))
if(m===1){if(l>=8&&j.x===4294967295){j.x=k.aA()
l-=8}if(l>=8&&j.w===4294967295){j.w=k.aA()
l-=8}if(l>=8&&j.as===4294967295){j.as=k.aA()
l-=8}if(l>=4&&j.y===65535)j.y=k.J()}else if(m===28789)i.a=A.w2(p,k)}}}if(q>0)a.er(q)
if(e!==0)o=j.fF(b,j.as,p)>j.fF(b,j.as+e,p)
else o=!1
if(o){if(f)throw A.d(A.p("zip: central directory is damaged"))
e=0}j.as+=e
j.CW=new A.jd(i,j,b,d,f,c)
o=i.a
if(o!=null)j.at=o},
fF(a,b,c){var s,r,q,p,o,n
if(b<0)return 0
a.c=b
if(a.gi(0)<30||a.J()!==67324752)return 0
a.a5(0,22)
s=a.O()
r=c.length
if(s!==r||a.gi(0)<2+s)return 1
a.a5(0,2)
q=a.K(s).B()
for(p=q.length,o=0;o<s;++o){if(!(o<p))return A.a(q,o)
n=q[o]
if(!(o<r))return A.a(c,o)
if(n!==c[o])return 1}return 2},
n(a){return this.at}}
A.jd.prototype={
$0(){var s,r=this,q=r.c,p=q.c,o=r.b
q.c=o.as
try{s=new A.bT(B.l,o,B.A,A.i([0,0,0],t.t))
s.lT(q,r.f,r.d,r.e)
o.ch=s}finally{q.c=A.H(p)}q=r.a.a
if(q!=null)o.ch.x=q},
$S:0}
A.j6.prototype={
lh(a,b,c,d,e){var s=!0,r=new A.dd(A.i([],t.V),A.c7(t.N,t.S)),q=a.a
a.a=B.d
try{A.d8("zip",!0,s,new A.j7(this,a,r,!0,s,c,b))}finally{a.sbu(q)}return r},
kV(a,b,a0,a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=null,d=A.i([],t.fT),c=new A.j8(d)
this.a=c
B.b.af(d,c.hL(a,e,a2,!0))
d=this.a
c=d.a
if(c<0)throw A.d(A.p("zip: end of central directory not found"))
for(d=d.x,c=d.length,r=0;r<d.length;d.length===c||(0,A.O)(d),++r){q=d[r]
p=q.CW
if(p!=null){p.$0()
q.CW=null}o=q.ch
n=q.Q
o.as=o.Q=!0
m=n>>>16
l=o.x
k=!0
if(!B.e.c1(l,"/"))if(!B.e.c1(l,"\\")){j=q.a>>>8
if(!(j===0&&(n&16)!==0))j=j===3&&(m&61440)===16384
else j=k
k=j}s=k?new A.bc(l,493,B.a.t(Date.now(),1000),0,!1):A.nI(l,o.w,o)
s.Q=o.c
b.m(0,s)
if(m!==0)s.b=m
if(q.a>>>8===3)if((s.b&61440)===40960){i=A.nI(l,o.w,o)
i.Q=o.c
if(i.ax==null)i.hC()
l=i.ax
if(l==null)h=e
else{l=l.a
if(l==null)l=new Uint8Array(0)
h=new A.a6(B.d)
h.bn(l,B.d,e,e)}g=h==null?e:h.B()
if(g!=null){l=new A.a6(B.d)
l.bn(g,B.d,e,e)
s.w=l.er(g.length)}}l=s
j=o.CW
l.y=(j==null?e:j.a)!==2?o.f:e
j=o.z.ax
j=A.ps(j)
if(j==null)j=A.ps(o.y)
if(j==null){j=o.e
f=o.d
f=B.a.t(A.mc((j>>>9&127)+1980,j>>>5&15,j&31,f>>>11&31,f>>>5&63,f<<1&62).a,1000)
j=f}l.f=j}}}
A.j7.prototype={
$0(){var s=this
s.a.kV(s.b,s.c,s.d,s.e,s.f,s.r)
return!0},
$S:3}
A.fT.prototype={
m(a,b){return this.a=A.I(t.L.a(b),this.a)},
$iS:1}
A.eG.prototype={
slF(a){this.z=A.H(a)},
sl3(a){this.at=t.ew.a(a)}}
A.kP.prototype={}
A.j9.prototype={
ls(a,b,c,d,e,f){var s,r,q,p,o=this,n=null,m=new A.kP(e,A.i([],t.aY))
m.b=A.p9(n)
m.c=A.p7(n)
m.d=null
o.a=m
o.b=b
o.c=b.a
b.a=B.d
try{for(m=a.a,r=A.F(m),m=new J.at(m,m.length,r.h("at<1>")),q=t.bv,r=r.c;m.u();){p=m.d
s=p==null?r.a(p):p
p=o.kX(q.a(s),!1,d,n)
if(p!=null)p.bf()}m=o.a
r=o.b
r.toString
o.kN(m.e,n,r)
o.fS()}finally{o.fS()}},
lq(a,b,c,d,e,f){var s,r,q,p,o,n
for(s=a.a,r=A.F(s),s=new J.at(s,s.length,r.h("at<1>")),r=r.c,q=22,p=0;s.u();){o=s.d
if(o==null)o=r.a(o)
q+=128+3*o.a.length
n=o.at
if(o.Q===B.l&&n instanceof A.bH){o=n.a
o=o==null?null:o.length
p+=o==null?0:o}}f=p>0?A.a8(q+p):A.a8(32768)
this.ls(a,f,!1,c,d,e)
return f.Z()},
iL(a,b){var s
if(a instanceof A.bH)return!0
s=!1
if(b===B.l)s=a instanceof A.bT
return s},
eB(a){var s,r,q,p,o,n,m,l,k,j=a.at
if(j==null)return 0
if(j.gej()){s=new A.fT()
r=new A.bQ(s,new Uint8Array(65536),B.d)
j.hD(r)
r.aT()
return s.a}q=j.am(!1)
q.a0()
if(!(q instanceof A.a6)){p=Math.min(q.gi(q),1048576)
o=new Uint8Array(p)
for(n=0;;){m=q.az(o,0,p)
if(m<=0)break
n=A.I(A.Q(o,0,m),n)}q.a0()
return n}l=q.gi(0)
for(n=0;l>1048576;){k=q.a6(1048576,q.gA())
q.S(q.gA()+k.gi(0))
n=A.I(k.B(),n)
l-=1048576}if(l>0)n=A.I(q.K(l).B(),n)
q.c=0
return n},
kX(c2,c3,c4,c5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9=this,c0=null,c1=new A.eG(B.u)
b9.x=b9.w=null
f=new A.aF(A.md(c2.ghO()*1000,0),0,!1)
e=c2.a
d=c1.a=A.bB(e,"\\","/")
c=c2.ch
b=!c
if(b&&!B.e.c1(d,"/"))d=c1.a=d+"/"
if(d.length>16383&&B.t.a4(d).length>65535)throw A.d(A.p("zip: name is longer than 65535 bytes"))
d=b9.a
d===$&&A.c()
d=d.b
d===$&&A.c()
if(d==null){d=A.p9(f)
d.toString}c1.b=d
d=b9.a.c
d===$&&A.c()
if(d==null){d=A.p7(f)
d.toString}c1.c=d
b9.a.d===$&&A.c()
d=c2.ghO()
c1.d=d
c1.dx=c2.b
c1.dy=c
a=c2.Q
s=a==null?B.u:a
if(b)s=B.l
d=c2.w
b=d==null
a0=b?c0:d.length!==0
if(a0===!0){a1=B.t.a4(b?"":d)
s=B.l
a2=A.U(a1,B.d,c0,c0)
a3=A.I(a1,0)
a4=a1.length
c1.dx=c2.b&4095|40960
c1.fr=!0}else{a2=c0
if(c){d=c2.at
d=d instanceof A.bT&&d.at!=null}else d=!1
if(d){a5=t.dS.a(c2.at)
if(!a5.ghK()){e=A.p("zip: CRC32 of "+e+" is unknown without AES")
throw A.d(e)}s=B.l
a2=a5.am(!1)
a3=a5.f
c1.ax=a5.at
c1.CW=a5.b&6}else if(c){e=c2.at
if(e!=null&&e.gej()){e=c2.Q
d=c2.at
if(e===B.l)a2=d==null?c0:d.am(!0)
else{a2=d==null?c0:d.am(!1)
e=c2.at
if(e instanceof A.bT){s=e.c
c1.ch=(e.b&2)!==0}}a3=c2.y
a3=a3!=null?a3:b9.eB(c2)}else{if(s===B.D)s=B.u
e=!1
if(s===B.E)if(c2.ay===0){e=c2.at
e=e==null?c0:e.gi(e)
e=(e==null?0:e)===0}if(e)s=B.l
a6=c2.at
e=a6!=null
a7=e&&!b9.iL(a6,s)
a8=a7&&s===B.u
a9=!1
if(s===B.z||s===B.E||s===B.H)if(e)a9=a7
b0=a7&&s===B.l
a3=!a8&&!a9&&!b0?b9.eB(c2):0
b1=b9.a.a
r=b1
b2=s===B.z
b3=b2?-131072:-1
b4=b2?22:9
e=r
if(typeof e!=="number")return e.ar()
if(!(e<b3)){e=r
if(typeof e!=="number")return e.eC()
e=e>b4}else e=!0
if(e)throw A.d(A.aZ(r,"level","Must be "+b3+" to "+b4))
e=c2.at
if(e==null){s=B.l
a2=A.U(new Uint8Array(0),B.d,c0,c0)}else if(a9){c1.z=b1===0?3:b1
e=e.am(!1)
c1.x=e
if(e!==null)e.a0()
b5=c2.ay
c1.as=b5+(b5>>>6)+4096>4294967295}else if(a8){c1.slF(r)
e=c2.at
e=e==null?c0:e.am(!1)
c1.x=e
if(e!=null)e.a0()
b5=c2.ay
c1.as=b5+(b5>>>12)+(b5>>>14)+(b5>>>25)+13>4294967295}else if(b0){e=e.am(!1)
c1.x=e
if(e!==null)e.a0()
c1.as=c2.ay+4096>4294967295}else if(s===B.u){q=e.am(!1)
p=A.mA(J.B(q))
o=q.gA()
try{B.a8.hH(q,p,r,!0)}finally{q.S(o)}a2=A.U(p.Z(),B.d,c0,c0)}else if(s===B.H){n=A.ma()
m=e.am(!1)
l=A.mA(J.B(m))
k=m.gA()
try{n.c0(m,l)}finally{m.S(k)}a2=A.U(l.Z(),B.d,c0,c0)}else if(s===B.z||s===B.E){j=b1
i=e.am(!1)
h=A.mA(J.B(i))
g=i.gA()
try{if(s===B.z){e=J.T(j,0)?c0:j
new A.fJ(3,c0).hG(i,h,e)}else new A.fH().c0(i,h)}finally{i.S(g)}a2=A.U(h.Z(),B.d,c0,c0)}else a2=e.am(!1)}}else a3=0
a4=-1}e=a2==null?c0:a2.gi(a2)
if(e==null)e=0
d=null==null?0:c0
c=b9.w
c=c==null?c0:c.length
if(c==null)c=0
b=b9.x
b=b==null?c0:b.length
if(b==null)b=0
b6=e+d+c+b
b7=c1.x!=null
c1.Q=b7
c1.e=a3
c1.f=b7?0:b6
c1.w=a2
c1.r=c2.ay
if(a4>=0)c1.r=a4
c1.sl3(s)
c1.cx=null
c1.cy=b9.b.b
e=new A.jb(c1,!1,c2)
B.b.m(b9.a.e,c1)
d=b9.b
d.toString
b8=b9.kO(c1,d,e,c0)
if(b8==null)e.$0()
return b8},
fS(){var s,r=this.c
if(r!=null){s=this.b
if(s!=null)s.a=r
this.c=null}},
dg(a){var s=a.ax
if(s==null){s=a.at
if(s===B.u)s=8
else if(s===B.H)s=12
else if(s===B.D)s=14
else if(s===B.z)s=93
else s=s===B.E?95:0}return s},
fp(a){var s=A.a8(11),r=this.dg(a)
s.U(39169)
s.U(7)
s.U(a.ay)
s.v(B.a3.a4("AE"))
s.j(3)
s.U(r)
return s.Z()},
kO(a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=4294967295
t.M.a(a3)
q=a1.a
q===$&&A.c()
a2.L(67324752)
p=a1.f
o=p>4294967295||a1.r>4294967295
n=a1.Q
m=(n?8:0)|2048
l=a1.at===B.D
if(l&&a1.ch)m|=2
m=a1.db=m|a1.CW
k=(m&1)!==0
j=k?99:this.dg(a1)
i=a1.b
h=a1.c
g=n?0:a1.e
if(n)f=0
else f=o?a0:p
if(n)e=0
else e=o?a0:a1.r
d=A.i([],t.t)
if(o&&!a1.as){c=A.a8(20)
c.j(1)
c.j(0)
c.j(16)
c.j(0)
c.aB(a1.r)
c.aB(a1.f)
B.b.af(d,c.Z())}if(a1.as){B.b.af(d,B.c4)
B.b.af(d,B.bz)}if(k)B.b.af(d,this.fp(a1))
s=a1.w
b=B.t.a4(q)
if(l)q=63
else q=o||a1.as?45:20
a2.U(q)
a2.U(m)
a2.U(j)
a2.U(i)
a2.U(h)
a2.L(g)
a2.L(a1.as?a0:f)
a2.L(a1.as?a0:e)
a2.U(b.length)
a2.U(d.length)
a2.v(b)
a2.v(d)
a=a1.x
if(a!=null)return A.oq(a,a2,a1,a3)
else{if(s!=null){q=s
q=q.gi(q)>1048576}else q=!1
if(q)return A.oq(s,a2,a1,a3)
else if(s!=null){r=s.gA()
try{a2.b6(s)}finally{s.S(r)}}}return null},
kN(b2,b3,b4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1=4294967295
t.dX.a(b2)
s=B.t.a4("")
r=b4.b
for(q=b2.length,p=t.t,o=!1,n=0;m=b2.length,n<m;b2.length===q||(0,A.O)(b2),++n){l=b2[n]
k=l.f>4294967295||l.r>4294967295||l.cy>4294967295
o=B.bf.ih(o,k)
m=l.a
m===$&&A.c()
m=new A.f2(m)
m=m.kZ(m,new A.ja())
j=m?40:20
m=l.fr?3:0
i=l.at===B.D
if(i)h=63
else h=l.as||k?45:20
g=l.Q?2056:2048
f=(l.db&1)!==0
if(f)g|=1
if(i&&l.ch)g|=2
e=l.CW
d=f?99:this.dg(l)
c=l.b
b=l.c
a=l.e
a0=k?b1:l.f
a1=k?b1:l.r
a2=l.dx<<16>>>0
if(!l.dy)a2=(a2|16)>>>0
a3=k?b1:l.cy
a4=A.i([],p)
if(k){a5=new A.bg(new Uint8Array(28),B.d)
a5.j(1)
a5.j(0)
a5.j(24)
a5.j(0)
a5.aB(l.r)
a5.aB(l.f)
a5.aB(l.cy)
B.b.af(a4,J.ak(B.c.gN(a5.c),a5.c.byteOffset,a5.b))}if((l.db&1)!==0)B.b.af(a4,this.fp(l))
a6=B.a.E(l.d,4294967296)
B.b.af(a4,A.i([85,84,5,0,1,B.a.E(a6,256),B.a.E(B.a.t(a6,256),256),B.a.E(B.a.t(a6,65536),256),B.a.t(a6,16777216)],p))
a7=l.cx
if(a7==null)a7=""
a8=B.t.a4(l.a)
a9=B.t.a4(a7)
b4.L(33639248)
b4.U((m<<8|j)>>>0)
b4.U(h)
b4.U(g|e)
b4.U(d)
b4.U(c)
b4.U(b)
b4.L(a)
b4.L(a0)
b4.L(a1)
b4.U(a8.length)
b4.U(a4.length)
b4.U(a9.length)
b4.U(0)
b4.U(0)
b4.L(a2)
b4.L(a3)
b4.v(a8)
b4.v(a4)
b4.v(a9)}q=b4.b
b0=q-r
k=o||m>65535||b0>4294967295||r>4294967295
if(k){b4.L(101075792)
b4.aB(44)
b4.U(45)
b4.U(45)
b4.L(0)
b4.L(0)
b4.aB(m)
b4.aB(m)
b4.aB(b0)
b4.aB(r)
b4.L(117853008)
b4.L(0)
b4.aB(q)
b4.L(1)}b4.L(101010256)
b4.U(0)
b4.U(k?65535:0)
b4.U(k?65535:m)
b4.U(k?65535:m)
b4.L(k?b1:b0)
b4.L(k?b1:r)
b4.U(s.length)
b4.v(s)}}
A.jb.prototype={
$0(){var s=this.a
s.x=s.w=null},
$S:0}
A.ja.prototype={
$1(a){return A.H(a)>127},
$S:13}
A.jc.prototype={
gaU(){var s,r=this,q=r.w
if(q===$){s=r.r
q=r.w=s==null?r.b:s}return q},
gkz(){var s,r=this,q=r.y
if(q===$){s=r.c
if(s.Q&&s.at===B.u)r.gaU()
r.y!==$&&A.bC()
q=r.y=null}return q},
kE(){var s,r=this,q=r.a,p=q.gi(q)<65536?q.gi(q):65536
if(r.Q||p<=0)return!1
s=q.K(p).B()
q=r.c
q.e=A.I(s,q.e)
r.x=r.x+s.length
r.gaU().v(s)
return!0},
j8(){var s,r,q=this,p=q.a,o=p.gi(p)<65536?p.gi(p):65536
if(q.Q||o<=0)return!1
s=q.kC()
r=p.K(o).B()
p=q.c
p.e=A.I(r,p.e)
p=r.length
q.x=q.x+p
s.kY(t.L.a(r),0,p,!1)
return!0},
kC(){var s,r,q,p,o,n,m=this,l=m.z
if(l==null){l=m.c
switch(l.at.a){case 3:s=m.gaU()
l=l.z
r=m.a
r=r.gi(r)
q=A.os()
p=new Uint32Array(3)
B.f.ab(p,0,$.m4())
o=A.iY()
l=A.pO(l)
n=new Uint8Array(0)
l=new A.ed(l,r,q,p,o,new A.cR(s),n,new Uint8Array(0))
if(r<0)A.j(A.aZ(r,"contentSize","Must not be negative"))
break
case 5:l=m.gaU()
s=A.ol()
r=A.i([],t.et)
q=new Uint8Array(0)
l=new A.e5(new A.f4(new A.f5()),s,r,new A.cR(l),q,new Uint8Array(0))
break
default:l=m.gaU()
s=A.ma()
r=new Uint8Array(0)
l=new A.dh(s,new A.cR(l),r,new Uint8Array(0))
break}l=m.z=l}return l},
bf(){var s,r,q,p,o,n=this
if(n.Q)return
s=n.c
if(!s.Q){s=n.a
n.b.b6(s)
n.Q=!0
s.S(n.f)
n.d.$0()
return}n.gkz()
r=s.at
if(r===B.l)while(n.kE());else if(r!==B.u)n.jk()
else{q=n.a.B()
s.e=A.I(q,0)
n.x=q.length
B.a8.hH(A.U(q,B.d,null,null),n.gaU(),s.z,!0)}r=n.r
if(r!=null){r.dm()
p=r.c
p.hJ()
r=r.b
p=p.f
p===$&&A.c()
r.v(p)}n.Q=!0
n.a.a0()
r=n.b
s.f=r.b-n.e
s.r=n.x
r.L(134695760)
r.L(s.e)
p=s.as
o=s.f
if(p){r.aB(o)
r.aB(s.r)}else{r.L(o)
r.L(s.r)}n.d.$0()},
jk(){var s,r,q=this,p=q.z
if(p!=null){while(q.j8());p.al()
return}s=q.a
r=new A.fS(s,new Uint8Array(1),s.a)
s=q.c
switch(s.at.a){case 3:new A.fJ(3,null).hG(r,q.gaU(),s.z)
break
case 5:new A.fH().c0(r,q.gaU())
break
default:A.ma().c0(r,q.gaU())}s.e=r.c
q.x=r.d}}
A.fS.prototype={
gA(){return this.b.gA()},
gi(a){var s=this.b
return s.gi(s)},
gP(){return this.b.gP()},
S(a){return this.b.S(a)},
aR(a,b,c){return this.b.aR(a,b,c)},
a6(a,b){return this.aR(null,a,b)},
G(){var s=this,r=s.b.G(),q=s.e
q.$flags&2&&A.b(q)
q[0]=r
s.c=A.I(q,s.c);++s.d
return r},
K(a){var s=this,r=s.b.K(a).B()
s.c=A.I(r,s.c)
s.d=s.d+r.length
return A.U(r,B.d,null,null)},
az(a,b,c){var s=this,r=s.b.az(a,b,c)
s.c=A.I(A.Q(a,b,b+r),s.c)
s.d+=r
return r}}
A.fM.prototype={
gi(a){return this.f},
j(a){var s,r,q=this
if(q.e===16384)q.dm()
s=q.d
r=q.e++
s.$flags&2&&A.b(s)
if(!(r>=0&&r<16384))return A.a(s,r)
s[r]=a;++q.f},
ah(a,b){var s,r,q,p,o,n=this
t.L.a(a)
s=b==null?a.length:b
for(r=n.d,q=0;q<s;){if(n.e===16384)n.dm()
p=n.e
o=Math.min(s-q,16384-p)
B.c.H(r,p,p+o,a,q)
n.e+=o
q+=o}n.f+=s},
v(a){return this.ah(a,null)},
dm(){var s,r=this,q=r.e
if(q>0){s=r.d
r.c.hY(s,0,q)
r.b.ah(s,r.e)
r.e=0}},
T(){},
ai(a,b){return A.j(A.ao("An encrypting stream keeps no bytes"))},
aQ(a){return this.ai(a,null)}}
A.il.prototype={
iq(a1,a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=a1.length
for(s=0;s<a0;++s){r=a1[s]
if(r>a.b)a.b=r
if(r<a.c)a.c=r}r=a.b
if(r>15)throw A.d(B.bb)
q=r+1
p=new Uint16Array(q)
for(o=0;o<a0;++o){n=a1[o]
if(n!==0){if(!(n>=0&&n<q))return A.a(p,n)
m=p[n]
if(!(n<q))return A.a(p,n)
p[n]=m+1}}for(l=1,k=1;k<=r;++k){l=(l<<1>>>0)-p[k]
if(l<0)throw A.d(B.bd)}if(l>0)q=r>(a2?0:1)
else q=!1
if(q)throw A.d(B.bc)
j=B.a.p(1,r)
r=a.a=new Uint32Array(j)
for(q=a.b,m=a1.length,i=1,h=0,g=2;i<=q;){for(f=i<<16,s=0;s<a0;++s){if(!(s<m))return A.a(a1,s)
if(a1[s]===i){for(e=h,d=0,c=0;c<i;++c){d=(d<<1|e&1)>>>0
e=e>>>1}for(b=(f|s)>>>0,c=d;c<j;c+=g){if(!(c>=0&&c<j))return A.a(r,c)
r[c]=b}++h}}++i
h=h<<1>>>0
g=g<<1>>>0}}}
A.j2.prototype={}
A.kM.prototype={
hA(a,b,c,d,e){var s,r=d===!0,q=a.a
a.a=B.y
try{s=A.d8("zlib",!1,r,new A.kN(this,a,b,!1,c))
return s}finally{a.sbu(q)}},
iU(a,b,c,d){var s,r,q,p,o,n,m,l,k,j
if(a.gP())return!1
A:{s=null
if(!a.gP()){r=!d
if(r){if(a.gi(a)<2)return!1
q=a.G()
p=a.G()
if((q&15)!==8)return!1
if(q>>>4>7)return!1
if(B.a.E(q*256+p,31)!==0)return!1
if((p>>>5&1)!==0){a.J()
return!1}}o=b instanceof A.bg&&b.b===0
n=o?b:null
m=null
if(a instanceof A.a6){l=a.b
l=l==null?0:l.length-a.c
if(l>=0&&l<8192)m=l<16?64:l*4}if(n==null){n=m==null?32768:m
n=new A.bg(new Uint8Array(n),B.d)}k=new A.im(a,n,!0)
k.jy()
j=k.c.Z()
if(o){if(!k.f)return!1
if(r){if(a.gi(a)<4)return!1
a.J()}break A}if(!k.f){b.v(j)
return!1}if(r){if(a.gi(a)<4){b.v(j)
return!1}a.J()}s=j
break A}}if(s!=null)b.v(s)
return!0}}
A.kN.prototype={
$0(){var s=this
return s.a.iU(s.b,s.c,s.d,s.e)},
$S:3}
A.j4.prototype={}
A.cR.prototype={
m(a,b){t.L.a(b)
this.a.v(b)
this.b=this.b+b.length},
$iS:1}
A.kO.prototype={
hH(a,b,c,d){var s,r,q,p=null
if(d){r=c==null?6:c
q=p
if(q==null)q=15
A.nT(a,a instanceof A.a6?a.gi(0):null,r,b,q)
return}s=b.a
b.a=B.y
try{this.kW(a,b,c,p)}finally{b.sbu(s)}},
kW(a,b,c,d){var s,r,q,p
b.j(120)
for(s=0;r=(s|0)>>>0,(30720+r)%31!==0;)++s
b.j(r)
q=a.gA()
p=A.vA(a)
a.S(q)
r=c==null?6:c
A.nT(a,a instanceof A.a6?a.gi(0):null,r,b,15)
b.L(p)
b.T()}}
A.cX.prototype={
bp(){return"_DeflateFlushMode."+this.b}}
A.ii.prototype={
jA(a,b,c){var s,r,q,p,o,n,m=this
if(c===8)c=9
s=!0
if(c>=9)if(c<=15)s=a>9
if(s)throw A.d(A.bd("Invalid Deflate parameters",null))
r=m.jq(a)
if(r==null)return!1
$.bF.b=r
m.p1=new Uint16Array(1146)
m.p2=new Uint16Array(122)
m.p3=new Uint16Array(78)
if(b!=null&&b>=0){s=b+262
q=9
for(;;){if(!(q<c&&B.a.q(1,q)<=s))break;++q}s=b+2
p=10
for(;;){if(!(p<14&&B.a.q(1,p)<s))break;++p}o=p
c=q}else o=14
m.as=c
s=m.Q=B.a.q(1,c)
m.at=s-1
m.db=15
m.cy=32768
m.dx=32767
m.dy=5
m.ax=new Uint8Array(s*2)
m.ch=new Uint16Array(s)
m.CW=new Uint16Array(32768)
s=m.y1=B.a.q(1,o)
n=s*4
m.f=new Uint8Array(n)
m.r=n
m.cG=s
m.xr=3*s
m.k4=a
m.w=m.x=m.ok=0
m.c=113
m.d=0
s=m.p4
s.a=m.p1
s.c=$.qj()
s=m.R8
s.a=m.p2
s.c=$.qi()
s=m.RG
s.a=m.p3
s.c=$.qh()
m.aw=m.av=0
m.c2=8
m.fz()
m.ay=2*m.Q
m.k2=m.fr=m.id=0
m.fx=m.k3=2
m.cx=m.go=0
return!0},
j4(a){var s,r,q,p,o=this,n=o.x
n===$&&A.c()
if(n!==0)o.dw()
n=!0
if(o.a.gP()){s=o.k2
s===$&&A.c()
if(s===0)n=a!==B.R&&o.c!==666}if(n){switch($.bF.cm().e){case 0:r=o.j7(a)
break
case 1:r=o.j5(a)
break
case 2:r=o.j6(a)
break
default:r=-1
break}n=r===2
if(n||r===3)o.c=666
if(r===0||n)return 0
if(r===1){if(a===B.cF){o.a8(2,3)
n=$.m0()
o.br(256,n)
o.hr()
s=o.c2
s===$&&A.c()
q=o.aw
q===$&&A.c()
if(1+s+10-q<9){o.a8(2,3)
o.br(256,n)
o.hr()}o.c2=7}else{o.h8(0,0,!1)
if(a===B.cG){n=o.cy
n===$&&A.c()
s=o.CW
p=0
for(;p<n;++p){s===$&&A.c()
s.$flags&2&&A.b(s)
if(!(p<s.length))return A.a(s,p)
s[p]=0}}}o.dw()}}if(a!==B.L)return 0
return 1},
fz(){var s=this,r=s.p1
r===$&&A.c()
B.j.F(r,0,572,0)
r=s.p2
r===$&&A.c()
B.j.F(r,0,60,0)
r=s.p3
r===$&&A.c()
B.j.F(r,0,38,0)
r=s.p1
r.$flags&2&&A.b(r)
r[512]=1
s.y2=s.cH=s.aN=s.by=0},
dJ(a,b){var s,r,q,p,o,n,m=this.ry
if(!(b>=0&&b<573))return A.a(m,b)
s=m[b]
r=b<<1>>>0
q=m.$flags|0
p=this.x2
for(;;){o=this.to
o===$&&A.c()
if(!(r<=o))break
if(r<o){o=r+1
if(!(o>=0&&o<573))return A.a(m,o)
o=m[o]
if(!(r>=0&&r<573))return A.a(m,r)
o=A.nU(a,o,m[r],p)}else o=!1
if(o)++r
if(!(r>=0&&r<573))return A.a(m,r)
if(A.nU(a,s,m[r],p))break
o=m[r]
q&2&&A.b(m)
if(!(b>=0&&b<573))return A.a(m,b)
m[b]=o
n=r<<1>>>0
b=r
r=n}q&2&&A.b(m)
if(!(b>=0&&b<573))return A.a(m,b)
m[b]=s},
fU(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=a.length
if(1>=h)return A.a(a,1)
s=a[1]
if(s===0){r=138
q=3}else{r=7
q=4}p=(b+1)*2+1
a.$flags&2&&A.b(a)
if(!(p>=0&&p<h))return A.a(a,p)
a[p]=65535
for(p=this.p3,o=0,n=-1,m=0;o<=b;s=k){++o
l=o*2+1
if(!(l<h))return A.a(a,l)
k=a[l];++m
if(m<r&&s===k)continue
else{j=3
if(m<q){p===$&&A.c()
l=s*2
if(!(l<78))return A.a(p,l)
i=p[l]
p.$flags&2&&A.b(p)
p[l]=i+m}else if(s!==0){if(s!==n){p===$&&A.c()
l=s*2
if(!(l<78))return A.a(p,l)
i=p[l]
p.$flags&2&&A.b(p)
p[l]=i+1}p===$&&A.c()
l=p[32]
p.$flags&2&&A.b(p)
p[32]=l+1}else if(m<=10){p===$&&A.c()
l=p[34]
p.$flags&2&&A.b(p)
p[34]=l+1}else{p===$&&A.c()
l=p[36]
p.$flags&2&&A.b(p)
p[36]=l+1}}if(k===0){q=j
r=138}else if(s===k){q=j
r=6}else{r=7
q=4}n=s
m=0}},
iE(){var s,r,q=this,p=q.p1
p===$&&A.c()
s=q.p4.b
s===$&&A.c()
q.fU(p,s)
s=q.p2
s===$&&A.c()
p=q.R8.b
p===$&&A.c()
q.fU(s,p)
q.RG.d7(q)
for(r=18;r>=3;--r){p=q.p3
p===$&&A.c()
s=$.nt()
if(!(r<s.length))return A.a(s,r)
s=s[r]*2+1
if(!(s<78))return A.a(p,s)
if(p[s]!==0)break}p=q.aN
p===$&&A.c()
q.aN=p+(3*(r+1)+5+5+4)
return r},
ku(a,b,c){var s,r,q,p,o=this
o.a8(a-257,5)
s=b-1
o.a8(s,5)
o.a8(c-4,4)
for(r=0;r<c;++r){q=o.p3
q===$&&A.c()
p=$.nt()
if(!(r<p.length))return A.a(p,r)
p=p[r]*2+1
if(!(p<78))return A.a(q,p)
o.a8(q[p],3)}q=o.p1
q===$&&A.c()
o.fY(q,a-1)
q=o.p2
q===$&&A.c()
o.fY(q,s)},
fY(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=a.length
if(1>=f)return A.a(a,1)
s=a[1]
if(s===0){r=138
q=3}else{r=7
q=4}for(p=0,o=-1,n=0;p<=b;s=l){++p
m=p*2+1
if(!(m<f))return A.a(a,m)
l=a[m];++n
if(n<r&&s===l)continue
else{k=3
if(n<q){m=s*2
j=m+1
do{i=g.p3
i===$&&A.c()
if(!(m<78))return A.a(i,m)
h=i[m]
if(!(j<78))return A.a(i,j)
g.a8(h&65535,i[j]&65535)}while(--n,n!==0)}else if(s!==0){if(s!==o){m=g.p3
m===$&&A.c()
j=s*2
if(!(j<78))return A.a(m,j)
i=m[j];++j
if(!(j<78))return A.a(m,j)
g.a8(i&65535,m[j]&65535);--n}m=g.p3
m===$&&A.c()
g.a8(m[32]&65535,m[33]&65535)
g.a8(n-3,2)}else{m=g.p3
if(n<=10){m===$&&A.c()
g.a8(m[34]&65535,m[35]&65535)
g.a8(n-3,3)}else{m===$&&A.c()
g.a8(m[36]&65535,m[37]&65535)
g.a8(n-11,7)}}}if(l===0){q=k
r=138}else if(s===l){q=k
r=6}else{r=7
q=4}o=s
n=0}},
ke(a,b,c){var s,r,q=this
if(c===0)return
s=q.f
s===$&&A.c()
r=q.x
r===$&&A.c()
B.c.H(s,r,r+c,a,b)
q.x=q.x+c},
aD(a){var s,r=this.f
r===$&&A.c()
s=this.x
s===$&&A.c()
this.x=s+1
r.$flags&2&&A.b(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=a},
br(a,b){var s,r=a*2,q=b.length
if(!(r<q))return A.a(b,r)
s=b[r];++r
if(!(r<q))return A.a(b,r)
this.a8(s&65535,b[r]&65535)},
a8(a,b){var s,r=this,q=r.aw
q===$&&A.c()
s=r.av
if(q>16-b){s===$&&A.c()
q=r.av=(s|B.a.p(a,q)&65535)>>>0
r.aD(q)
r.aD(A.aB(q,8))
r.av=A.aB(a,16-r.aw)
r.aw=r.aw+(b-16)}else{s===$&&A.c()
r.av=(s|B.a.p(a,q)&65535)>>>0
r.aw=q+b}},
bX(a,b){var s,r,q,p,o,n=this,m=n.f
m===$&&A.c()
s=n.cG
s===$&&A.c()
r=n.y2
r===$&&A.c()
r=s+r*2
s=A.aB(a,8)
m.$flags&2&&A.b(m)
if(!(r<m.length))return A.a(m,r)
m[r]=s
s=n.f
r=n.cG
m=n.y2
r=r+m*2+1
s.$flags&2&&A.b(s)
q=s.length
if(!(r<q))return A.a(s,r)
s[r]=a
r=n.xr
r===$&&A.c()
r+=m
if(!(r<q))return A.a(s,r)
s[r]=b
n.y2=m+1
if(a===0){m=n.p1
m===$&&A.c()
s=b*2
if(!(s>=0&&s<1146))return A.a(m,s)
r=m[s]
m.$flags&2&&A.b(m)
m[s]=r+1}else{m=n.cH
m===$&&A.c()
n.cH=m+1
m=n.p1
m===$&&A.c()
s=$.nv()
if(!(b>=0&&b<s.length))return A.a(s,b)
s=(s[b]+256+1)*2
if(!(s<1146))return A.a(m,s)
r=m[s]
m.$flags&2&&A.b(m)
m[s]=r+1
r=n.p2
r===$&&A.c()
s=A.oE(a-1)*2
if(!(s<122))return A.a(r,s)
m=r[s]
r.$flags&2&&A.b(r)
r[s]=m+1}m=n.y2
if((m&8191)===0){s=n.k4
s===$&&A.c()
s=s>2}else s=!1
if(s){p=m*8
m=n.id
m===$&&A.c()
s=n.fr
s===$&&A.c()
for(o=0;o<30;++o){r=n.p2
r===$&&A.c()
q=o*2
if(!(q<122))return A.a(r,q)
q=r[q]
r=$.m_()
if(!(o<r.length))return A.a(r,o)
p+=q*(5+r[o])}p=A.aB(p,3)
r=n.cH
r===$&&A.c()
q=n.y2
if(r<q/2&&p<(m-s)/2)return!0
m=q}s=n.y1
s===$&&A.c()
return m===s-1},
fa(a,b){var s,r,q,p,o,n,m,l,k=this,j=k.y2
j===$&&A.c()
if(j!==0){s=0
do{j=k.f
j===$&&A.c()
r=k.cG
r===$&&A.c()
r+=s*2
q=j.length
if(!(r<q))return A.a(j,r)
p=j[r];++r
if(!(r<q))return A.a(j,r)
o=p<<8&65280|j[r]&255
r=k.xr
r===$&&A.c()
r+=s
if(!(r<q))return A.a(j,r)
n=j[r]&255;++s
if(o===0)k.br(n,a)
else{j=$.nv()
if(!(n<j.length))return A.a(j,n)
m=j[n]
k.br(m+256+1,a)
j=$.nu()
if(!(m<j.length))return A.a(j,m)
l=j[m]
if(l!==0){j=$.qf()
if(!(m<j.length))return A.a(j,m)
k.a8(n-j[m],l)}--o
m=A.oE(o)
k.br(m,b)
j=$.m_()
if(!(m<j.length))return A.a(j,m)
l=j[m]
if(l!==0){j=$.qe()
if(!(m<j.length))return A.a(j,m)
k.a8(o-j[m],l)}}}while(s<k.y2)}k.br(256,a)
if(513>=a.length)return A.a(a,513)
k.c2=a[513]},
ii(){var s,r,q,p,o
for(s=this.p1,r=0,q=0;r<7;){s===$&&A.c()
p=r*2
if(!(p<1146))return A.a(s,p)
q+=s[p];++r}for(o=0;r<128;){s===$&&A.c()
p=r*2
if(!(p<1146))return A.a(s,p)
o+=s[p];++r}while(r<256){s===$&&A.c()
p=r*2
if(!(p<1146))return A.a(s,p)
q+=s[p];++r}this.y=q>A.aB(o,2)?0:1},
hr(){var s=this,r=s.aw
r===$&&A.c()
if(r===16){r=s.av
r===$&&A.c()
s.aD(r)
s.aD(A.aB(r,8))
s.aw=s.av=0}else if(r>=8){r=s.av
r===$&&A.c()
s.aD(r)
s.av=A.aB(s.av,8)
s.aw=s.aw-8}},
eR(){var s=this,r=s.aw
r===$&&A.c()
if(r>8){r=s.av
r===$&&A.c()
s.aD(r)
s.aD(A.aB(r,8))}else if(r>0){r=s.av
r===$&&A.c()
s.aD(r)}s.aw=s.av=0},
b0(a){var s,r,q,p,o,n=this,m=n.fr
m===$&&A.c()
if(m>=0)s=m
else s=-1
r=n.id
r===$&&A.c()
m=r-m
r=n.k4
r===$&&A.c()
if(r>0){if(n.y===2)n.ii()
n.p4.d7(n)
n.R8.d7(n)
q=n.iE()
r=n.aN
r===$&&A.c()
p=A.aB(r+3+7,3)
r=n.by
r===$&&A.c()
o=A.aB(r+3+7,3)
if(o<=p)p=o}else{o=m+5
p=o
q=0}if(m+4<=p&&s!==-1)n.h8(s,m,a)
else if(o===p){n.a8(2+(a?1:0),3)
n.fa($.m0(),$.nw())}else{n.a8(4+(a?1:0),3)
m=n.p4.b
m===$&&A.c()
s=n.R8.b
s===$&&A.c()
n.ku(m+1,s+1,q+1)
s=n.p1
s===$&&A.c()
m=n.p2
m===$&&A.c()
n.fa(s,m)}n.fz()
if(a)n.eR()
n.fr=n.id
n.dw()},
j7(a){var s,r,q,p,o,n=this,m=n.r
m===$&&A.c()
s=m-5
s=65535>s?s:65535
for(m=a===B.R;;){r=n.k2
r===$&&A.c()
if(r<=1){n.dt()
r=n.k2
q=r===0
if(q&&m)return 0
if(q)break}q=n.id
q===$&&A.c()
r=n.id=q+r
n.k2=0
q=n.fr
q===$&&A.c()
p=q+s
if(r>=p){n.k2=r-p
n.id=p
n.b0(!1)}r=n.id
q=n.fr
o=n.Q
o===$&&A.c()
if(r-q>=o-262)n.b0(!1)}m=a===B.L
n.b0(m)
return m?3:1},
h8(a,b,c){var s,r=this
r.a8(c?1:0,3)
r.eR()
r.c2=8
r.aD(b)
r.aD(A.aB(b,8))
s=(~b>>>0)+65536&65535
r.aD(s)
r.aD(A.aB(s,8))
s=r.ax
s===$&&A.c()
r.ke(s,a,b)},
dt(){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=h.a
do{s=h.ay
s===$&&A.c()
r=h.k2
r===$&&A.c()
q=h.id
q===$&&A.c()
p=s-r-q
if(p===0&&q===0&&r===0){s=h.Q
s===$&&A.c()
p=s}else{s=h.Q
s===$&&A.c()
if(q>=s+s-262){r=h.ax
r===$&&A.c()
B.c.H(r,0,s,r,s)
s=h.k1
o=h.Q
h.k1=s-o
h.id=h.id-o
s=h.fr
s===$&&A.c()
h.fr=s-o
s=h.cy
s===$&&A.c()
r=h.CW
r===$&&A.c()
q=r.length
n=r.$flags|0
m=s
l=m
do{--m
if(!(m>=0&&m<q))return A.a(r,m)
k=r[m]&65535
s=k>=o?k-o:0
n&2&&A.b(r)
r[m]=s}while(--l,l!==0)
s=h.ch
s===$&&A.c()
r=s.length
q=s.$flags|0
m=o
l=m
do{--m
if(!(m>=0&&m<r))return A.a(s,m)
k=s[m]&65535
n=k>=o?k-o:0
q&2&&A.b(s)
s[m]=n}while(--l,l!==0)
p+=o}}if(g.gP())return
s=h.ax
s===$&&A.c()
l=h.kg(s,h.id+h.k2,p)
s=h.k2=h.k2+l
if(s>=3){r=h.ax
q=h.id
n=r.length
if(q>>>0!==q||q>=n)return A.a(r,q)
j=r[q]&255
h.cx=j
i=h.dy
i===$&&A.c()
i=B.a.p(j,i);++q
if(!(q<n))return A.a(r,q)
q=r[q]
r=h.dx
r===$&&A.c()
h.cx=((i^q&255)&r)>>>0}}while(s<262&&!g.gP())},
j5(a){var s,r,q,p,o,n,m,l,k,j,i=this
for(s=a===B.R,r=0;;){q=i.k2
q===$&&A.c()
if(q<262){i.dt()
q=i.k2
if(q<262&&s)return 0
if(q===0)break}if(q>=3){q=i.cx
q===$&&A.c()
p=i.dy
p===$&&A.c()
p=B.a.p(q,p)
q=i.ax
q===$&&A.c()
o=i.id
o===$&&A.c()
n=o+2
if(!(n>=0&&n<q.length))return A.a(q,n)
n=q[n]
q=i.dx
q===$&&A.c()
q=((p^n&255)&q)>>>0
i.cx=q
n=i.CW
n===$&&A.c()
if(!(q<n.length))return A.a(n,q)
p=n[q]
r=p&65535
m=i.ch
m===$&&A.c()
l=i.at
l===$&&A.c()
l=(o&l)>>>0
m.$flags&2&&A.b(m)
if(!(l>=0&&l<m.length))return A.a(m,l)
m[l]=p
n.$flags&2&&A.b(n)
n[q]=o}if(r!==0){q=i.id
q===$&&A.c()
p=i.Q
p===$&&A.c()
p=(q-r&65535)<=p-262
q=p}else q=!1
if(q){q=i.ok
q===$&&A.c()
if(q!==2)i.fx=i.fG(r)}q=i.fx
q===$&&A.c()
p=i.id
if(q>=3){p===$&&A.c()
k=i.bX(p-i.k1,q-3)
q=i.k2
p=i.fx
q-=p
i.k2=q
o=$.bF.b
if(o===$.bF)A.j(A.iq(""))
if(p<=o.b&&q>=3){q=i.fx=p-1
do{p=i.id=i.id+1
o=i.cx
o===$&&A.c()
n=i.dy
n===$&&A.c()
n=B.a.p(o,n)
o=i.ax
o===$&&A.c()
m=p+2
if(!(m>=0&&m<o.length))return A.a(o,m)
m=o[m]
o=i.dx
o===$&&A.c()
o=((n^m&255)&o)>>>0
i.cx=o
m=i.CW
m===$&&A.c()
if(!(o<m.length))return A.a(m,o)
n=m[o]
r=n&65535
l=i.ch
l===$&&A.c()
j=i.at
j===$&&A.c()
j=(p&j)>>>0
l.$flags&2&&A.b(l)
if(!(j>=0&&j<l.length))return A.a(l,j)
l[j]=n
m.$flags&2&&A.b(m)
m[o]=p}while(q=i.fx=q-1,q!==0)
i.id=p+1}else{q=i.id=i.id+p
i.fx=0
p=i.ax
p===$&&A.c()
o=p.length
if(!(q>=0&&q<o))return A.a(p,q)
n=p[q]&255
i.cx=n
m=i.dy
m===$&&A.c()
m=B.a.p(n,m);++q
if(!(q<o))return A.a(p,q)
q=p[q]
p=i.dx
p===$&&A.c()
i.cx=((m^q&255)&p)>>>0}}else{q=i.ax
q===$&&A.c()
p===$&&A.c()
if(!(p>=0&&p<q.length))return A.a(q,p)
k=i.bX(0,q[p]&255)
i.k2=i.k2-1
i.id=i.id+1}if(k)i.b0(!1)}s=a===B.L
i.b0(s)
return s?3:1},
j6(a){var s,r,q,p,o,n,m,l,k,j,i,h=this
for(s=a===B.R,r=0;;){q=h.k2
q===$&&A.c()
if(q<262){h.dt()
q=h.k2
if(q<262&&s)return 0
if(q===0)break}if(q>=3){q=h.cx
q===$&&A.c()
p=h.dy
p===$&&A.c()
p=B.a.p(q,p)
q=h.ax
q===$&&A.c()
o=h.id
o===$&&A.c()
n=o+2
if(!(n>=0&&n<q.length))return A.a(q,n)
n=q[n]
q=h.dx
q===$&&A.c()
q=((p^n&255)&q)>>>0
h.cx=q
n=h.CW
n===$&&A.c()
if(!(q<n.length))return A.a(n,q)
p=n[q]
r=p&65535
m=h.ch
m===$&&A.c()
l=h.at
l===$&&A.c()
l=(o&l)>>>0
m.$flags&2&&A.b(m)
if(!(l>=0&&l<m.length))return A.a(m,l)
m[l]=p
n.$flags&2&&A.b(n)
n[q]=o}q=h.fx
q===$&&A.c()
h.k3=q
h.fy=h.k1
h.fx=2
p=!1
if(r!==0){o=$.bF.b
if(o===$.bF)A.j(A.iq(""))
if(q<o.b){q=h.id
q===$&&A.c()
p=h.Q
p===$&&A.c()
p=(q-r&65535)<=p-262
q=p}else q=p}else q=p
p=2
if(q){q=h.ok
q===$&&A.c()
if(q!==2){q=h.fG(r)
h.fx=q}else q=p
o=!1
if(q<=5)if(h.ok!==1){if(q===3){o=h.id
o===$&&A.c()
o=o-h.k1>4096}}else o=!0
if(o){h.fx=2
q=p}}else q=p
p=h.k3
if(p>=3&&q<=p){q=h.id
q===$&&A.c()
k=q+h.k2-3
j=h.bX(q-1-h.fy,p-3)
p=h.k2
q=h.k3
h.k2=p-(q-1)
q=h.k3=q-2
do{p=h.id=h.id+1
if(p<=k){o=h.cx
o===$&&A.c()
n=h.dy
n===$&&A.c()
n=B.a.p(o,n)
o=h.ax
o===$&&A.c()
m=p+2
if(!(m>=0&&m<o.length))return A.a(o,m)
m=o[m]
o=h.dx
o===$&&A.c()
o=((n^m&255)&o)>>>0
h.cx=o
m=h.CW
m===$&&A.c()
if(!(o<m.length))return A.a(m,o)
n=m[o]
r=n&65535
l=h.ch
l===$&&A.c()
i=h.at
i===$&&A.c()
i=(p&i)>>>0
l.$flags&2&&A.b(l)
if(!(i>=0&&i<l.length))return A.a(l,i)
l[i]=n
m.$flags&2&&A.b(m)
m[o]=p}}while(q=h.k3=q-1,q!==0)
h.go=0
h.fx=2
h.id=p+1
if(j)h.b0(!1)}else{q=h.go
q===$&&A.c()
if(q!==0){q=h.ax
q===$&&A.c()
p=h.id
p===$&&A.c();--p
if(!(p>=0&&p<q.length))return A.a(q,p)
if(h.bX(0,q[p]&255))h.b0(!1)
h.id=h.id+1
h.k2=h.k2-1}else{h.go=1
q=h.id
q===$&&A.c()
h.id=q+1
h.k2=h.k2-1}}}s=h.go
s===$&&A.c()
if(s!==0){s=h.ax
s===$&&A.c()
q=h.id
q===$&&A.c();--q
if(!(q>=0&&q<s.length))return A.a(s,q)
h.bX(0,s[q]&255)
h.go=0}s=a===B.L
h.b0(s)
return s?3:1},
fG(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=$.bF.cm().d,a0=b.id
a0===$&&A.c()
s=b.k3
s===$&&A.c()
r=b.Q
r===$&&A.c()
r-=262
q=a0>r?a0-r:0
p=$.bF.cm().c
r=b.at
r===$&&A.c()
o=b.ax
o===$&&A.c()
n=b.ch
n===$&&A.c()
m=b.id+258
l=a0+s
k=l-1
j=o.length
if(!(k>=0&&k<j))return A.a(o,k)
i=o[k]
if(!(l>=0&&l<j))return A.a(o,l)
h=o[l]
if(b.k3>=$.bF.cm().a)a=a>>>2
l=b.k2
l===$&&A.c()
if(p>l)p=l
l=n.length
g=m-258
f=s
e=a0
do{A:{a0=a1+f
if(!(a0>=0&&a0<j))return A.a(o,a0)
s=!0
if(o[a0]===h){--a0
if(!(a0>=0))return A.a(o,a0)
if(o[a0]===i){if(!(a1>=0&&a1<j))return A.a(o,a1)
a0=o[a1]
if(!(e>=0&&e<j))return A.a(o,e)
if(a0===o[e]){d=a1+1
if(!(d<j))return A.a(o,d)
a0=o[d]
s=e+1
if(!(s<j))return A.a(o,s)
s=a0!==o[s]
a0=s}else{a0=s
d=a1}}else{a0=s
d=a1}}else{a0=s
d=a1}if(a0)break A
e+=2;++d
do{++e
if(!(e>=0&&e<j))return A.a(o,e)
a0=o[e];++d
if(!(d>=0&&d<j))return A.a(o,d)
s=!1
if(a0===o[d]){++e
if(!(e<j))return A.a(o,e)
a0=o[e];++d
if(!(d<j))return A.a(o,d)
if(a0===o[d]){++e
if(!(e<j))return A.a(o,e)
a0=o[e];++d
if(!(d<j))return A.a(o,d)
if(a0===o[d]){++e
if(!(e<j))return A.a(o,e)
a0=o[e];++d
if(!(d<j))return A.a(o,d)
if(a0===o[d]){++e
if(!(e<j))return A.a(o,e)
a0=o[e];++d
if(!(d<j))return A.a(o,d)
if(a0===o[d]){++e
if(!(e<j))return A.a(o,e)
a0=o[e];++d
if(!(d<j))return A.a(o,d)
if(a0===o[d]){++e
if(!(e<j))return A.a(o,e)
a0=o[e];++d
if(!(d<j))return A.a(o,d)
if(a0===o[d]){++e
if(!(e<j))return A.a(o,e)
a0=o[e];++d
if(!(d<j))return A.a(o,d)
a0=a0===o[d]&&e<m}else a0=s}else a0=s}else a0=s}else a0=s}else a0=s}else a0=s}else a0=s}while(a0)
c=258-(m-e)
if(c>f){b.k1=a1
if(c>=p){f=c
break}a0=g+c
s=a0-1
if(!(s>=0&&s<j))return A.a(o,s)
i=o[s]
if(!(a0<j))return A.a(o,a0)
h=o[a0]
f=c}e=g}a0=a1&r
if(!(a0>=0&&a0<l))return A.a(n,a0)
a1=n[a0]&65535
if(a1>q){--a
a0=a!==0}else a0=!1}while(a0)
a0=b.k2
if(f<=a0)return f
return a0},
kg(a,b,c){var s,r,q,p,o=this
if(c===0||o.a.gP())return 0
s=o.a.K(c)
r=s.gi(s)
if(r===0)return 0
q=s.B()
p=q.length
if(r>p)r=p
B.c.V(a,b,b+r,q)
o.e+=r
o.d=A.I(q,o.d)
return r},
dw(){var s,r=this,q=r.x
q===$&&A.c()
s=r.f
s===$&&A.c()
r.b.ah(s,q)
s=r.w
s===$&&A.c()
r.w=s+q
q=r.x-q
r.x=q
if(q===0)r.w=0},
jq(a){switch(a){case 0:return new A.aU(0,0,0,0,0)
case 1:return new A.aU(4,4,8,4,1)
case 2:return new A.aU(4,5,16,8,1)
case 3:return new A.aU(4,6,32,32,1)
case 4:return new A.aU(4,4,16,16,2)
case 5:return new A.aU(8,16,32,32,2)
case 6:return new A.aU(8,16,128,128,2)
case 7:return new A.aU(8,32,128,256,2)
case 8:return new A.aU(32,128,258,1024,2)
case 9:return new A.aU(32,258,258,4096,2)}return null}}
A.aU.prototype={}
A.ks.prototype={
jn(a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=this,a3=a2.a
a3===$&&A.c()
s=a2.c
s===$&&A.c()
r=s.a
q=s.b
p=s.c
o=s.e
for(s=a4.rx,n=s.$flags|0,m=0;m<=15;++m){n&2&&A.b(s)
s[m]=0}l=a4.ry
k=a4.x1
k===$&&A.c()
if(!(k>=0&&k<573))return A.a(l,k)
j=l[k]*2+1
a3.$flags&2&&A.b(a3)
i=a3.length
if(!(j>=0&&j<i))return A.a(a3,j)
a3[j]=0
for(h=k+1,k=r!=null,j=q.length,g=0;h<573;++h){f=l[h]
e=f*2
d=e+1
if(!(d>=0&&d<i))return A.a(a3,d)
c=a3[d]*2+1
if(!(c<i))return A.a(a3,c)
m=a3[c]+1
if(m>o){++g
m=o}a3.$flags&2&&A.b(a3)
a3[d]=m
c=a2.b
c===$&&A.c()
if(f>c)continue
if(!(m<16))return A.a(s,m)
c=s[m]
n&2&&A.b(s)
s[m]=c+1
if(f>=p){c=f-p
if(!(c>=0&&c<j))return A.a(q,c)
b=q[c]}else b=0
if(!(e>=0&&e<i))return A.a(a3,e)
a=a3[e]
e=a4.aN
e===$&&A.c()
a4.aN=e+a*(m+b)
if(k){e=a4.by
e===$&&A.c()
if(!(d<r.length))return A.a(r,d)
a4.by=e+a*(r[d]+b)}}if(g===0)return
m=o-1
do{a0=m
for(;;){if(!(a0>=0&&a0<16))return A.a(s,a0)
k=s[a0]
if(!(k===0))break;--a0}n&2&&A.b(s)
s[a0]=k-1
k=a0+1
if(!(k<16))return A.a(s,k)
s[k]=s[k]+2
if(!(o<16))return A.a(s,o)
s[o]=s[o]-1
g-=2}while(g>0)
for(m=o;m!==0;--m){if(!(m>=0))return A.a(s,m)
f=s[m]
while(f!==0){--h
if(!(h>=0&&h<573))return A.a(l,h)
a1=l[h]
n=a2.b
n===$&&A.c()
if(a1>n)continue
n=a1*2
k=n+1
if(!(k>=0&&k<i))return A.a(a3,k)
j=a3[k]
if(j!==m){e=a4.aN
e===$&&A.c()
if(!(n>=0&&n<i))return A.a(a3,n)
a4.aN=e+(m-j)*a3[n]
a3.$flags&2&&A.b(a3)
a3[k]=m}--f}}},
d7(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=a.a
a0===$&&A.c()
s=a.c
s===$&&A.c()
r=s.a
q=s.d
a1.to=0
a1.x1=573
for(s=a0.length,p=a1.ry,o=p.$flags|0,n=a1.x2,m=n.$flags|0,l=a0.$flags|0,k=0,j=-1;k<q;++k){i=k*2
if(!(i<s))return A.a(a0,i)
if(a0[i]!==0){i=++a1.to
o&2&&A.b(p)
if(!(i>=0&&i<573))return A.a(p,i)
p[i]=k
m&2&&A.b(n)
if(!(k<573))return A.a(n,k)
n[k]=0
j=k}else{++i
l&2&&A.b(a0)
if(!(i<s))return A.a(a0,i)
a0[i]=0}}for(i=r!=null;h=a1.to,h<2;){++h
a1.to=h
if(j<2){++j
g=j}else g=0
o&2&&A.b(p)
if(!(h>=0))return A.a(p,h)
p[h]=g
h=g*2
l&2&&A.b(a0)
if(!(h>=0&&h<s))return A.a(a0,h)
a0[h]=1
m&2&&A.b(n)
if(!(g>=0))return A.a(n,g)
n[g]=0
f=a1.aN
f===$&&A.c()
a1.aN=f-1
if(i){f=a1.by
f===$&&A.c();++h
if(!(h<r.length))return A.a(r,h)
a1.by=f-r[h]}}a.b=j
for(k=B.a.t(h,2);k>=1;--k)a1.dJ(a0,k)
g=q
do{k=p[1]
i=a1.to--
if(!(i>=0&&i<573))return A.a(p,i)
i=p[i]
o&2&&A.b(p)
p[1]=i
a1.dJ(a0,1)
e=p[1]
i=--a1.x1
if(!(i>=0&&i<573))return A.a(p,i)
p[i]=k;--i
a1.x1=i
if(!(i>=0))return A.a(p,i)
p[i]=e
i=g*2
h=k*2
if(!(h>=0&&h<s))return A.a(a0,h)
f=a0[h]
d=e*2
if(!(d>=0&&d<s))return A.a(a0,d)
c=a0[d]
l&2&&A.b(a0)
if(!(i<s))return A.a(a0,i)
a0[i]=f+c
if(!(k>=0&&k<573))return A.a(n,k)
c=n[k]
if(!(e>=0&&e<573))return A.a(n,e)
f=n[e]
i=c>f?c:f
m&2&&A.b(n)
if(!(g<573))return A.a(n,g)
n[g]=i+1;++h;++d
if(!(d<s))return A.a(a0,d)
a0[d]=g
if(!(h<s))return A.a(a0,h)
a0[h]=g
b=g+1
p[1]=g
a1.dJ(a0,1)
if(a1.to>=2){g=b
continue}else break}while(!0)
s=--a1.x1
o=p[1]
if(!(s>=0&&s<573))return A.a(p,s)
p[s]=o
a.jn(a1)
A.t1(a0,j,a1.rx)}}
A.kC.prototype={}
A.im.prototype={
gaK(){var s=this.a
if(s==null)return s
s.gP()
return this.a},
jy(){var s,r=this
r.w=r.r=0
if(r.gaK()==null)return
s=r.c
if(!(s instanceof A.bg)){r.d=s
r.c=A.a8(32768)}try{while(!r.gaK().gP()){if(!r.jZ())return
r.fw(32768)}}finally{r.fw(0)
r.c=s
r.d=null}},
fw(a){var s,r,q,p,o=this.d
if(o==null)return
s=t.bl.a(this.c)
r=s.b-a
if(r<(a===0?1:1048576))return
q=s.Z()
o.v(A.Q(q,0,r))
p=A.a8(2097152)
p.v(A.Q(q,r,null))
this.c=p},
jZ(){var s,r,q=this,p=q.gaK()
if(p==null||p.gP())return!1
s=q.aE(3)
r=(s&1)===0
switch(B.a.k(s,1)){case 0:if(q.k9()===-1)return!1
break
case 1:if(q.f1($.q_(),$.pZ())===-1)return!1
break
case 2:if(q.k6()===-1)return!1
break
default:return!1}if(!r)q.f=!0
return r},
aE(a){var s,r,q,p,o=this
if(a===0)return 0
while(s=o.w,s<a){if(o.gaK().gP())return-1
r=o.gaK().G()
s=o.r
q=o.w
o.r=(s|B.a.p(r,q))>>>0
o.w=q+8}q=o.r
p=B.a.q(1,a)
o.r=B.a.ba(q,a)
o.w=s-a
return(q&p-1)>>>0},
dM(a){var s,r,q,p,o,n,m=this,l=a.a
l===$&&A.c()
s=a.b
while(m.w<s){if(m.gaK().gP())break
r=m.gaK().G()
q=m.r
p=m.w
m.r=(q|B.a.p(r,p))>>>0
m.w=p+8}q=m.r
p=(q&B.a.p(1,s)-1)>>>0
if(!(p<l.length))return A.a(l,p)
o=l[p]
n=o>>>16
if(n===0||n>m.w)return-1
m.r=B.a.ba(q,n)
m.w-=n
return o&65535},
k9(){var s,r,q,p=this
p.w=p.r=0
s=p.aE(16)
if(s!==(p.aE(16)^65535)>>>0)return-1
r=p.gaK()
if(s>r.gi(r))return-1
q=p.gaK().K(s)
p.c.b6(q)
return 0},
k6(){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=g.aE(5)
if(f===-1)return-1
f+=257
if(f>286)return-1
s=g.aE(5)
if(s===-1)return-1;++s
if(s>32)return-1
r=g.aE(4)
if(r===-1)return-1
r+=4
if(r>19)return-1
q=new Uint8Array(19)
for(p=0;p<r;++p){o=g.aE(3)
if(o===-1)return-1
n=B.ao[p]
if(!(n<19))return A.a(q,n)
q[n]=o}m=g.h3(q,!0)
if(m==null)return-1
n=f+s
l=new Uint8Array(n)
k=J.ak(B.c.gN(l),0,f)
j=J.ak(B.c.gN(l),f,s)
if(g.jz(n,m,l)===-1)return-1
i=g.h2(k)
n=i==null
h=n?null:g.h2(j)
if(n||h==null)return-1
return g.f1(i,h)},
h3(a,b){var s,r
t.L.a(a)
try{s=A.mh(a,b)
return s}catch(r){if(A.G(r) instanceof A.ay)throw r
else throw r}},
h2(a){return this.h3(a,!1)},
f1(a,b){var s,r,q,p,o,n,m,l,k=this
for(;;){s=k.dM(a)
if(s<0||s>285)return-1
if(s===256)break
if(s<256){k.c.j(s&255)
continue}r=s-257
if(!(r>=0&&r<31))return A.a(B.as,r)
q=k.aE(B.as[r])
if(q<0)return-1
if(!(r<29))return A.a(B.aq,r)
p=B.aq[r]
o=k.dM(b)
if(o<0||o>29)return-1
if(!(o>=0&&o<30))return A.a(B.W,o)
n=k.aE(B.W[o])
if(n<0)return-1
m=B.bW[o]+n
if(m>=1){l=k.c
l=m>l.gi(l)}else l=!0
if(l)return-1
k.c.cU(m,p+q)}while(p=k.w,p>=8){k.w=p-8
k.gaK().i0()}return 0},
jz(a,b,c){var s,r,q,p,o,n,m,l,k=this
for(s=0,r=0;r<a;){q=k.dM(b)
if(q===-1)return-1
p=0
switch(q){case 16:if(r===0)return-1
o=k.aE(2)
if(o===-1)return-1
o+=3
if(r+o>a)return-1
for(n=c.$flags|0;m=o-1,o>0;o=m,r=l){l=r+1
n&2&&A.b(c)
if(!(r>=0&&r<c.length))return A.a(c,r)
c[r]=s}break
case 17:o=k.aE(3)
if(o===-1)return-1
o+=3
if(r+o>a)return-1
for(n=c.$flags|0;m=o-1,o>0;o=m,r=l){l=r+1
n&2&&A.b(c)
if(!(r>=0&&r<c.length))return A.a(c,r)
c[r]=0}s=p
break
case 18:o=k.aE(7)
if(o===-1)return-1
o+=11
if(r+o>a)return-1
for(n=c.$flags|0;m=o-1,o>0;o=m,r=l){l=r+1
n&2&&A.b(c)
if(!(r>=0&&r<c.length))return A.a(c,r)
c[r]=0}s=p
break
default:if(q<0||q>15)return-1
l=r+1
c.$flags&2&&A.b(c)
if(!(r>=0&&r<c.length))return A.a(c,r)
c[r]=q
r=l
s=q
break}}return 0}}
A.e6.prototype={
la(a,b,c,d){var s,r=null
t.L.a(a)
if(b==null){s=A.a8(A.vD(a.length))
B.a7.hA(A.U(a,B.y,r,r),s,!0,!0,!1)
return s.Z()}s=A.a8(b<32768?b:r)
this.eb(A.U(a,B.d,r,r),s,b,!0,!0,!1)
return s.Z()},
eb(a,b,c,d,e,f){return A.eO(b,c,new A.j3(a,!1,!0,!0))},
li(a,b,c,d,e){return this.eb(a,b,c,d,e,!1)},
lg(a,b,c,d){return this.eb(a,b,null,c,d,!1)}}
A.j3.prototype={
$1(a){var s=this
return B.a7.hA(s.a,a,s.c,s.d,s.b)},
$S:5}
A.e9.prototype={
ghN(){var s=this
return!s.r&&s.c===s.e&&s.b===s.w},
cY(a,b,c){var s,r,q,p,o,n,m,l,k=this
if(c>0)s=b+c>a.length
else s=!0
if(s)return!1
s=b+c
r=s-1
q=a.length
if(!(r>=0&&r<q))return A.a(a,r)
p=a[r]
if(p===0)return!1
r=A.al(a)
k.d=r
k.e=b
k.f=s
k.r=!1
if(c>=4){s-=4
k.c=s
k.a=r.getUint32(s,!0)
k.w=32}else{k.c=b
for(o=c-1,n=0;o>=0;--o){s=b+o
if(!(s<q))return A.a(a,s)
n=(n<<8|a[s])>>>0}k.a=B.a.q(n,4-c<<3>>>0)
k.w=c<<3>>>0}if(p>=16){m=p>>>4
l=4}else{m=p
l=0}if(m>=4){m=m>>>2
l+=2}k.b=8-(m>=2?l+1:l)
return!0},
lO(a){return B.a.an(B.a.p(this.a,this.b),32-a)},
aX(a){var s
if(a===0)return 0
s=this.lO(a)
this.b+=a
return s},
es(){var s,r,q=this,p=q.b,o=q.w
if(p>o){q.r=!0
q.b=o
return}o=q.c
s=q.e
if(o===s)return
r=o-B.a.k(p,3)
if(r<s){q.b=p-(o-s<<3>>>0)
q.c=s
p=s}else{q.c=r
q.b=p&7
p=r}q.a=q.d.getUint32(p,!0)}}
A.fL.prototype={
e8(a5,a6,a7,a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=this,a3=B.a.q(1,a9),a4=$.nC()
if(!(a6<3))return A.a(a4,a6)
s=a4[a6]
r=$.nD()[a6]
q=$.nz()
a4=a2.e
p=a2.f
A.nj(a7,a8,a3,a4,p)
for(o=p.$flags|0,n=a2.x,m=n.$flags|0,l=a2.y,k=l.$flags|0,j=a2.z,i=r.length,h=j.$flags|0,g=a2.Q,f=s.length,e=g.$flags|0,d=0;d<a3;++d){if(!(d<512))return A.a(a4,d)
c=a4[d]
if(!(c<53))return A.a(p,c)
b=p[c]
o&2&&A.b(p)
p[c]=b+1
if(!(b>=0&&b<2048))return A.a(q,b)
a=a9-q[b]
a0=a5+d
a1=B.a.p(b,a)
m&2&&A.b(n)
if(!(a0<1440))return A.a(n,a0)
n[a0]=a5+a1-a3
k&2&&A.b(l)
l[a0]=a
if(!(c<i))return A.a(r,c)
a1=r[c]
h&2&&A.b(j)
j[a0]=a1
if(!(c<f))return A.a(s,c)
a1=s[c]
e&2&&A.b(g)
g[a0]=a1}},
aV(){var s=this,r=s.at,q=B.a.k(r,3),p=s.as,o=p-q,n=s.ay
if(o<n){s.at=r-(p-n<<3>>>0)
s.as=n
r=n}else{s.as=o
s.at=r&7
r=o}s.ax=s.ch.getUint32(r,!0)},
aF(a){var s,r,q
if(a===0)return 0
s=this.ax
r=this.at
q=B.a.an(B.a.p(s,r),32-a)
this.at=r+a
return q},
kH(a){var s,r=this
if(a<=24)return r.aF(a)
s=r.aF(a-24)
r.aV()
return s*16777216+r.aF(24)},
i1(b6,b7,b8,b9,c0,c1,c2,c3,c4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=this,a4="Sequences ran past the block",a5=a3.x,a6=a3.y,a7=a3.z,a8=a3.Q,a9=A.al(c1.c),b0=c1.r,b1=c0.c,b2=c1.e+c4,b3=b2+64,b4=b8+b9,b5=b4-1
if(!(b5>=0&&b5<b6.length))return A.a(b6,b5)
s=b6[b5]
if(s===0)throw A.d(A.ah("Bitstream ends in a zero byte"))
if(b9>=4){a3.ay=b8
r=32}else{a3.ay=b4-4
r=b9<<3>>>0}a3.ch=b7
b4-=4
a3.as=b4
a3.ax=b7.getUint32(b4,!0)
a3.at=8-(B.a.gX(s)-1)
b4=a3.a
b5=a3.b
q=b4[0]+a3.aF(b5[0])
a3.aV()
p=b4[1]+a3.aF(b5[1])
a3.aV()
o=b4[2]+a3.aF(b5[2])
n=c2[0]
m=c2[1]
l=c2[2]
k=c1.e
for(b4=a9.$flags|0,b5=b0!==0,j=c3,i=b3;j>0;--j){a3.aV()
if(!(p>=0&&p<1440))return A.a(a8,p)
h=a8[p]+a3.kH(a7[p])
a3.aV()
if(!(o>=0&&o<1440))return A.a(a8,o)
g=a8[o]+a3.aF(a7[o])
a3.aV()
if(!(q>=0&&q<1440))return A.a(a8,q)
f=a8[q]+a3.aF(a7[q])
if(j!==1){a3.aV()
q=a5[q]+a3.aF(a6[q])
a3.aV()
o=a5[o]+a3.aF(a6[o])
a3.aV()
p=a5[p]+a3.aF(a6[p])}if(h>3){e=h-3
l=m
m=n
n=e}else{d=f===0?h+1:h
if(d===1)e=n
else{if(d===2){e=m
c=e}else{if(d===3){e=l
c=e}else{e=n-1
if(e===0)throw A.d(A.ah("Repeat offset underflows"))
c=e}l=m}m=n
n=c}}b=k+f
a=b+g
if(a>b2)throw A.d(A.ah(a4))
A.oC(a9,k,i,f)
i+=f
a0=b-e
if(a0<0){a0+=b0
if(!b5||a0<=b)throw A.d(A.ah("Match offset "+e+" reaches before the start of the output"))
k=A.rU(c1.c,b,a0,g,b0)
continue}if(e>=8){A.oC(a9,b,a0,g)
k=a}else for(k=b;k<a;a0=a1,k=b){b=k+1
a1=a0+1
a2=a9.getUint8(a0)
b4&2&&A.b(a9,9)
a9.setUint8(k,a2)}}if(k>b2||i>b3+b1)throw A.d(A.ah(a4))
if(a3.as!==a3.ay||a3.at!==r)throw A.d(A.ah("Sequence bitstream was not fully consumed"))
b4=k+(b3+b1-i)
if(b4>b2)throw A.d(A.ah("Block output is larger than a block"))
b5=c1.c
B.c.H(b5,k,b4,b5,i)
c2.$flags&2&&A.b(c2)
if(0>=3)return A.a(c2,0)
c2[0]=n
if(1>=3)return A.a(c2,1)
c2[1]=m
if(2>=3)return A.a(c2,2)
c2[2]=l
return b4}}
A.ea.prototype={
W(a,b,c){this.e4(c>=32?b:(b&B.a.p(1,c)-1)>>>0,c)
return},
e4(a,b){var s=this,r=s.d&63
if(r>=32)s.c=(s.c|A.nl(a,r-32))>>>0
else{s.b=(s.b|A.nl(a,r))>>>0
if(r>0)s.c=(s.c|B.a.an(a,32-r))>>>0}s.d+=b
return},
T(){var s,r=this,q=B.a.k(r.d,3),p=r.a,o=r.e,n=r.b
p.$flags&2&&A.b(p,11)
p.setUint32(o,n,!0)
p.setUint32(r.e+4,r.c,!0)
r.e+=q
r.d&=7
s=q<<3&63
if(s>=32){r.b=B.a.an(r.c,s-32)
r.c=0}else if(s>0){r.b=(B.a.bb(r.b,s)|A.nl(r.c,32-s))>>>0
r.c=B.a.bb(r.c,s)}return},
al(){var s,r=this
r.e4(1,1)
r.T()
s=r.e
return s+(r.d>0?1:0)}}
A.jt.prototype={
n(a){return"ZstdBlockException: "+this.a}}
A.jr.prototype={
l7(a,b,c,d,e,f,g,h){var s,r,q,p,o,n,m,l
if(b+3>c)A.tx()
s=a.length
if(!(b<s))return A.a(a,b)
r=a[b]
q=b+1
if(!(q<s))return A.a(a,q)
q=a[q]
p=b+2
if(!(p<s))return A.a(a,p)
o=r|q<<8|a[p]<<16
this.c=(o&1)!==0
n=o>>>1&3
m=o>>>3
c=h+(n===1?1:m)
if(m>f)A.tz(m)
switch(n){case 0:if(h+m>c)A.uy()
d.aY(m)
l=d.e
s=l+m
B.c.H(d.c,l,s,g,h)
d.e=s
return 3+m
case 1:if(h>=c)A.uG()
d.aY(m)
l=d.e
s=d.c
r=l+m
if(!(h<g.length))return A.a(g,h)
B.c.F(s,l,r,g[h])
d.e=r
return 4
case 2:s=h+m
if(s>c)A.tF()
d.aY(f*2+128)
r=this.a
this.b.l6(g,h+r.l5(g,h,s,f,d.c,d.e+f+64),s,r,d,e,f)
return 3+m
default:A.uF()}}}
A.js.prototype={
lQ(a,b,c,d){var s,r,q,p=this,o=null,n=p.b
n.p4=c
n.lP(a,b,c)
s=p.r
if(s!=null)s.ly(a,b,c)
s=p.d
s.em(d)
if(d.e){r=p.a
r.lG(d.r,d.f.b)
q=n.k4
q.cx=r.e?r.a:o
n=s.x
q.cy=n.e?n.a:o
n=s.y
q.db=n.e?n.a:o
n=s.z
q.dx=n.e?n.a:o}},
bm(a){var s=this.b,r=s.b,q=s.c
if(s.a.a>=4){A.jT(r,a)
A.jT(q,a)}else{A.cf(r,a)
A.cf(q,a)}A.cf(s.cx,a)
A.cf(s.ch,a)
r=s.p2
s.p2=r>a?r-a:0
r=s.CW
s.CW=r>a?r-a:0
r=s.p4
s.p4=r>a?r-a:0
r=s.R8
s.R8=r>a?r-a:0
s=this.r
if(s!=null)s.bm(a)},
cC(a2,a3,a4,a5,a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this,a1=a0.at
a0.at=!1
if(!a1)a0.d.y.e=!1
s=a4-a3
r=s>0
if(r){q=a8[0]
p=a8[1]
o=a8[2]
n=a0.r
m=a0.w
l=a0.ax
if(n!=null&&m!=null){n.ig(a2,A.al(a2),a3,a4,m)
a0.b.p1=m}else if(l!=null)a0.b.p1=l
k=a0.b
j=a0.c
j.r=j.e=0
k.rx=!1
i=k.p2
if(i<a5)i=k.p2=a5
if(a3>i+384){h=a3-i-384
k.p2=a3-(h<192?h:192)}g=A.al(a2)
i=k.p4
f=i>a5
k.RG=f
e=k.a
d=e.a
if(d===5){if(e.r>=3&&k.k4.f===0&&!f&&a3===i){i=k.fx
f=a8[0]
i.$flags&2&&A.b(i)
i[0]=f
i[1]=a8[1]
i[2]=a8[2]
k.fJ(a2,g,a3,a4,a5,j,i)
j.r=j.e=0
k.a0()}k.fJ(a2,g,a3,a4,a5,j,a8)}else if(d===0)if(k.fP(a4,a5))k.k8(a2,g,a3,a4,a5,j,a8)
else k.k7(a2,g,a3,a4,a5,j,a8)
else if(d===1)if(k.fP(a4,a5))k.k5(a2,g,a3,a4,a5,j,a8)
else k.k0(a2,g,a3,a4,a5,j,a8)
else k.k_(a2,g,a3,a4,a5,j,a8,d===4)
if(l!=null)l.ik(s)
if(a0.x){c=a0.e.lk(a0.f,j,a0.a,a0.d)
if(c>0){a0.kR(a2,a3,s,a6,a7,a8,a1,c,q,p,o)
return}}b=j.e
a=a0.eX(a2,a3,s,0,j.r,0,b,a1)
if(a===1){a8.$flags&2&&A.b(a8)
a8[0]=q
a8[1]=p
a8[2]=o
A.eb(a6,a7,1,s)
if(!(a3>=0&&a3<a2.length))return A.a(a2,a3)
a6.j(a2[a3])
return}if(a>0){A.eb(a6,a7,2,a)
a6.aq(a0.f,0,a)
a0.d.aG()
a0.a.aG()
return}a8.$flags&2&&A.b(a8)
a8[0]=q
a8[1]=p
a8[2]=o}A.eb(a6,a7,0,s)
if(r)a6.aq(a2,a3,a4)},
kR(a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=this,a4=a3.y
a4.$flags&2&&A.b(a4)
a4[0]=b3
a4[1]=b4
a4[2]=b5
s=a3.z
B.f.ab(s,0,a4)
for(r=a3.Q,q=a3.c,p=a3.e.a,o=a5.length,n=a3.f,m=a3.d,l=m.x,k=m.y,m=m.z,j=a3.a,i=a6,h=0,g=0,f=0;f<=b2;++f,g=e){if(!(f<198))return A.a(p,f)
e=p[f]
d=q.cM(0,g)
c=q.cM(g,e)
b=e===q.r?q.e:d+c
a=c+q.lK(g,e)
h+=a
a0=f===b2
if(a0)a+=a7-h
B.f.ab(r,0,a4)
A.w4(a4,s,q,g,e)
a1=a3.eX(a5,i,a,g,e,d,b,b1)
a2=a0&&a9
if(a1>1){A.eb(a8,a2,2,a1)
a8.aq(n,0,a1)
l.aG()
k.aG()
m.aG()
j.aG()}else{if(a1===1){A.eb(a8,a2,1,a)
if(!(i>=0&&i<o))return A.a(a5,i)
a8.j(a5[i])}else{A.eb(a8,a2,0,a)
a8.aq(a5,i,i+a)}B.f.ab(a4,0,r)}i+=a}s=a4[0]
b0.$flags&2&&A.b(b0)
if(0>=3)return A.a(b0,0)
b0[0]=s
s=a4[1]
if(1>=3)return A.a(b0,1)
b0[1]=s
a4=a4[2]
if(2>=3)return A.a(b0,2)
b0[2]=a4},
eX(a,b,c,d,e,f,g,h){var s=this,r=e-d,q=r===0||B.a.a2(g-f,r)>=20,p=s.f,o=s.c,n=s.a.lp(p,0,o.a,f,g,q),m=n+s.d.lo(p,n,o,d,e)
if(m>=c-(B.a.k(c,s.as)+2))m=0
if(!h&&m<25&&c>1&&A.rK(a,b,b+c))return 1
return m}}
A.ju.prototype={
eE(a,b,c,d,e,f){var s,r,q=c<d?c:d
if(q<131072||f<3)return q
s=e.a
if(!(s<6))return A.a(B.ah,s)
r=B.ah[s]
if(s===3&&e.r>1)r=3
return r===0?this.jm(a,b,q):this.iG(a,b,q,r-1)},
jm(a,b,c){var s,r,q,p,o,n,m=this,l=m.a
m.bR(a,b,512,l,1,8)
m.d=512
s=m.b
m.bR(a,b+c-512,512,s,1,8)
m.e=512
if(!m.fd(0,8))return c
r=B.a.k(c,1)
q=m.c
m.bR(a,b+r-256,512,q,1,8)
p=m.dk(l,m.d,q,512,8)
o=m.dk(s,m.e,q,512,8)
n=p-o
if((n<0?-n:n)<87381)return r
return p>o?B.a.k(c,2):c-B.a.k(c,2)},
iG(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this
if(!(d>=0&&d<4))return A.a(B.ac,d)
s=B.ac[d]
r=B.bt[d]
q=f.a
f.bR(a,b,8191,q,s,r)
p=B.a.a2(8191,s)
f.d=p
for(o=c-8192,n=f.b,m=q.$flags|0,l=3,k=8192;k<=o;k+=8192){f.bR(a,b+k,8191,n,s,r)
f.e=p
if(f.fd(l,r))return k
for(j=B.a.q(1,r),i=0;i<j;++i){if(!(i<1024))return A.a(q,i)
h=q[i]
g=n[i]
m&2&&A.b(q)
q[i]=h+g}f.d=f.d+f.e
if(l>0)--l}return c},
bR(a,b,c,d,e,f){var s,r,q,p,o,n
B.f.F(d,0,B.a.q(1,f),0)
if(f===8){for(s=a.length,r=d.$flags|0,q=0;q<c;q+=e){p=b+q
if(!(p>=0&&p<s))return A.a(a,p)
p=a[p]
if(!(p<1024))return A.a(d,p)
o=d[p]
r&2&&A.b(d)
if(!(p<1024))return A.a(d,p)
d[p]=o+1}return}n=32-f
for(s=a.length,r=d.$flags|0,q=0;q<c;q+=e){p=b+q
if(!(p>=0&&p<s))return A.a(a,p)
o=a[p];++p
if(!(p<s))return A.a(a,p)
p=B.a.an(((o|a[p]<<8)>>>0)*2654435769>>>0,n)
if(!(p<1024))return A.a(d,p)
o=d[p]
r&2&&A.b(d)
if(!(p<1024))return A.a(d,p)
d[p]=o+1}},
fd(a,b){var s=this
return s.dk(s.a,s.d,s.b,s.e,b)>=B.a.t(s.d*s.e*(14+a),16)},
dk(a,b,c,d,e){var s,r,q,p
for(s=B.a.q(1,e),r=0,q=0;q<s;++q){if(!(q<1024))return A.a(a,q)
p=a[q]*d-c[q]*b
r+=p<0?-p:p}return r}}
A.ed.prototype={
gbZ(){var s=this.at
if(s===$)s=this.at=new A.bQ(this.a,new Uint8Array(65536),B.d)
return s},
gck(){var s,r=this,q=r.ax
if(q===$){r.gce()
s=A.ni(r.y,r.as)
r.ax!==$&&A.bC()
q=r.ax=s}return q},
gbT(){var s,r=this,q=r.ay
if(q===$){s=B.a.q(1,r.gck().b)
r.ay!==$&&A.bC()
r.ay=s
q=s}return q},
gha(){var s,r,q,p=this,o=p.ch
if(o===$){s=p.as
if(s<1)r=1
else{q=p.gbT()
s=s<q?s:q
r=s}p.ch!==$&&A.bC()
o=p.ch=r}return o},
gbO(){var s,r=this,q=r.CW
if(q===$){s=r.gha()
s=s<131072?s:131072
r.CW!==$&&A.bC()
q=r.CW=s}return q},
gbP(){var s,r=this,q=r.cx
if(q===$){s=A.or(r.gbO(),r.gck())
r.cx!==$&&A.bC()
r.cx=s
q=s}return q},
gd5(){var s,r,q,p,o,n=this,m=n.dy
if(m===$){s=n.gbP().b
r=s.geF()
q=n.gbT()
if(r<q)r=q
n.gce()
p=n.gbO()
s=s.gd_()
o=new Uint8Array(q+r+p+s)
n.dy!==$&&A.bC()
n.dy=o
m=o}return m},
gce(){return null},
kc(){return},
bH(){var s=this,r=s.as,q=s.k1,p=s.e,o=s.d
if(q+(p-o)>r)throw A.d(A.p("Input is longer than contentSize "+r))
q=s.gbO()
if(r===q)return
while(s.e-s.d>=q){s.fo(q)
s.fg(!1)}},
bf(){var s=this,r=s.as,q=s.k1,p=s.e-s.d
if(q+p!==r)throw A.d(A.p("Input is "+(q+s.gl_())+" bytes, contentSize is "+r))
if(!s.id&&q===0&&p===0){s.id=!0
q=s.gbZ()
s.gce()
A.vZ(q,!0,s.y,0,!0)}else s.hd()
q=s.e-s.d
if(q>0)s.fo(q)
s.fg(!0)
q=s.gbZ()
A.vg(q,s.dx.bS().b)
q.aT()},
fo(a){var s,r,q,p,o,n,m,l=this
l.kc()
s=l.fx
r=l.gd5()
if(s+a>r.length){s=l.fr
q=l.gbT()
p=s>q?l.fr-q:0
s=l.gbP()
p-=B.a.E(p,s.b.gd_())
if(p>0){B.c.H(r,0,l.fx-p,r,p)
l.fr-=p
l.fx-=p
q=l.fy
l.fy=q>p?q-p:0
s.bm(p)}}s=l.k1
if(s>0){o=l.k2
if(o===$){q=l.gha()
n=l.gbO()
l.k2!==$&&A.bC()
o=l.k2=q+n}s=B.a.E(s,o)===0}else s=!1
if(s){s=l.gbP().b
s.p2=s.p4=l.fx}s=l.b
q=l.d
m=A.Q(s,q,q+a)
q=l.fx
B.c.V(r,q,q+a,m)
l.dx.ag(r,l.fx,a)
l.fx+=a
l.k1+=a
l.a5(0,a)},
fg(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=this
g.hd()
s=g.fx-g.fr
if(s===0){if(a){r=g.gbP()
q=g.gd5()
p=g.fr
r.cC(q,p,p,g.fy,g.gbZ(),!0,g.db)}return}for(r=g.db,q=g.cy;s>0;){p=g.gd5()
o=q.eE(p,g.fr,s,g.gbO(),g.gck(),g.go)
n=g.gbP()
m=n.b
l=m.R8
if(l!==0&&g.fr+o-l>g.gbT())m.R8=0
k=m.R8!==0?g.fy:g.fr-g.gbT()
m=g.gbZ()
j=m.c
l=g.fr
i=g.fy
if(k>i)i=k
h=a&&o===s
n.cC(p,l,l+o,i,m,h,r)
g.go=g.go+(o-(m.c-j))
g.fr+=o
s-=o}},
hd(){var s,r,q,p=this
if(p.id)return
p.id=!0
s=p.as
r=p.gbZ()
q=p.gck().b
p.gce()
A.ou(r,s,s<=B.a.q(1,q),!0,q,0)
return}}
A.mB.prototype={}
A.jA.prototype={
n(a){return"ZstdFrameException: "+this.a}}
A.jB.prototype={}
A.jy.prototype={
l8(a1,a2,a3,a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this.a,a0=a.a
a0.w=!1
a0.c=0
s=a.b
r=s.c
r.$flags&2&&A.b(r)
r[0]=0
r[1]=0
r[2]=0
a.c=!1
r=a5==null
if(!r&&a5.e){q=a0.d
p=a5.f
B.j.ab(q.a,0,p.a)
q.b=p.b
a0.w=!0
s.em(a5)}a0=this.b
s=r?null:a5.d
B.f.ab(a0,0,s==null?$.m4():s)
o=a3.b
s=o<131072
n=s?o:131072
m=(s?o:131072)*2+128
a2.x=m
l=a2.gi(0)
k=a3.c
s=a6.length
if(0>=s)return A.a(a6,0)
if(1>=s)return A.a(a6,1)
j=a2.b
r=k!=null
for(;;){A.mC(a1,a6,0,3,"Block header is truncated")
q=a6[0]
p=a6[1]
if(2>=s)return A.a(a6,2)
i=q|p<<8|a6[2]<<16
h=i>>>3
g=(i>>>1&3)===1?1:h
if(h>n)throw A.d(A.ap("Block of "+h+" bytes is above the "+n+" its frame allows"))
f=a1.c5(g)
if(f==null){A.mC(a1,a6,3,g,"Block is truncated")
f=a6
e=3}else e=0
a2.aY(m)
d=a2.e
a.l7(a6,0,3,a2,a0,n,f,e)
q=a2.f
p=a2.e
c=a2.w
b=q+p-c-l
if(r&&b>k){a2.e=d
if(r&&b!==k)A.j(A.ap("Frame produced "+b+" bytes against the "+A.r(k)+" it declared"))
q=d}else q=p
if(a2.z){d=a2.y
d=d>c?d:c
if(q>d)a2.dv(j,d,q)
a2.y=a2.e}if(a.c)break}A.rL(a2.gi(0)-l,a3)
if(a3.e){A.mC(a1,a6,0,4,"Content checksum is truncated")
if(2>=s)return A.a(a6,2)
if(3>=s)return A.a(a6,3)}}}
A.jz.prototype={
lt(a,b,c,d,e,f){var s=a.c5(b)
if(s!=null){this.hb(null,s,0,b,c,!1,e,f)
return}this.hb(a,null,0,b,c,!1,e,f)},
hb(b9,c0,c1,c2,c3,c4,c5,c6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4=null,b5=c5==null,b6=!b5&&c5.c>=8&&c5.b.length!==0?c5:b4,b7=b6==null,b8=b7?b4:b6.b.length
if(b8==null)b8=0
b5=b5?b4:c5.c
s=A.ni(c6,c2+(b5==null?0:b5))
b5=s.b
r=B.a.q(1,b5)
q=c2<=r
p=q?c2:r
o=c3.gi(c3)
n=b7?b4:b6.a
A.ou(c3,c2,q,!1,b5,n==null?0:n)
m=p<131072?p:131072
l=A.or(m,s)
b5=l.b
k=b5.gd_()
j=b5.geF()
if(j<r)j=r
n=c0==null
i=!n
if(!i||!b7){h=n&&r+j+m+k<c2?r+j+m+k:c2
g=new Uint8Array(b8+h)
if(!b7)B.c.V(g,0,b8,b6.b)
if(i)B.c.H(g,b8,b8+c2,c0,c1)
f=b8
e=g}else{f=c1
e=c0}d=f-b8
i=this.b
c=b7?b4:b6.d
B.f.ab(i,0,c==null?$.m4():c)
if(!b7)l.lQ(e,d,f,b6)
if(c2===0)l.cC(e,f,f,d,c3,!0,i)
b=n?f:f+c2
a=n?0:c2
for(b7=this.c,n=e.length,c=l.r,a0=0,a1=0;a1<c2;f=b1){if(b-f<m&&a<c2){if(b===n){a2=f>r?f-r:0
a2-=B.a.E(a2,k)
b-=a2
B.c.H(e,0,b,e,a2)
f-=a2
d=d>a2?d-a2:0
b5.bm(a2)
if(c!=null)c.bm(a2)}a3=n-b
a4=c2-a
if(a3>a4)a3=a4
for(a5=0;a5<a3;){a6=b9.az(e,b+a5,a3-a5)
if(a6<=0)throw A.d(A.p("zstd: the input ended "+a3+" bytes early"))
a5+=a6}b+=a3
a+=a3}a7=b7.eE(e,f,c2-a1,m,s,a0)
a8=b5.R8
a9=(a8!==0&&f+a7-a8>r?b5.R8=0:a8)!==0?d:f-r
b0=c3.gi(c3)
b1=f+a7
a8=a9>d?a9:d
a1+=a7
l.cC(e,f,b1,a8,c3,a1===c2,i)
a0+=a7-(c3.gi(c3)-b0)
if(a1===a7&&a1<c2){b2=c2+B.a.k(c2,7)+64
b3=c3.gi(c3)-o
a3=b3+B.a.a2(b3*(c2-a1),a1)
a3+=B.a.k(a3,3)
c3.aY(o+(a3<b2?a3:b2))}}}}
A.jG.prototype={}
A.jD.prototype={}
A.jF.prototype={
n(a){return"ZstdFseException: "+this.a}}
A.jE.prototype={
n(a){return"ZstdFseEncoderException: "+this.a}}
A.jC.prototype={
bt(a1,a2,a3,a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=B.a.p(1,a3)
a.c=a3
a.d=a2
a6.$flags&2&&A.b(a6)
s=a6.length
if(0>=s)return A.a(a6,0)
a6[0]=0
for(r=a2+1,q=a6.$flags|0,p=a1.length,o=1;o<=r;++o){n=o-1
if(!(n<p))return A.a(a1,n)
m=a1[n]
if(!(n<s))return A.a(a6,n)
n=a6[n]
l=m===-1?1:m
q&2&&A.b(a6)
if(!(o<s))return A.a(a6,o)
a6[o]=n+l}A.nj(a1,a2,a0,a4,a5)
for(r=a4.length,q=a.a,n=a6.$flags|0,l=q.$flags|0,k=0;k<a0;++k){if(!(k<r))return A.a(a4,k)
j=a4[k]
if(!(j<s))return A.a(a6,j)
i=a6[j]
n&2&&A.b(a6)
a6[j]=i+1
l&2&&A.b(q)
if(!(i>=0&&i<q.length))return A.a(q,i)
q[i]=a0+k}for(h=a.b,s=h.$flags|0,g=(a3<<16>>>0)-a0,f=(a3+1<<16>>>0)-a0,e=0,o=0;o<=a2;++o){if(!(o<p))return A.a(a1,o)
m=a1[o]
if(m===0){d=f
c=0}else if(m===-1||m===1){c=e-1;++e
d=g}else{b=a3-(B.a.gX(m-1)-1)
d=(b<<16>>>0)-B.a.p(m,b)
c=e-m
e+=m}r=o*2
s&2&&A.b(h)
q=h.length
if(!(r<q))return A.a(h,r)
h[r]=d;++r
if(!(r<q))return A.a(h,r)
h[r]=c}},
bh(a){var s,r,q,p,o=this.b,n=a*2,m=o.length
if(!(n>=0&&n<m))return A.a(o,n)
s=o[n]
r=B.a.k(s+32768,16)
q=this.a
p=B.a.k((r<<16>>>0)-s,r);++n
if(!(n<m))return A.a(o,n)
n=p+o[n]
if(!(n>=0&&n<q.length))return A.a(q,n)
return q[n]},
aM(a,b,c){var s,r,q,p=this.b,o=c*2,n=p.length
if(!(o>=0&&o<n))return A.a(p,o)
s=B.a.k(b+p[o],16)&63
a.W(0,b,s)
r=this.a
q=B.a.ba(b,s);++o
if(!(o<n))return A.a(p,o)
o=q+p[o]
if(!(o>=0&&o<r.length))return A.a(r,o)
return r[o]}}
A.jL.prototype={}
A.jJ.prototype={
n(a){return"ZstdHuffmanException: "+this.a}}
A.jK.prototype={}
A.jI.prototype={
n(a){return"ZstdHuffmanEncoderException: "+this.a}}
A.jH.prototype={
ht(a,b){var s,r,q,p,o,n,m,l,k=this
k.r=0
for(s=0,r=0;r<256;++r)if(a[r]!==0){++s
k.r=r}if(s<2)return!1
if(k.c)q=k.ks(a,s)
else{p=B.a.gX(b-1)-1-1
q=p>=0&&p<11?p:11
o=B.a.gX(b)-1+1
n=B.a.gX(k.r)-1+2
m=o<n?o:n
if(m>q)q=m
if(q<5)q=5}k.h_(a)
l=s-1
k.f=k.fE(l,q,k.hi(l))
k.eO(l)
return!0},
ks(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=B.a.gX(b)-1+1
for(s=g.b,r=b-1,q=g.d,p=f,o=4611686018427388e3,n=11;p<=11;++p){g.h_(a)
m=g.fE(r,p,g.hi(r))
if(m<p&&p>f)break
g.f=m
g.eO(r)
l=g.ez(q,0)
if(l<0)continue
for(k=g.r,j=0,i=0;i<=k;++i){if(!(i<256))return A.a(s,i)
j+=s[i]*a[i]}h=B.a.k(j,3)+l
if(h>o+1)break
if(h<o){n=p
o=h}}return n},
h_(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=f.Q
B.f.F(e,0,192,0)
for(s=0;s<=f.r;++s){if(!(s<256))return A.a(a,s)
r=a[s]
if(r!==0){q=r<165?r:A.db(r)+158
if(!(q>=0&&q<192))return A.a(e,q)
p=e[q]
e.$flags&2&&A.b(e)
e[q]=p+1}}for(q=e.$flags|0,p=f.as,o=p.$flags|0,n=191;n>0;n=l){m=e[n]
l=n-1
k=e[l]
q&2&&A.b(e)
e[l]=k+m
o&2&&A.b(p)
p[n]=m}for(q=f.w,k=q.$flags|0,j=f.z,i=j.$flags|0,s=0;s<=f.r;++s){if(!(s<256))return A.a(a,s)
r=a[s]
if(r!==0){h=(r<165?r:A.db(r)+158)+1
if(!(h>=0&&h<192))return A.a(p,h)
g=p[h]
o&2&&A.b(p)
p[h]=g+1
k&2&&A.b(q)
if(!(g<514))return A.a(q,g)
q[g]=r
i&2&&A.b(j)
j[g]=s}}for(n=165;n<191;++n){q=p[n]
o=e[n]
if(q-o>1)f.dL(o,q-1)}},
dL(a,b){var s,r,q,p,o,n=this
if(b-a<8){n.jF(a,b)
return}for(s=b,r=a;r<s;){q=n.ka(r,s)
p=q-1
o=q+1
if(q-r<s-q){n.dL(r,p)
r=o}else{n.dL(o,s)
s=p}}},
jF(a,b){var s,r,q,p,o,n,m,l,k,j
for(s=a+1,r=this.w,q=r.$flags|0,p=this.z,o=p.$flags|0;s<=b;++s){if(!(s>=0&&s<514))return A.a(r,s)
n=r[s]
m=p[s]
l=s
for(;;){if(l>a){k=l-1
if(!(k>=0))return A.a(r,k)
k=r[k]<n}else k=!1
if(!k)break
j=l-1
if(!(j>=0))return A.a(r,j)
k=r[j]
q&2&&A.b(r)
if(!(l>=0))return A.a(r,l)
r[l]=k
k=p[j]
o&2&&A.b(p)
p[l]=k
l=j}q&2&&A.b(r)
if(!(l>=0))return A.a(r,l)
r[l]=n
o&2&&A.b(p)
p[l]=m}},
ka(a,b){var s,r,q,p=this.w
if(!(b>=0&&b<514))return A.a(p,b)
s=p[b]
r=a-1
for(q=a;q<b;++q){if(!(q>=0))return A.a(p,q)
if(p[q]>s){++r
this.h1(r,q)}}p=r+1
this.h1(p,b)
return p},
h1(a,b){var s,r,q,p,o=this.w
if(!(a>=0&&a<514))return A.a(o,a)
s=o[a]
r=this.z
q=r[a]
if(!(b>=0&&b<514))return A.a(o,b)
p=o[b]
o.$flags&2&&A.b(o)
o[a]=p
p=r[b]
r.$flags&2&&A.b(r)
r[a]=p
o[b]=s
r[b]=q},
hi(a){var s,r,q,p,o,n,m,l,k,j=257+a-1,i=this.w
if(!(a>=0&&a<514))return A.a(i,a)
s=i[a]
r=a-1
if(!(r>=0))return A.a(i,r)
q=i[r]
i.$flags&2&&A.b(i)
i[257]=s+q
q=this.x
q.$flags&2&&A.b(q)
q[a]=257
q[r]=257
p=a-2
for(o=258;o<=j;++o){if(!(o<514))return A.a(i,o)
i[o]=1073741824}for(n=258,m=257;n<=j;){if(p>=0){s=i[p]
if(!(m<514))return A.a(i,m)
s=s<i[m]}else s=!1
l=s?p:m
if(l===p)--p
else ++m
if(p>=0){s=i[p]
if(!(m<514))return A.a(i,m)
s=s<i[m]}else s=!1
k=s?p:m
if(k===p)--p
else ++m
if(!(l>=0&&l<514))return A.a(i,l)
s=i[l]
if(!(k>=0&&k<514))return A.a(i,k)
r=i[k]
if(!(n<514))return A.a(i,n)
i[n]=s+r
q[l]=n
q[k]=n;++n}i=this.y
i.$flags&2&&A.b(i)
if(!(j>=0&&j<514))return A.a(i,j)
i[j]=0
for(o=j-1;o>=257;--o){s=q[o]
if(!(s<514))return A.a(i,s)
i[o]=i[s]+1}for(o=0;o<=a;++o){s=q[o]
if(!(s<514))return A.a(i,s)
i[o]=i[s]+1}return j},
fE(a0,a1,a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this.y
if(!(a0>=0&&a0<514))return A.a(a,a0)
s=a[a0]
if(s<=a1)return s
r=s-a1
q=B.a.p(1,r)
p=a.$flags|0
o=a0
n=0
for(;;){if(!(o>=0))return A.a(a,o)
m=a[o]
if(!(m>a1))break
n+=q-B.a.p(1,s-m)
p&2&&A.b(a)
a[o]=a1;--o}for(;;){if(!(o>=0&&a[o]===a1))break;--o}n=B.a.aJ(n,r)
for(r=this.at,m=r.$flags|0,l=0;l<14;++l){m&2&&A.b(r)
r[l]=4294967295}for(k=o,j=a1;k>=0;--k){i=a[k]
if(i>=j)continue
h=a1-i
m&2&&A.b(r)
if(!(h>=0&&h<14))return A.a(r,h)
r[h]=k
j=i}for(h=this.w;n>0;){g=B.a.gX(n)-1+1
for(;g>1;g=e){if(!(g<14))return A.a(r,g)
f=r[g]
e=g-1
d=r[e]
if(f===4294967295)continue
if(d===4294967295)break
if(!(f>=0&&f<514))return A.a(h,f)
c=h[f]
if(!(d>=0&&d<514))return A.a(h,d)
if(c<=2*h[d])break}for(;;){if(g<14){if(!(g>=0))return A.a(r,g)
c=r[g]===4294967295}else c=!1
if(!c)break;++g}if(g>=14)throw A.d(new A.jI("No rank left to widen",null,null))
c=g-1
n-=B.a.p(1,c)
if(!(g>=0))return A.a(r,g)
k=r[g]
if(!(k>=0&&k<514))return A.a(a,k)
b=a[k]
p&2&&A.b(a)
a[k]=b+1
if(!(c>=0))return A.a(r,c)
if(r[c]===4294967295){m&2&&A.b(r)
r[c]=k}if(k===0){m&2&&A.b(r)
r[g]=4294967295}else{c=k-1
m&2&&A.b(r)
r[g]=c
if(!(c>=0))return A.a(a,c)
if(a[c]!==a1-g)r[g]=4294967295}}while(n<0){h=r[1]
if(h===4294967295){for(;;){if(!(o>=0&&o<514))return A.a(a,o)
if(!(a[o]===a1))break;--o}h=o+1
if(!(h<514))return A.a(a,h)
c=a[h]
p&2&&A.b(a)
a[h]=c-1
m&2&&A.b(r)
r[1]=h;++n
continue}++h
if(!(h>=0&&h<514))return A.a(a,h)
c=a[h]
p&2&&A.b(a)
a[h]=c-1
c=r[1]
m&2&&A.b(r)
r[1]=c+1;++n}return a1},
eO(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this
for(s=a0.f,r=a0.ax,q=r.$flags|0,p=0;p<=s;++p){q&2&&A.b(r)
if(!(p<12))return A.a(r,p)
r[p]=0}for(o=a0.y,n=0;n<=a1;++n){if(!(n<514))return A.a(o,n)
m=o[n]
if(!(m>=0&&m<12))return A.a(r,m)
l=r[m]
q&2&&A.b(r)
r[m]=l+1}for(q=a0.ay,m=q.$flags|0,k=0;s>0;--s){m&2&&A.b(q)
if(!(s<12))return A.a(q,s)
q[s]=k
k=k+r[s]>>>1}for(r=a0.b,l=r.$flags|0,j=a0.a,i=j.$flags|0,h=a0.e,g=h.$flags|0,f=0;f<256;++f){l&2&&A.b(r)
r[f]=0
i&2&&A.b(j)
j[f]=0
g&2&&A.b(h)
h[f]=0}for(e=a0.z,s=0;s<=a1;++s){if(!(s<514))return A.a(e,s)
d=e[s]
c=o[s]
l&2&&A.b(r)
if(!(d<256))return A.a(r,d)
r[d]=c}for(o=a0.r,f=0;f<=o;++f){if(!(f<256))return A.a(r,f)
b=r[f]
if(b!==0){if(!(b>=0&&b<12))return A.a(q,b)
a=q[b]
m&2&&A.b(q)
q[b]=a+1
i&2&&A.b(j)
j[f]=a
g&2&&A.b(h)
h[f]=(a|b<<16)>>>0}}},
lH(a,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this
b.f=a0
s=a.length
b.r=s-1
for(r=b.b,q=r.$flags|0,p=b.a,o=p.$flags|0,n=b.e,m=n.$flags|0,l=0;l<256;++l){q&2&&A.b(r)
r[l]=0
o&2&&A.b(p)
p[l]=0
m&2&&A.b(n)
n[l]=0}k=b.ax
B.j.F(k,0,12,0)
for(j=a0+1,i=k.$flags|0,l=0;l<s;++l){h=a[l]
if(h!==0){g=j-h
q&2&&A.b(r)
if(!(l<256))return A.a(r,l)
r[l]=g
if(!(g>=0&&g<12))return A.a(k,g)
f=k[g]
i&2&&A.b(k)
k[g]=f+1}}for(q=b.ay,j=q.$flags|0,e=a0,d=0;e>0;--e){j&2&&A.b(q)
if(!(e<12))return A.a(q,e)
q[e]=d
d=d+k[e]>>>1}for(l=0;l<s;++l){if(!(l<256))return A.a(r,l)
g=r[l]
if(g!==0){if(!(g>=0&&g<12))return A.a(q,g)
c=q[g]
j&2&&A.b(q)
q[g]=c+1
o&2&&A.b(p)
p[l]=c
m&2&&A.b(n)
n[l]=(c|g<<16)>>>0}}},
ez(a,b){var s,r,q,p,o,n,m,l,k=this,j=k.r,i=new Uint8Array(j)
for(s=k.f+1,r=k.b,q=0;q<j;++q){if(!(q<256))return A.a(r,q)
p=r[q]
p=p===0?0:s-p
if(!(q<j))return A.a(i,q)
i[q]=p}s=b+1
o=k.iR(a,s,i)
if(o>1&&o<B.a.t(k.r,2)){a.$flags&2&&A.b(a)
if(!(b<a.length))return A.a(a,b)
a[b]=o
return o+1}r=k.r
if(r>128)return-1
a.$flags&2&&A.b(a)
p=a.length
if(!(b<p))return A.a(a,b)
a[b]=128+r-1
for(q=0;q<r;q+=2){n=q+1
if(n<r){if(!(n<j))return A.a(i,n)
m=i[n]}else m=0
n=s+(q>>>1)
if(!(q<j))return A.a(i,q)
l=i[q]
if(!(n<p))return A.a(a,n)
a[n]=(l<<4|m)>>>0}return B.a.k(r+1,1)+1},
iR(a,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=a1.length
if(b<=2)return 0
s=new Uint32Array(13)
for(r=0,q=0;q<b;++q){p=a1[q]
if(!(p>=0&&p<13))return A.a(s,p)
s[p]=s[p]+1
if(p>r)r=p}for(o=0,p=0;p<=r;++p){if(!(p<13))return A.a(s,p)
n=s[p]
if(n>o)o=n}if(o===b||o===1)return 0
m=A.nh(6,b,r)
l=r+1
k=new Int16Array(l)
if(!A.ng(k,s,b,r,m,!1))return 0
j=A.lZ(a,a0,k,r,m)
i=A.cS(m,l)
h=B.a.p(1,m)
h=new Uint8Array(h)
l=new Uint16Array(l)
i.bt(k,r,m,h,l,new Uint32Array(r+2))
g=new A.ea(A.al(a),a0+j)
f=b-1
e=f-1
if((b&1)!==0){d=i.bh(a1[f])
c=i.bh(a1[e])
f=e-1
d=i.aM(g,d,a1[f])
g.T()}else{c=i.bh(a1[f])
d=i.bh(a1[e])
f=e}if((b-2&2)!==0){--f
if(!(f>=0))return A.a(a1,f)
c=i.aM(g,c,a1[f]);--f
if(!(f>=0))return A.a(a1,f)
d=i.aM(g,d,a1[f])
g.T()}while(f>0){--f
c=i.aM(g,c,a1[f]);--f
if(!(f>=0))return A.a(a1,f)
d=i.aM(g,d,a1[f]);--f
if(!(f>=0))return A.a(a1,f)
c=i.aM(g,c,a1[f]);--f
if(!(f>=0))return A.a(a1,f)
d=i.aM(g,d,a1[f])
g.T()}g.W(0,c,m)
g.T()
g.W(0,d,m)
g.T()
return g.al()-a0},
hF(a,b,c,d,e){var s,r,q,p,o,n,m,l,k=e-d
if(k<256||this.ch)return this.fh(a,b,c,d,e)
s=B.a.k(k+3,2)
r=b+6
for(q=0;q<4;++q){p=d+q*s
o=this.fh(a,r,c,p,q===3?e:p+s)
if(o>0)n=q<3&&o>65535
else n=!0
if(n)return-1
if(q<3){n=b+q*2
a.$flags&2&&A.b(a)
m=a.length
if(!(n>=0&&n<m))return A.a(a,n)
a[n]=o&255;++n
l=B.a.k(o,8)
if(!(n<m))return A.a(a,n)
a[n]=l&255}r+=o}return r-b},
fh(a,b,c,d,e){var s,r,q,p,o,n,m=new A.ea(A.al(a),b)
for(s=this.e,r=c.length,q=e;q>d;){p=0
for(;;){if(!(p<4&&q>d))break;--q
if(!(q>=0&&q<r))return A.a(c,q)
o=c[q]
if(!(o<256))return A.a(s,o)
n=s[o]
m.e4(n&65535,n>>>16);++p}m.T()}return m.al()-b}}
A.jN.prototype={
ik(a){var s,r,q,p=this,o=p.f+a,n=p.a,m=n.length,l=p.b,k=l.length
for(;;){if(!(o!==0&&p.e<p.d))break
s=p.e
if(!(s<m))return A.a(n,s)
r=n[s]
if(!(s<k))return A.a(l,s)
q=r+l[s]
if(o>=q){o-=q
p.e=s+1}else{p.f=o
return}}p.f=0}}
A.jV.prototype={
hX(a,b,c,d,e,f){var s,r,q=this,p=q.a
if(p!=null){s=p.d
s=s===0||q.b>=s}else s=!0
if(s)return c
s=q.e
if(d>=s){if(d>s)q.cs(p,d-s)
q.h4(p,d,e)}if(d<q.d||d>=q.e)return c
r=q.e-d
if(r<f)return c
if(c!==0){s=c-1
if(!(s>=0&&s<4096))return A.a(a,s)
s=r>a[s]&&c<4096}else s=!0
if(s){a.$flags&2&&A.b(a)
if(!(c<4096))return A.a(a,c)
a[c]=r
s=q.f
b.$flags&2&&A.b(b)
b[c]=s+3;++c}return c},
h4(a,b,c){var s,r,q,p,o,n,m,l=this,k=l.b
if(k>=a.d){l.e=l.d=4294967295
return}s=a.a
if(!(k<s.length))return A.a(s,k)
r=s[k]
s=a.b
if(!(k<s.length))return A.a(s,k)
q=s[k]
p=b+c
s=l.c
o=s<r?r-s:0
n=o===0?q-(s-r):q
if(o>=c){l.e=l.d=4294967295
l.cs(a,c)
return}s=b+o
l.d=s
s+=n
l.e=s
m=a.c
if(!(k<m.length))return A.a(m,k)
l.f=m[k]
if(s>p){l.e=p
l.cs(a,p-b)}else l.cs(a,o+n)},
cs(a,b){var s,r,q,p,o=this,n=o.c+b,m=a.a,l=m.length,k=a.b,j=k.length
for(;;){s=n!==0
if(!(s&&o.b<a.d))break
r=o.b
if(!(r<l))return A.a(m,r)
q=m[r]
if(!(r<j))return A.a(k,r)
p=q+k[r]
if(n>=p){n-=p
o.b=r+1}else{o.c=n
break}}if(!s||o.b===a.d)o.c=0}}
A.jM.prototype={
bm(a){var s,r,q,p,o
for(s=this.e,r=s.length,q=0;q<r;++q){p=s[q]
o=p<=a?0:p-a
s.$flags&2&&A.b(s)
s[q]=o}s=this.CW
this.CW=s>a+1?s-a:1},
ly(a,b,c){var s,r,q,p,o,n,m,l,k,j,i=this,h=B.a.p(1,i.c)-1
i.ay=4294967295
s=i.ch=0
for(r=i.y,q=i.a,p=i.x,o=b+q,n=b;n<c;){m=i.fm(a,n,c-n)
for(l=s;l<i.as;++l){if(!(l<64))return A.a(r,l)
k=n+r[l]
if(k<o)continue
j=k-q
p.a0()
p.ag(a,j,q)
i.cv((p.bS().b&h)>>>0,p.bS().a,j)}n+=m}},
ig(a,b,c,d,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this
a0.f=a0.e=a0.d=0
s=a0.a
r=s.length
q=e.a
p=e.d
o=s.$flags|0
n=c
m=0
l=0
for(;;){if(!(n<d&&l<r))break
k=d-n<1048576?d:n+1048576
j=k+1-B.a.q(1,p)
if(j>e.CW)e.CW=j
i=k-n
h=i<q?i:e.jo(a,b,n,k,a0)
g=a0.d
if(l<g){if(!(l>=0&&l<r))return A.a(s,l)
f=s[l]
o&2&&A.b(s)
s[l]=f+m
m=h}else m+=i
l=g
n=k}},
jo(c8,c9,d0,d1,d2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8=this,b9=d2.a,c0=b9.length,c1=d1-8,c2=b8.CW-1,c3=b8.b,c4=B.a.p(1,c3),c5=B.a.p(1,b8.c)-1,c6=b8.a,c7=d0+c6
b8.ay=4294967295
b8.ch=0
for(s=b9.$flags|0,r=d2.b,q=r.$flags|0,p=d2.c,o=p.$flags|0,n=b8.f,m=n.length,l=b8.e,k=l.length,j=b8.y,i=b8.z,h=b8.Q,g=b8.x,f=j.$flags|0,e=i.$flags|0,d=h.$flags|0,c=d0;c7<c1;){b=b8.fm(c8,c7,c1-c7)
a=b8.as
for(a0=0;a0<a;++a0){if(!(a0<64))return A.a(j,a0)
a1=c7+j[a0]-c6
g.a0()
g.ag(c8,a1,c6)
f&2&&A.b(j)
j[a0]=a1
a2=g.bS().b
e&2&&A.b(i)
i[a0]=(a2&c5)>>>0
a2=g.bS().a
d&2&&A.b(h)
h[a0]=a2}for(a2=c7+b,a0=0;a0<a;++a0){if(!(a0<64))return A.a(j,a0)
a1=j[a0]
a3=i[a0]
a4=h[a0]
if(a1<c){b8.cv(a3,a4,a1)
continue}a5=B.a.p(a3,c3)
for(a6=0,a7=0,a8=0,a9=-1,b0=0;b0<c4;++b0){b1=a5+b0
if(!(b1<k))return A.a(l,b1)
b2=l[b1]
if(!(b1<m))return A.a(n,b1)
if(n[b1]!==a4||b2<=b8.CW)continue
b3=b2-1
b4=A.rN(c8,c9,a1,b3,d1)
if(b4<c6)continue
b5=A.rO(c8,a1,c,b3,c2)
b6=b4+b5
if(b6>a6){a9=b3
a8=b5
a7=b4
a6=b6}}if(a9<0){b8.cv(a3,a4,a1)
continue}b7=d2.d
if(b7===c0){b9=d1-c
return b9<0?0:b9}s&2&&A.b(b9)
if(!(b7<c0))return A.a(b9,b7)
b9[b7]=a1-a8-c
q&2&&A.b(r)
if(!(b7<r.length))return A.a(r,b7)
r[b7]=a7+a8
o&2&&A.b(p)
if(!(b7<p.length))return A.a(p,b7)
p[b7]=a1-a9
d2.d=b7+1
b8.cv(a3,a4,a1)
c=a1+a7
if(c>a2){c7=c-b
break}}c7+=b}b9=d1-c
return b9<0?0:b9},
jf(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=f.ch,d=f.ay
for(s=f.ax,r=a.length,q=f.at,p=f.y,o=p.$flags|0,n=0,m=0;m<c;d=h){l=b+m
if(!(l>=0&&l<r))return A.a(a,l)
k=a[l]
l=k*2
j=l+1
if(!(j<512))return A.a(B.O,j)
i=(d&2147483647)*2+B.O[j]
h=i>>>0
if(!(l<512))return A.a(B.O,l)
l=B.O[l]
j=i>=4294967296?1:0
e=(((e&2147483647)*2|d>>>31)>>>0)+l+j>>>0;++m
if((e&s)>>>0===0&&(h&q)>>>0===0){g=n+1
o&2&&A.b(p)
if(!(n<64))return A.a(p,n)
p[n]=m
if(g===64){n=g
d=h
break}n=g}}f.ch=e
f.ay=d
f.as=n
return m},
fm(a,b,c){return this.jf(a,b,c)},
cv(a,b,c){var s,r=this,q=r.b,p=B.a.p(a,q),o=r.r
if(!(a>=0&&a<o.length))return A.a(o,a)
s=p+o[a]
p=r.e
p.$flags&2&&A.b(p)
if(!(s<p.length))return A.a(p,s)
p[s]=c+1
p=r.f
p.$flags&2&&A.b(p)
if(!(s<p.length))return A.a(p,s)
p[s]=b
p=o[a]
q=B.a.p(1,q)
o.$flags&2&&A.b(o)
o[a]=(p+1&q-1)>>>0}}
A.jO.prototype={}
A.jR.prototype={
n(a){return"ZstdLiteralsException: "+this.a}}
A.jP.prototype={
l5(a,b,c,d,e,f){var s,r,q=this
q.a=e
q.b=f
if(b>=c)A.ui()
if(!(b<a.length))return A.a(a,b)
s=a[b]
r=s&3
if(r===0||r===1)return q.iY(a,b,c,d,r,s)
return q.iW(a,b,c,d,r,s)},
iY(a,b,c,d,e,f){var s,r,q,p,o,n,m=this,l=f>>>2&3
if((l&1)===0){s=f>>>3
r=1}else if(l===1){if(b+2>c)A.mZ()
q=b+1
if(!(q<a.length))return A.a(a,q)
s=(f>>>4|a[q]<<4)>>>0
r=2}else{if(b+3>c)A.mZ()
q=b+1
p=a.length
if(!(q<p))return A.a(a,q)
q=a[q]
o=b+2
if(!(o<p))return A.a(a,o)
s=(f>>>4|q<<4|a[o]<<12)>>>0
r=3}if(s>d)A.pe()
n=b+r
if(e===1){if(n>=c)A.uH()
q=m.a
p=m.b
if(!(n<a.length))return A.a(a,n)
B.c.F(q,p,p+s,a[n])
m.c=s
return r+1}if(n+s>c)A.uz()
q=m.a
p=m.b
B.c.H(q,p,p+s,a,n)
m.c=s
return r+s},
iW(a0,a1,a2,a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=a5>>>2&3
if(a<=1){s=10
r=3}else if(a===2){s=14
r=4}else{s=18
r=5}q=a1+r
if(q>a2)A.mZ()
for(p=r-1,o=a0.length,n=0;p>=0;--p){m=a1+p
if(!(m<o))return A.a(a0,m)
n=n*256+a0[m]}l=B.a.q(1,s)-1
k=(B.a.t(n,16)&l)>>>0
j=(B.a.a2(n,B.a.q(1,4+s))&l)>>>0
if(k>a3)A.pe()
if(j===0||q+j>a2)A.tE()
i=q+j
if(a4===2){q+=A.vP(a0,q,i,b.d,b.e)
b.w=!0}else if(!b.w)A.v6()
h=i-q
if(h<=0)A.uh()
if(a===0)A.py(b.d,a0,q,h,b.a,b.b,k)
else{if(h<10)A.tT()
if(k<6)A.tU()
if(!(q<o))return A.a(a0,q)
m=a0[q]
g=q+1
if(!(g<o))return A.a(a0,g)
f=(m|a0[g]<<8)>>>0
g=q+2
if(!(g<o))return A.a(a0,g)
g=a0[g]
m=q+3
if(!(m<o))return A.a(a0,m)
e=(g|a0[m]<<8)>>>0
m=q+4
if(!(m<o))return A.a(a0,m)
m=a0[m]
g=q+5
if(!(g<o))return A.a(a0,g)
d=(m|a0[g]<<8)>>>0
if(f===0||e===0||d===0)A.uf()
c=6+f+e+d
if(c>=h)A.ug()
o=b.f
o.$flags&2&&A.b(o)
o[0]=q+6
o[1]=o[0]+f
o[2]=o[1]+e
o[3]=o[2]+d
m=b.r
m.$flags&2&&A.b(m)
m[0]=f
m[1]=e
m[2]=d
m[3]=h-c
A.vv(b.d,a0,o,m,b.a,b.b,k,k+3>>>2)}b.c=k
return r+j},
gi(a){return this.c}}
A.jQ.prototype={
lG(a,b){var s,r,q
this.a.lH(a,b)
this.e=!0
s=a.length
r=s===256
q=0
for(;;){if(!(r&&q<s))break
if(!(q<s))return A.a(a,q)
r=a[q]!==0;++q}this.y=r},
aG(){var s,r=this
if(r.r){s=r.a
r.a=r.b
r.b=s}r.e=r.f
r.y=r.z},
lp(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k,j,i,h,g=this
g.r=!1
g.f=g.e
s=g.y
g.z=s
r=e-d
if(!g.x){q=r<(s?6:g.w)
s=q}else s=!0
if(s)return A.bu(a,b,c,d,r,0)
if(f&&r>=40960)if(g.fO(c,d)+g.fO(c,e-4096)<=68)return A.bu(a,b,c,d,r,0)
s=r>=1024
q=s?1:0
p=r>=16384
o=p?1:0
if(g.as&&r<=1024&&g.y)return g.e2(a,b,c,d,e,3+q+o,r)
n=g.hj(c,d,e)
if(n===r)return A.bu(a,b,c,d,r,1)
if(n<=B.a.k(r,7)+4)return A.bu(a,b,c,d,r,0)
s=s?1:0
q=p?1:0
m=3+s+q
l=g.e?g.ca(g.a):-1
if(g.as&&r<=1024&&l>=0)return g.e2(a,b,c,d,e,m,r)
if(!g.b.ht(g.c,r))return A.bu(a,b,c,d,r,0)
s=b+m
k=g.b.ez(a,s)
if(k<0)return A.bu(a,b,c,d,r,0)
j=k+12>=r
if(l>=0)q=j||B.a.k(l,3)<=k+B.a.k(g.ca(g.b),3)
else q=!1
if(q)return g.e2(a,b,c,d,e,m,r)
if(j)return A.bu(a,b,c,d,r,0)
q=g.b
q.ch=g.y&&m===3
i=q.hF(a,s+k,c,d,e)
if(i<0)return A.bu(a,b,c,d,r,0)
h=k+i
if(h>=r-(B.a.k(r,g.Q)+2))return A.bu(a,b,c,d,r,0)
g.f=g.r=!0
g.z=!1
A.oy(a,b,r,h,m,2,g.b.ch)
return m+h},
ee(a,b,c,d){var s,r,q,p,o,n,m=this,l=d-c
if(l<=(m.y?6:63))return l
s=m.hj(b,c,d)
if(s===l)return 1
if(s<=B.a.k(l,7)+4)return l
r=m.e?m.ca(m.a):-1
if(!m.b.ht(m.c,l))return l
q=m.b.ez(a,0)
if(q<0)return l
p=B.a.k(m.ca(m.b),3)
if(r>=0){o=B.a.k(r,3)
if(o<l)n=o<=q+p||q+12>=l
else n=!1
if(n)return A.ox(o,l)}n=p+q
if(n>=l)return l
return A.ox(n,l)},
e2(a,b,c,d,e,f,g){var s,r=this,q=r.a
q.ch=r.y&&f===3
s=q.hF(a,b+f,c,d,e)
if(s<0||s>=g-(B.a.k(g,r.Q)+2))return A.bu(a,b,c,d,g,0)
A.oy(a,b,g,s,f,3,r.a.ch)
return f+s},
fO(a,b){var s,r,q,p,o,n,m=this.c
B.f.F(m,0,256,0)
for(s=a.length,r=m.$flags|0,q=0,p=0;p<4096;++p){o=b+p
if(!(o>=0&&o<s))return A.a(a,o)
o=a[o]
if(!(o<256))return A.a(m,o)
n=m[o]+1
r&2&&A.b(m)
m[o]=n
if(n>q)q=n}return q},
hj(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this.d
B.f.F(f,0,1024,0)
s=A.al(a)
r=c-8
for(q=f.$flags|0,p=b;p<=r;){o=s.getUint32(p,!0)
n=s.getUint32(p+4,!0)
m=o&255
l=f[m]
q&2&&A.b(f)
f[m]=l+1
l=256+(o>>>8&255)
f[l]=f[l]+1
l=512+(o>>>16&255)
f[l]=f[l]+1
l=768+(o>>>24)
if(!(l<1024))return A.a(f,l)
f[l]=f[l]+1
l=n&255
f[l]=f[l]+1
l=256+(n>>>8&255)
f[l]=f[l]+1
l=512+(n>>>16&255)
f[l]=f[l]+1
l=768+(n>>>24)
if(!(l<1024))return A.a(f,l)
f[l]=f[l]+1
p+=8
continue}for(m=a.length;p<c;p=k){k=p+1
if(!(p>=0&&p<m))return A.a(a,p)
l=a[p]
if(!(l<1024))return A.a(f,l)
j=f[l]
q&2&&A.b(f)
f[l]=j+1}for(q=this.c,m=q.$flags|0,i=0,h=0;h<256;++h){g=f[h]+f[256+h]+f[512+h]+f[768+h]
m&2&&A.b(q)
q[h]=g
if(g>i)i=g}return i},
ca(a){var s,r,q,p,o,n
for(s=a.b,r=this.c,q=0,p=0;p<256;++p){o=r[p]
if(o===0)continue
n=s[p]
if(n===0)return-1
q+=o*n}return q}}
A.jS.prototype={
aj(a,b,c){if(this.R8!==0)return b
return a-b>c?a-c:b},
fP(a,b){return this.p4>this.aj(a,b,B.a.q(1,this.a.b))},
a0(){var s=this,r=s.b
B.f.F(r,0,r.length,0)
r=s.c
B.f.F(r,0,r.length,0)
r=s.cx
B.f.F(r,0,r.length,0)
r=s.db
B.c.F(r,0,r.length,0)
s.CW=s.p2=0
r=s.ch
B.f.F(r,0,r.length,0)
s.R8=0},
gd_(){var s=this.a
if(s.a>=4)return this.as+1
return A.jU(s)?B.a.p(1,s.d):1},
geF(){var s=this
return s.b.length+s.c.length+s.cx.length+s.ch.length},
bm(a){var s=this,r=s.b,q=s.c
if(s.a.a>=4){A.jT(r,a)
A.jT(q,a)}else{A.cf(r,a)
A.cf(q,a)}A.cf(s.cx,a)
A.cf(s.ch,a)
r=s.p2
s.p2=r>a?r-a:0
r=s.CW
s.CW=r>a?r-a:0
r=s.p4
s.p4=r>a?r-a:0
r=s.R8
s.R8=r>a?r-a:0},
lP(a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c=d.a,b=c.c,a=b+3,a0=c.d,a1=a0+1
if(a1>a)a=a1
s=a<31&&a4-a3>B.a.p(1,a)?a4-B.a.p(1,a):a3
d.R8=a4
r=a4-8
if(r<=s){d.CW=d.p2=a4
return}q=A.al(a2)
c=c.a
if(c===0)for(c=r+2,b=d.b,a0=d.f,p=d.e,o=b.$flags|0,n=s;m=n+3,m<c;n=m){l=A.q(q,n,a0,p)
o&2&&A.b(b)
if(!(l<b.length))return A.a(b,l)
b[l]=n+1}else if(c===1){k=64-b
j=64-a0
for(c=d.b,b=c.$flags|0,a0=d.c,p=d.f,o=a0.$flags|0,n=s;m=n+3,m-1<=r;n=m){l=A.q(q,n,8,k)
i=n+1
b&2&&A.b(c)
if(!(l<c.length))return A.a(c,l)
c[l]=i
l=A.q(q,n,p,j)
o&2&&A.b(a0)
if(!(l<a0.length))return A.a(a0,l)
a0[l]=i
continue}}else{c=d.at
if(c===0)d.ds(q,s,r)
else if(c===1){h=B.a.p(1,a0)-1
for(c=d.f,b=d.e,a0=d.c,p=d.b,o=p.length,l=a0.$flags|0,i=p.$flags|0,n=s;n<r;){g=A.q(q,n,c,b)
f=(n&h)>>>0
if(!(g<o))return A.a(p,g)
e=p[g]
l&2&&A.b(a0)
if(!(f>=0&&f<a0.length))return A.a(a0,f)
a0[f]=e;++n
i&2&&A.b(p)
p[g]=n}}else for(n=s;n<r;)n+=d.fC(a2,q,n,r,s,a4)}d.CW=d.p2=a4},
k7(c3,c4,c5,c6,c7,c8,c9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8=this,b9=c6-8,c0=b8.a,c1=B.a.q(1,c0.b),c2=b8.aj(c6,c7,c1)
c0=c0.f
s=c0+(c0===0?1:0)+1
c0=b8.p4
r=c5===(c2>c0?c2:c0)&&c2>=c0?c5+1:c5
q=c9[0]
p=c9[1]
o=b8.aj(r,c7,c1)
n=r-(o>c0?o:c0)
m=b8.b
l=b8.f
k=b8.e
if(p>n){j=p
p=0}else j=0
if(q>n){i=q
q=0}else i=0
for(c0=m.length,o=c3.length,h=m.$flags|0,g=c5;;){f=r+128
e=r+1
d=r+s
c=d+1
if(c>=b9)break
b=A.q(c4,r,l,k)
a=A.q(c4,e,l,k)
if(!(b<c0))return A.a(m,b)
a0=m[b]
a1=q>0
a2=s
do{m.$flags&2&&A.b(m)
if(!(b>=0&&b<c0))return A.a(m,b)
m[b]=r+1
a5=d-q
a6=0
a7=0
if(c4.getUint32(d,!0)===c4.getUint32(a5,!0)&&a1){if(a5>c7){a1=d-1
if(!(a1>=0&&a1<o))return A.a(c3,a1)
a1=c3[a1]
a8=a5-1
if(!(a8>=0&&a8<o))return A.a(c3,a8)
a8=a1===c3[a8]
a1=a8}else a1=!1
a6=a1?1:0
a9=d-a6
b0=a5-a6
a6+=4
m.$flags&2&&A.b(m)
if(!(a>=0&&a<c0))return A.a(m,a)
m[a]=e+1
a3=r
r=a9
a4=b0
a7=1
break}a4=a0-1
if(a4>=c2&&c4.getUint32(r,!0)===c4.getUint32(a4,!0)){m.$flags&2&&A.b(m)
if(!(a>=0&&a<c0))return A.a(m,a)
m[a]=e+1
a3=r
break}if(!(a>=0&&a<c0))return A.a(m,a)
a0=m[a]
b1=A.q(c4,d,l,k)
m.$flags&2&&A.b(m)
m[a]=e+1
a4=a0-1
if(a4>=c2&&c4.getUint32(e,!0)===c4.getUint32(a4,!0)){if(a2<=4){m.$flags&2&&A.b(m)
if(!(b1<c0))return A.a(m,b1)
m[b1]=d+1}a3=e
r=a3
break}if(!(b1<c0))return A.a(m,b1)
a0=m[b1]
a=A.q(c4,c,l,k)
b2=d+a2
b3=c+a2
if(b2>=f){++a2
f+=128}if(b3<b9){b=b1
e=c
c=b3
r=d
d=b2
continue}else{a3=e
r=d
a4=-1
break}}while(!0)
if(a4<0)break
b4=a3+2
if(a7===0){b5=r-a4
a7=b5+3
a6=4
for(;;){a1=!1
if(r>g)if(a4>c2){a1=r-1
if(!(a1>=0&&a1<o))return A.a(c3,a1)
a1=c3[a1]
a5=a4-1
if(!(a5>=0&&a5<o))return A.a(c3,a5)
a5=a1===c3[a5]
a1=a5}if(!a1)break;--r;--a4;++a6}p=q
q=b5}a6+=b8.ac(c3,c4,r+a6,a4+a6,c6)
c8.ao(0,c3,g,r-g,a7,a6-3)
r+=a6
if(r<=b9){a1=A.q(c4,b4,l,k)
h&2&&A.b(m)
if(!(a1<c0))return A.a(m,a1)
m[a1]=b4+1
a1=A.q(c4,r-2,l,k)
if(!(a1<c0))return A.a(m,a1)
m[a1]=r-1
g=r
for(;;){if(!(p>0&&r<=b9&&c4.getUint32(r,!0)===c4.getUint32(r-p,!0)))break
b6=4+b8.ac(c3,c4,r+4,r-p+4,c6)
a1=A.q(c4,r,l,k)
if(!(a1<c0))return A.a(m,a1)
m[a1]=r+1
r+=b6
c8.ao(0,c3,g,0,1,b6-3)
g=r
b7=p
p=q
q=b7}}else g=r}c8.bz(c3,g,c6)
c0=q!==0
o=c0?q:i
c9.$flags&2&&A.b(c9)
if(0>=3)return A.a(c9,0)
c9[0]=o
if(p!==0)c0=p
else c0=i!==0&&c0?i:j
if(1>=3)return A.a(c9,1)
c9[1]=c0
c0=c9[2]
c9.$flags&2&&A.b(c9)
c9[2]=c0},
k8(c5,c6,c7,c8,c9,d0,d1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0=this,c1=c8-8,c2=c0.a,c3=c0.aj(c8,c9,B.a.q(1,c2.b)),c4=c0.p4
if(c3>c4)c4=c3
c2=c2.f
s=c2+(c2===0?1:0)+1
r=c0.b
q=c0.f
p=c0.e
o=d1[0]
n=d1[1]
m=c7-c3
if(n>=m){l=n
n=0}else l=0
if(o>=m){k=o
o=0}else k=0
for(c2=r.length,j=c4-4,i=c5.length,h=c7,g=h;;){f=h+128
e=h+1
d=h+s
c=d+1
if(c>=c1)break
b=A.q(c6,h,q,p)
a=A.q(c6,e,q,p)
if(!(b<c2))return A.a(r,b)
a0=r[b]-1
a1=o>0
a2=s
do{a5=d-o
r.$flags&2&&A.b(r)
if(!(b>=0&&b<c2))return A.a(r,b)
r[b]=h+1
if(a1)a6=(a5<=j||a5>c4)&&c6.getUint32(d,!0)===c6.getUint32(a5,!0)
else a6=!1
a7=0
a8=0
if(a6){a1=d-1
if(!(a1>=0&&a1<i))return A.a(c5,a1)
a1=c5[a1]
a6=a5-1
if(!(a6>=0&&a6<i))return A.a(c5,a6)
a7=a1===c5[a6]?1:0
a9=d-a7
b0=a5-a7
a7+=4
a3=h
h=a9
a4=b0
a8=1
break}if(a0>=c3&&c6.getUint32(h,!0)===c6.getUint32(a0,!0)){a3=h
a4=a0
break}if(!(a>=0&&a<c2))return A.a(r,a)
a0=r[a]-1
b1=A.q(c6,d,q,p)
r.$flags&2&&A.b(r)
r[a]=e+1
if(a0>=c3&&c6.getUint32(e,!0)===c6.getUint32(a0,!0)){a3=e
e=d
a4=a0
a=b1
h=a3
break}if(!(b1<c2))return A.a(r,b1)
a0=r[b1]-1
a=A.q(c6,c,q,p)
b2=d+a2
b3=c+a2
if(b2>=f){++a2
f+=128}if(b3<c1){b=b1
e=c
c=b3
h=d
d=b2
continue}else{a3=e
e=c
h=d
a4=-1
break}}while(!0)
if(a4<0)break
b4=a3+2
if(a8===0){b5=a3-a4
a8=b5+3
b6=a4<c4?c3:c4
a7=4
for(;;){a1=!1
if(h>g)if(a4>b6){a1=h-1
if(!(a1>=0&&a1<i))return A.a(c5,a1)
a1=c5[a1]
a6=a4-1
if(!(a6>=0&&a6<i))return A.a(c5,a6)
a6=a1===c5[a6]
a1=a6}if(!a1)break;--h;--a4;++a7}n=o
o=b5}a7+=c0.ac(c5,c6,h+a7,a4+a7,c8)
d0.ao(0,c5,g,h-g,a8,a7-3)
h+=a7
if(e<h){r.$flags&2&&A.b(r)
if(!(a>=0&&a<c2))return A.a(r,a)
r[a]=e+1}if(h<=c1){a1=A.q(c6,b4,q,p)
r.$flags&2&&A.b(r)
if(!(a1<c2))return A.a(r,a1)
r[a1]=b4+1
a1=A.q(c6,h-2,q,p)
r.$flags&2&&A.b(r)
if(!(a1<c2))return A.a(r,a1)
r[a1]=h-1
for(g=h;h<=c1;g=h,b7=n,n=o,o=b7){b8=h-n
if(n!==0){a1=c0.p4
a1=b8<a1&&b8>a1-4||c6.getUint32(b8,!0)!==c6.getUint32(h,!0)}else a1=!0
if(a1)break
b9=4+c0.ac(c5,c6,h+4,b8+4,c8)
a1=A.q(c6,h,q,p)
r.$flags&2&&A.b(r)
if(!(a1<c2))return A.a(r,a1)
r[a1]=h+1
h+=b9
d0.ao(0,c5,g,0,1,b9-3)}}else g=h}d0.bz(c5,g,c8)
if(k!==0&&o!==0)l=k
c2=o!==0?o:k
d1.$flags&2&&A.b(d1)
if(0>=3)return A.a(d1,0)
d1[0]=c2
c2=n!==0?n:l
if(1>=3)return A.a(d1,1)
d1[1]=c2},
k5(b8,b9,c0,c1,c2,c3,c4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3=this,b4=c1-8,b5=b3.a,b6=b3.aj(c1,c2,B.a.q(1,b5.b)),b7=b3.p4
if(b6>b7)b7=b6
s=64-b5.c
r=64-b5.d
q=c4[0]
p=c4[1]
for(b5=b8.length,o=b3.b,n=o.length,m=o.$flags|0,l=b3.f,k=b3.c,j=k.length,i=k.$flags|0,h=c0,g=h;h<b4;){f=A.q(b9,h,l,r)
e=A.q(b9,h,8,s)
if(!(f<j))return A.a(k,f)
d=k[f]-1
if(!(e<n))return A.a(o,e)
c=o[e]-1
b=h+1
i&2&&A.b(k)
k[f]=b
m&2&&A.b(o)
o[e]=b
a=b-q
a0=b3.p4
if(!(a<a0&&a>a0-4)&&q<=b-b6&&b9.getUint32(a,!0)===b9.getUint32(b,!0)){a1=4+b3.ac(b8,b9,h+5,a+4,c1)
c3.ao(0,b8,g,b-g,1,a1-3)}else{if(c>b6&&b9.getUint32(c,!0)===b9.getUint32(h,!0)&&b9.getUint32(c+4,!0)===b9.getUint32(h+4,!0)){a1=8+b3.ac(b8,b9,h+8,c+8,c1)
a2=c<b7?b6:b7
a3=c
b=h
for(;;){a0=!1
if(b>g)if(a3>a2){a0=b-1
if(!(a0>=0&&a0<b5))return A.a(b8,a0)
a0=b8[a0]
a4=a3-1
if(!(a4>=0&&a4<b5))return A.a(b8,a4)
a4=a0===b8[a4]
a0=a4}if(!a0)break;--b;--a3;++a1}a5=b-a3
c3.ao(0,b8,g,b-g,a5+3,a1-3)}else if(d>b6&&b9.getUint32(d,!0)===b9.getUint32(h,!0)){a6=A.q(b9,b,8,s)
if(!(a6<n))return A.a(o,a6)
a7=o[a6]-1
o[a6]=h+2
if(a7>b6&&b9.getUint32(a7,!0)===b9.getUint32(b,!0)&&b9.getUint32(a7+4,!0)===b9.getUint32(b+4,!0)){a1=8+b3.ac(b8,b9,h+9,a7+8,c1)
a3=a7}else{a1=4+b3.ac(b8,b9,h+4,d+4,c1)
a3=d
b=h}a2=a3<b7?b6:b7
for(;;){a0=!1
if(b>g)if(a3>a2){a0=b-1
if(!(a0>=0&&a0<b5))return A.a(b8,a0)
a0=b8[a0]
a4=a3-1
if(!(a4>=0&&a4<b5))return A.a(b8,a4)
a4=a0===b8[a4]
a0=a4}if(!a0)break;--b;--a3;++a1}a5=b-a3
c3.ao(0,b8,g,b-g,a5+3,a1-3)}else{h+=B.a.k(h-g,8)+1
continue}p=q
q=a5}b+=a1
if(b<=b4){a8=h+2
a0=A.q(b9,a8,8,s)
a4=a8+1
if(!(a0<n))return A.a(o,a0)
o[a0]=a4
a0=A.q(b9,b-2,8,s)
a9=b-1
if(!(a0<n))return A.a(o,a0)
o[a0]=a9
a0=A.q(b9,a8,l,r)
if(!(a0<j))return A.a(k,a0)
k[a0]=a4
a9=A.q(b9,a9,l,r)
if(!(a9<j))return A.a(k,a9)
k[a9]=b
for(h=b,g=h;h<=b4;g=h,b0=p,p=q,q=b0){b1=h-p
a0=b3.p4
if(b1<a0&&b1>a0-4||p>h-b6||b9.getUint32(b1,!0)!==b9.getUint32(h,!0))break
b2=4+b3.ac(b8,b9,h+4,b1+4,c1)
c3.ao(0,b8,g,0,1,b2-3)
a0=A.q(b9,h,l,r)
a4=h+1
if(!(a0<j))return A.a(k,a0)
k[a0]=a4
a0=A.q(b9,h,8,s)
if(!(a0<n))return A.a(o,a0)
o[a0]=a4
h+=b2}}else{h=b
g=h}}c4.$flags&2&&A.b(c4)
if(0>=3)return A.a(c4,0)
c4[0]=q
if(1>=3)return A.a(c4,1)
c4[1]=p
c3.bz(b8,g,c1)},
k0(c5,c6,c7,c8,c9,d0,d1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8=this,b9=c8-8,c0=b8.a,c1=B.a.q(1,c0.b),c2=b8.aj(c8,c9,c1),c3=64-c0.c,c4=64-c0.d
c0=b8.p4
s=c7===(c2>c0?c2:c0)&&c2>=c0?c7+1:c7
r=d1[0]
q=d1[1]
p=b8.aj(s,c9,c1)
o=s-(p>c0?p:c0)
if(q>o){n=q
q=0}else n=0
if(r>o){m=r
r=0}else m=0
for(c0=b8.b,p=c0.length,l=b8.f,k=b8.c,j=k.length,i=c0.$flags|0,h=k.$flags|0,g=c5.length,f=c7;;){e=s+256
d=s+1
if(d>b9)break
c=A.q(c6,s,8,c3)
if(!(c<p))return A.a(c0,c)
b=c0[c]
a=r>0
a0=1
a1=0
do{a4=A.q(c6,s,l,c4)
if(!(a4<j))return A.a(k,a4)
a5=k[a4]
a2=s+1
i&2&&A.b(c0)
if(!(c>=0&&c<p))return A.a(c0,c)
c0[c]=a2
h&2&&A.b(k)
k[a4]=a2
a6=-1
a7=!1
if(a&&c6.getUint32(a2-r,!0)===c6.getUint32(a2,!0)){a3=4+b8.b_(c5,c6,a2+4,a2-r+4,c8)
d0.ao(0,c5,f,a2-f,1,a3-3)
a7=!0
break}a1=A.q(c6,d,8,c3)
if(b!==0){a8=b-1
a8=a8>=c2&&c6.getUint32(a8,!0)===c6.getUint32(s,!0)&&c6.getUint32(a8+4,!0)===c6.getUint32(s+4,!0)}else a8=!1
if(a8){a6=b-1
a3=8+b8.b_(c5,c6,s+8,a6+8,c8)
a2=s
for(;;){a=!1
if(a2>f)if(a6>c2){a=a2-1
if(!(a>=0&&a<g))return A.a(c5,a)
a=c5[a]
a8=a6-1
if(!(a8>=0&&a8<g))return A.a(c5,a8)
a8=a===c5[a8]
a=a8}if(!a)break;--a2;--a6;++a3}break}if(!(a1<p))return A.a(c0,a1)
a9=c0[a1]
if(a5!==0){a8=a5-1
a8=a8>=c2&&c6.getUint32(a8,!0)===c6.getUint32(s,!0)}else a8=!1
if(a8){a6=a5-1
a3=4+b8.b_(c5,c6,s+4,a6+4,c8)
b0=a9-1
if(b0>c2&&c6.getUint32(b0,!0)===c6.getUint32(d,!0)&&c6.getUint32(b0+4,!0)===c6.getUint32(d+4,!0)){b1=8+b8.b_(c5,c6,d+8,b0+8,c8)
if(b1>a3){a3=b1
a6=b0
a2=d}else a2=s}else a2=s
for(;;){a=!1
if(a2>f)if(a6>c2){a=a2-1
if(!(a>=0&&a<g))return A.a(c5,a)
a=c5[a]
a8=a6-1
if(!(a8>=0&&a8<g))return A.a(c5,a8)
a8=a===c5[a8]
a=a8}if(!a)break;--a2;--a6;++a3}break}if(d>=e){++a0
e+=256}b2=d+a0
if(b2<=b9){b=a9
c=a1
s=d
d=b2
continue}else{a2=d
d=b2
a3=0
break}}while(!0)
if(!a7){if(a6<0)break
b3=a2-a6
if(a0<4){if(!(a1>=0&&a1<p))return A.a(c0,a1)
c0[a1]=d+1}d0.ao(0,c5,f,a2-f,b3+3,a3-3)
q=r
r=b3}a2+=a3
if(a2<=b9){b4=s+2
a=A.q(c6,b4,8,c3)
a8=b4+1
if(!(a<p))return A.a(c0,a)
c0[a]=a8
a=A.q(c6,a2-2,8,c3)
b5=a2-1
if(!(a<p))return A.a(c0,a)
c0[a]=b5
a=A.q(c6,b4,l,c4)
if(!(a<j))return A.a(k,a)
k[a]=a8
b5=A.q(c6,b5,l,c4)
if(!(b5<j))return A.a(k,b5)
k[b5]=a2
s=a2
f=s
for(;;){if(!(s<=b9&&q>0&&c6.getUint32(s,!0)===c6.getUint32(s-q,!0)))break
b6=4+b8.b_(c5,c6,s+4,s-q+4,c8)
a=A.q(c6,s,l,c4)
a8=s+1
if(!(a<j))return A.a(k,a)
k[a]=a8
a=A.q(c6,s,8,c3)
if(!(a<p))return A.a(c0,a)
c0[a]=a8
d0.ao(0,c5,f,0,1,b6-3)
s+=b6
f=s
b7=q
q=r
r=b7}}else{s=a2
f=s}}d0.bz(c5,f,c8)
c0=r!==0
p=c0?r:m
d1.$flags&2&&A.b(d1)
if(0>=3)return A.a(d1,0)
d1[0]=p
if(q!==0)c0=q
else c0=m!==0&&c0?m:n
if(1>=3)return A.a(d1,1)
d1[1]=c0},
k_(b2,b3,b4,b5,b6,b7,b8,b9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9=this,b0=a9.at===0?8:0,b1=b5-4-4-b0
b0=a9.a
s=b0.r
r=a9.p4
q=b4===(b6>r?b6:r)?b4+1:b4
if(a9.p2<b6)a9.p2=b6
p=b8[0]
o=b8[1]
n=B.a.q(1,b0.b)
m=q<n?q:n
l=0
k=0
if(!a9.RG){if(o>m){k=o
o=0}if(p>m){l=p
p=0}}for(b0=s>0,r=s===2,j=b4;q<b1;){i=q+1
h=i-p
g=p>0
f=!1
if(g)if(h>=(a9.RG?a9.aj(i,b6,n):b6)){e=a9.p4
e=!(h<e&&h>e-4)&&b3.getUint32(h,!0)===b3.getUint32(i,!0)
f=e}d=f?4+a9.ac(b2,b3,i+4,h+4,b5):0
c=1
if(!f||b0){b=a9.dW(b2,b3,q,b6,b5)
if(b>d){a=a9.p3+3
i=q
d=b}else a=c
if(d<4){a0=B.a.k(q-j,8)
a9.rx=(a9.RG?a0:a0+1)>8
q+=a0+1
continue}for(;;){if(!(b0&&q<b1)){c=a
break}A:{++q
a1=q-p
e=!1
if(g)if(a1>=(a9.RG?a9.aj(q,b6,n):b6)){e=a9.p4
e=!(a1<e&&a1>e-4)&&b3.getUint32(a1,!0)===b3.getUint32(q,!0)}if(e){a2=4+a9.ac(b2,b3,q+4,a1+4,b5)
if(a2*3>d*3-(B.a.gX(a)-1)+1){i=q
a=c
d=a2}}a3=a9.dW(b2,b3,q,b6,b5)
if(a3>=4&&a3*4-(B.a.gX(a9.p3+3)-1)>d*4-(B.a.gX(a)-1)+4){a=a9.p3+3
i=q
d=a3
break A}if(r&&q<b1){++q
a4=q-p
e=!1
if(g)if(a4>=(a9.RG?a9.aj(q,b6,n):b6)){e=a9.p4
e=!(a4<e&&a4>e-4)&&b3.getUint32(a4,!0)===b3.getUint32(q,!0)}if(e){a2=4+a9.ac(b2,b3,q+4,a4+4,b5)
if(a2*4>d*4-(B.a.gX(a)-1)+1){i=q
a=c
d=a2}}a5=a9.dW(b2,b3,q,b6,b5)
if(a5>=4&&a5*4-(B.a.gX(a9.p3+3)-1)>d*4-(B.a.gX(a)-1)+7){a=a9.p3+3
i=q
d=a5
break A}c=a}else c=a
break}}if(c>3){a6=c-3
a7=i-a6
g=a9.p4
if(a7<g)g=b6
else if(b6>g)g=b6
a8=A.rR(b2,i,a7,j,g)
i-=a8
d+=a8
o=p
p=a6}}a9.rx=!1
b7.ao(0,b2,j,i-j,c,d-3)
b8.$flags&2&&A.b(b8)
if(0>=3)return A.a(b8,0)
b8[0]=p
if(1>=3)return A.a(b8,1)
b8[1]=o
q=a9.jx(b2,b3,i+d,b1,b6,b5,b7,b8)
p=b8[0]
o=b8[1]
j=q}b7.bz(b2,j,b5)
b0=p!==0
r=b0?p:l
b8.$flags&2&&A.b(b8)
if(0>=3)return A.a(b8,0)
b8[0]=r
if(o!==0)b0=o
else b0=l!==0&&b0?l:k
if(1>=3)return A.a(b8,1)
b8[1]=b0},
jx(a,b,c,d,e,f,g,h){var s,r,q,p,o,n,m=this
for(s=h.$flags|0,r=m.a.b;c<=d;){q=h[1]
p=c-q
o=!0
if(q!==0)if(p>=(m.RG?m.aj(c,e,B.a.q(1,r)):e)){o=m.p4
o=p<o&&p>o-4||b.getUint32(p,!0)!==b.getUint32(c,!0)}if(o)break
n=4+m.ac(a,b,c+4,p+4,f)
o=h[0]
s&2&&A.b(h)
h[1]=o
h[0]=q
g.ao(0,a,c,0,1,n-3)
c+=n}return c},
dW(a,b,c,d,e){var s=this,r=s.at
if(r===2)return s.iB(a,b,c,d,e)
return r===1?s.iA(a,b,c,d,e):s.iz(a,b,c,d,e)},
iA(a,b,c,d,e){var s,r,q,p,o,n,m=this,l=m.a,k=m.aj(c,d,B.a.q(1,l.b)),j=B.a.p(1,l.d),i=j-1,h=c>j?c-j:0,g=B.a.q(1,l.e),f=m.jE(b,c)-1
l=m.c
s=l.length
r=c+4
q=3
p=0
for(;;){if(!(f>=k&&g>0))break;--g
if(f<m.p4)o=b.getUint32(f,!0)===b.getUint32(c,!0)?4+m.b_(a,b,r,f+4,e):0
else o=b.getUint32(f+q-3,!0)===b.getUint32(c+q-3,!0)?m.b_(a,b,c,f,e):0
if(o>q){p=c-f
if(c+o>=e){q=o
break}q=o}if(f<=h)break
n=(f&i)>>>0
if(!(n>=0&&n<s))return A.a(l,n)
f=l[n]-1}m.p3=p
return q},
jE(a,b){var s,r,q,p,o,n,m,l,k,j,i=this,h=B.a.p(1,i.a.d)-1,g=i.p2
for(s=i.f,r=i.e,q=i.c,p=i.b,o=p.length,n=q.$flags|0,m=p.$flags|0;g<b;){l=A.q(a,g,s,r)
k=(g&h)>>>0
if(!(l<o))return A.a(p,l)
j=p[l]
n&2&&A.b(q)
if(!(k>=0&&k<q.length))return A.a(q,k)
q[k]=j;++g
m&2&&A.b(p)
p[l]=g
if(i.rx)break}i.p2=b
s=A.q(a,b,s,r)
if(!(s<o))return A.a(p,s)
return p[s]},
iC(a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=a1.aj(a5,a6,B.a.q(1,a1.a.b))
a1.jD(a4,a5)
s=A.q(a4,a5,a1.f,a1.Q)
r=s>>>8
q=s&255
p=a1.db
o=B.a.q(r,a1.r)
n=(o^a1.dx)>>>0
m=p.length
if(!(n<m))return A.a(p,n)
l=p[n]
k=a1.d
j=a4.getUint32(a5,!0)
n=a1.cx
i=n.length
h=a1.x
g=a1.w
f=3
e=0
d=0
for(;;){if(!(d<g&&k>0))break
A:{c=(l+d&h)>>>0
if(c!==0){b=o+c
if(!(b<m))return A.a(p,b)
b=p[b]!==q}else b=!0
if(b)break A
b=o+c
if(!(b<i))return A.a(n,b)
a=n[b]-1
if(a<a2)break;--k
if(a4.getUint32(a+f-3,!0)!==j)break A
a0=a1.b_(a3,a4,a5,a,a7)
if(a0>f){e=a5-a
b=a5+a0
if(b>=a7){f=a0
break}j=a4.getUint32(b-3,!0)
f=a0}}++d}a1.fB(r,q,a5)
a1.p2=a5+1
a1.p3=e
return f},
iz(a,b,c,d,e){return this.iC(a,b,c,d,e)},
iB(a,b,c,d,e){var s=this
s.p3=0
if(c<s.p2)return 0
s.kI(b,c)
return s.kr(a,b,c,d,e)},
kI(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=f.p2
for(s=f.f,r=f.e,q=f.as,p=f.c,o=f.b,n=o.length,m=p.$flags|0,l=o.$flags|0;e<b;){k=A.q(a,e,s,r)
j=e+2
i=(j&q)<<1>>>0
if(!(k<n))return A.a(o,k)
h=o[k]
m&2&&A.b(p)
g=p.length
if(!(i<g))return A.a(p,i)
p[i]=h
h=i+1
if(!(h<g))return A.a(p,h)
p[h]=1
l&2&&A.b(o)
o[k]=j;++e}f.p2=b},
kr(b4,b5,b6,b7,b8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6=A.q(b5,b6,a5.f,a5.e),a7=b6+2,a8=a5.aj(b6,b7,B.a.q(1,a5.a.b))+2,a9=a5.as,b0=a9>=a7?0:a7-a9,b1=b0>a8?b0:a8,b2=a5.d,b3=a5.b
if(!(a6<b3.length))return A.a(b3,a6)
s=b3[a6]
r=a5.c
q=r.$flags|0
p=r.length
o=b2
n=0
for(;;){m=s>b1
if(m){l=((s&a9)<<1>>>0)+1
if(!(l<p))return A.a(r,l)
l=r[l]===1&&o>1}else l=!1
if(!l)break
m=(s&a9)<<1>>>0
l=m+1
q&2&&A.b(r)
if(!(l<p))return A.a(r,l)
r[l]=n
if(!(m<p))return A.a(r,m)
k=r[m];--o
n=s
s=k}if(m){m=((s&a9)<<1>>>0)+1
if(!(m<p))return A.a(r,m)
m=r[m]===1}else m=!1
if(m){j=(s&a9)<<1>>>0
q&2&&A.b(r)
if(!(j<p))return A.a(r,j)
r[j]=0
m=j+1
if(!(m<p))return A.a(r,m)
r[m]=0}for(s=n;s!==0;s=i){m=((s&a9)<<1>>>0)+1
if(!(m<p))return A.a(r,m)
i=r[m]
a5.kB(b4,b5,s,b7,b8,o,b1);++o}h=(a7&a9)<<1>>>0
g=h+1
f=a7+9
s=b3[a6]
b3.$flags&2&&A.b(b3)
b3[a6]=a7
b3=b4.length
e=b2
d=h
c=0
b=0
a=0
a0=0
a1=999999999
for(;;){if(!(e>0&&s>a8))break;--e
a2=s-2
a3=(s&a9)<<1>>>0
a4=c<b?c:b
a4+=a5.ac(b4,b5,b6+a4,a2+a4,b8)
if(a4>a){if(a4>f-s)f=s+a4
if(4*(a4-a)>B.a.gX(a7-s+1)-1-(B.a.gX(a1)-1)){a0=b6-a2
a1=a0+3
a=a4}if(b6+a4===b8)break}m=a2+a4
if(!(m>=0&&m<b3))return A.a(b4,m)
m=b4[m]
l=b6+a4
if(!(l>=0&&l<b3))return A.a(b4,l)
if(m<b4[l]){q&2&&A.b(r)
if(!(d>=0&&d<p))return A.a(r,d)
r[d]=s
if(s<=b0){d=-1
break}d=a3+1
if(!(d<p))return A.a(r,d)
s=r[d]
c=a4}else{q&2&&A.b(r)
if(!(g>=0&&g<p))return A.a(r,g)
r[g]=s
if(s<=b0){g=-1
break}if(!(a3<p))return A.a(r,a3)
s=r[a3]
b=a4
g=a3}}if(d>=0){q&2&&A.b(r)
if(!(d<p))return A.a(r,d)
r[d]=0}if(g>=0){q&2&&A.b(r)
if(!(g<p))return A.a(r,g)
r[g]=0}a5.p2=f-8-2
a5.p3=a0
return a},
kB(a3,a4,a5,a6,a7,a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this,a1=a5-2,a2=a0.p4
a2=a1<a2?a2:a7
s=B.a.q(1,a0.a.b)
r=a6+2
q=a5-r>s?a5-s:r
p=a0.as
o=(a5&p)<<1>>>0
n=o+1
m=a0.c
l=m.length
if(!(o<l))return A.a(m,o)
k=m[o]
j=m.$flags|0
i=a3.length
h=o
g=0
f=0
for(;;){if(!(a8>0&&k>q))break;--a8
e=k-2
d=(k&p)<<1>>>0
c=g<f?g:f
c+=a0.ac(a3,a4,a1+c,e+c,a2)
b=a1+c
if(b===a2)break
a=e+c
if(!(a>=0&&a<i))return A.a(a3,a)
a=a3[a]
if(!(b>=0&&b<i))return A.a(a3,b)
if(a<a3[b]){j&2&&A.b(m)
if(!(h>=0&&h<l))return A.a(m,h)
m[h]=k
if(k<=a9){h=-1
break}h=d+1
if(!(h<l))return A.a(m,h)
k=m[h]
g=c}else{j&2&&A.b(m)
if(!(n>=0&&n<l))return A.a(m,n)
m[n]=k
if(k<=a9){n=-1
break}if(!(d<l))return A.a(m,d)
k=m[d]
f=c
n=d}}if(h>=0){j&2&&A.b(m)
if(!(h<l))return A.a(m,h)
m[h]=0}if(n>=0){j&2&&A.b(m)
if(!(n<l))return A.a(m,n)
m[n]=0}},
ji(a,b,c,d,e){var s=this.p2
if(s<d)s=d
while(s<c)s+=this.fC(a,b,s,c,d,e)
this.p2=c},
fC(a8,a9,b0,b1,b2,b3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6=A.q(a9,b0,a5.f,a5.e),a7=a5.b
if(!(a6<a7.length))return A.a(a7,a6)
s=a7[a6]
r=b0+2
a7.$flags&2&&A.b(a7)
a7[a6]=r
a7=a5.as
q=(r&a7)<<1>>>0
p=q+1
o=a5.aj(b1,b2,B.a.q(1,a5.a.b))
n=b0>a7?b0-a7:0
m=n>b2?n:b2
l=b0+9
k=a5.d
r=a5.c
j=r.length
i=r.$flags|0
h=a8.length
g=q
f=0
e=0
d=8
for(;;){if(!(k>0&&s!==0))break
c=s-2
if(c<o)break;--k
b=(s&a7)<<1>>>0
a=f<e?f:e
a+=a5.ac(a8,a9,b0+a,c+a,b3)
if(a>d){a0=c+a
if(a0>l)l=a0
d=a}a1=b0+a
if(a1===b3)break
a2=c+a
if(!(a2>=0&&a2<h))return A.a(a8,a2)
a2=a8[a2]
if(!(a1>=0&&a1<h))return A.a(a8,a1)
if(a2<a8[a1]){i&2&&A.b(r)
if(!(g>=0&&g<j))return A.a(r,g)
r[g]=s
if(c<=m){g=-1
break}g=b+1
if(!(g<j))return A.a(r,g)
s=r[g]
f=a}else{i&2&&A.b(r)
if(!(p>=0&&p<j))return A.a(r,p)
r[p]=s
if(c<=m){p=-1
break}if(!(b<j))return A.a(r,b)
s=r[b]
e=a
p=b}}if(g>=0){i&2&&A.b(r)
if(!(g<j))return A.a(r,g)
r[g]=0}if(p>=0){i&2&&A.b(r)
if(!(p<j))return A.a(r,p)
r[p]=0}a3=l-(b0+8)
if(d>384){a4=d-384
a4=a4<192?a4:192
if(a4>a3)a3=a4}return a3},
eN(b9,c0,c1,c2,c3,c4,c5,c6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8=this
if(c1<b8.p2)return 0
b8.ji(b9,c0,c1,c2,c3)
s=b8.ax
r=s-1
q=b8.aj(c1,c2,B.a.q(1,b8.a.b))
p=c5?4:3
o=c5?1:0
n=c1+s
m=s===3
l=b8.dy
k=l.$flags|0
j=b8.fr
i=j.$flags|0
h=0
for(;o<p;++o){if(o===3)g=c4[0]-1
else{if(!(o<3))return A.a(c4,o)
g=c4[o]}f=c1-g
e=!0
if(g>0)if(f>=q){e=b8.p4
if(f<e)e=f>e-4
else e=!1}if(e)continue
d=m?16777215:4294967295
if((c0.getUint32(f,!0)&d)>>>0!==(c0.getUint32(c1,!0)&d)>>>0)continue
c=s+b8.ac(b9,c0,n,f+s,c3)
if(c>r){e=c5?1:0
i&2&&A.b(j)
if(!(h<4096))return A.a(j,h)
j[h]=o-e+1
k&2&&A.b(l)
l[h]=c;++h
if(c>c6||c1+c>=c3)return h
r=c}}if(m&&r<3){f=b8.CW
if(f<c2)f=c2
for(n=b8.ch,m=32-b8.ay,e=n.$flags|0;f<c1;){b=B.a.an(A.w5(c0.getUint32(f,!0)<<8>>>0,506832829),m);++f
e&2&&A.b(n)
if(!(b<n.length))return A.a(n,b)
n[b]=f}b8.CW=c1
m=b8.ky(c0,c1)
if(!(m<n.length))return A.a(n,m)
a=n[m]
a0=a-1
if(a!==0&&a0>=q&&c1-a0<262144){c=b8.ac(b9,c0,c1,a0,c3)
if(c>=3){i&2&&A.b(j)
j[0]=c1-a0+3
k&2&&A.b(l)
l[0]=c
if(c>c6||c1+c>=c3){b8.p2=c1+1
return 1}r=c
h=1}}}a1=A.q(c0,c1,b8.f,b8.e)
n=b8.b
if(!(a1<n.length))return A.a(n,a1)
a=n[a1]
m=c1+2
n.$flags&2&&A.b(n)
n[a1]=m
n=b8.as
a2=(m&n)<<1>>>0
a3=a2+1
a4=c1+9
a5=c1>n?c1-n:0
a6=a5>c2?a5:c2
a7=b8.d
m=b8.c
e=m.length
b=m.$flags|0
a8=b9.length
a9=a2
b0=0
b1=0
for(;;){b2=a7-1
if(!(a7>0&&a!==0))break
a0=a-2
if(a0<q)break
b3=(a&n)<<1>>>0
c=b0<b1?b0:b1
c+=b8.ac(b9,c0,c1+c,a0+c,c3)
if(c>r){b4=a0+c
if(b4>a4)a4=b4
i&2&&A.b(j)
if(!(h<4096))return A.a(j,h)
j[h]=c1-a0+3
k&2&&A.b(l)
l[h]=c;++h
if(c>4096||c1+c>=c3)break
r=c}b5=a0+c
if(!(b5>=0&&b5<a8))return A.a(b9,b5)
b5=b9[b5]
b6=c1+c
if(!(b6>=0&&b6<a8))return A.a(b9,b6)
if(b5<b9[b6]){b&2&&A.b(m)
if(!(a9>=0&&a9<e))return A.a(m,a9)
m[a9]=a
if(a0<=a6){a9=-1
break}a9=b3+1
if(!(a9<e))return A.a(m,a9)
a=m[a9]
b0=c}else{b&2&&A.b(m)
if(!(a3>=0&&a3<e))return A.a(m,a3)
m[a3]=a
if(a0<=a6){a3=-1
break}if(!(b3<e))return A.a(m,b3)
a=m[b3]
b1=c
a3=b3}a7=b2}if(a9>=0){b&2&&A.b(m)
if(!(a9<e))return A.a(m,a9)
m[a9]=0}if(a3>=0){b&2&&A.b(m)
if(!(a3<e))return A.a(m,a3)
m[a3]=0}b7=a4-8
n=c1+1
b8.p2=b7>n?b7:n
return h},
dG(a,b,c,d){var s,r,q,p,o,n=a*3,m=b*3
if(c>3){s=this.k3
r=m+2
q=n+1
if(!(q>=0&&q<12297))return A.a(s,q)
q=s[q]
s.$flags&2&&A.b(s)
if(!(r<12297))return A.a(s,r)
s[r]=q
q=m+1
if(!(n>=0&&n<12297))return A.a(s,n)
r=s[n]
if(!(q<12297))return A.a(s,q)
s[q]=r
if(!(m<12297))return A.a(s,m)
s[m]=c-3
return}s=d?1:0
p=c-1+s
if(p===0){s=this.k3
if(!(n>=0&&n<12297))return A.a(s,n)
r=s[n]
s.$flags&2&&A.b(s)
if(!(m<12297))return A.a(s,m)
s[m]=r
r=m+1
q=n+1
if(!(q<12297))return A.a(s,q)
q=s[q]
if(!(r<12297))return A.a(s,r)
s[r]=q
q=m+2
r=n+2
if(!(r<12297))return A.a(s,r)
r=s[r]
if(!(q<12297))return A.a(s,q)
s[q]=r
return}s=this.k3
if(p===3){if(!(n>=0&&n<12297))return A.a(s,n)
o=s[n]-1}else{r=n+p
if(!(r>=0&&r<12297))return A.a(s,r)
o=s[r]}r=m+2
if(p>=2){q=n+1
if(!(q>=0&&q<12297))return A.a(s,q)
q=s[q]}else{q=n+2
if(!(q>=0&&q<12297))return A.a(s,q)
q=s[q]}s.$flags&2&&A.b(s)
if(!(r<12297))return A.a(s,r)
s[r]=q
q=m+1
if(!(n>=0&&n<12297))return A.a(s,n)
r=s[n]
if(!(q<12297))return A.a(s,q)
s[q]=r
if(!(m<12297))return A.a(s,m)
s[m]=o},
fJ(e2,e3,e4,e5,e6,e7,e8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3,d4,d5,d6,d7=this,d8=e5-8,d9=d7.k4,e0=d7.a,e1=e0.r
d9.ch=e1>2?2:e1
d9.m_(e2,e4,e5)
e1=d7.ok
s=d7.p1
e1.a=s
r=s==null
q=r?null:s.e
e1.b=q==null?0:q
q=r?null:s.f
e1.c=q==null?0:q
e1.f=e1.e=e1.d=0
if(!r)e1.h4(s,0,e5-e4)
p=e0.f
p=p<4095?p:4095
e0=d7.p4
o=e4===(e6>e0?e6:e0)?e4+1:e4
e0=d7.p2
d7.CW=e0<e6?d7.p2=e6:e0
for(e0=d7.k1,s=d7.id,r=d7.k2,q=s.$flags|0,n=r.$flags|0,m=e0.$flags|0,l=d7.k3,k=d7.go,j=k.$flags|0,i=l.$flags|0,h=d7.dy,g=d7.fr,f=d7.ax,e=d7.fy,d=e.$flags|0,c=e4;o<d8;){b=o-c
a=e1.hX(h,g,d7.eN(e2,e3,o,e6,e5,e8,b===0,p),o-e4,e5-o,f)
if(a===0){++o
continue}q&2&&A.b(s)
s[0]=0
m&2&&A.b(e0)
e0[0]=b
a0=d9.aH(b)
j&2&&A.b(k)
k[0]=a0
a0=e8[0]
i&2&&A.b(l)
l[0]=a0
l[1]=e8[1]
l[2]=e8[2]
a0=a-1
if(!(a0>=0&&a0<4096))return A.a(h,a0)
a1=h[a0]
a2=a1>p
if(a2){a3=g[a0]
a4=a1
a5=a4}else{a5=0
a4=0
a3=0}a6=0
if(!a2){for(a7=1;a7<f;++a7){if(!(a7<4099))return A.a(k,a7)
k[a7]=1073741824
s[a7]=0
e0[a7]=b+a7}for(a8=0;a8<a;++a8){if(!(a8<4096))return A.a(g,a8)
a9=g[a8]
b0=h[a8]
if(d9.ch===0)for(;a7<=b0;++a7){if(!(a7>=0&&a7<4099))return A.a(s,a7)
s[a7]=a7
n&2&&A.b(r)
r[a7]=a9
e0[a7]=0
k[a7]=k[0]+d9.hT(a9,a7)+d9.aH(0)}else{b1=d9.hS(a9)
for(;a7<=b0;++a7){if(!(a7>=0&&a7<4099))return A.a(s,a7)
s[a7]=a7
n&2&&A.b(r)
r[a7]=a9
e0[a7]=0
k[a7]=k[0]+b1+d9.hR(a7)+d9.aH(0)}}}a5=a7-1
if(!(a7>=0&&a7<4099))return A.a(k,a7)
k[a7]=1073741824
for(b2=1;a2=!1,b2<=a5;++b2){b3=o+b2
a0=b2-1
if(!(a0<4099))return A.a(e0,a0)
b4=e0[a0]+1
b5=k[a0]+d9.el(e2,b3-1,1)+d9.aH(b4)-d9.aH(b4-1)
if(!(b2<4099))return A.a(k,b2)
b6=k[b2]
if(b5<=b6){b7=s[b2]
b8=r[b2]
b9=e0[b2]
k[b2]=b5
s[b2]=s[a0]
c0=r[a0]
n&2&&A.b(r)
r[b2]=c0
e0[b2]=b4
c1=a0*3
c2=b2*3
if(!(c1<12297))return A.a(l,c1)
a0=l[c1]
if(!(c2<12297))return A.a(l,c2)
l[c2]=a0
a0=c2+1
c0=c1+1
if(!(c0<12297))return A.a(l,c0)
c0=l[c0]
if(!(a0<12297))return A.a(l,a0)
l[a0]=c0
c0=c2+2
a0=c1+2
if(!(a0<12297))return A.a(l,a0)
a0=l[a0]
if(!(c0<12297))return A.a(l,c0)
l[c0]=a0
c3=d9.aH(1)-d9.aH(0)
if(d9.ch>=1&&b9===0&&c3<0&&b3<e5){c4=b6+d9.el(e2,b3,1)+c3
if(c4<b5+d9.el(e2,b3,1)+d9.aH(b4+1)-d9.aH(b4)){a0=b2+1
if(!(a0<4099))return A.a(k,a0)
a0=c4<k[a0]}else a0=!1
if(a0){c5=b2-b7
a0=b2+1
if(!(a0<4099))return A.a(s,a0)
s[a0]=b7
r[a0]=b8
if(!(c5>=0&&c5<4099))return A.a(e0,c5)
d7.dG(c5,a0,b8,e0[c5]===0)
e0[a0]=1
k[a0]=c4
if(a5<a0)a5=a0}}}if(e0[b2]===0){a0=b2-s[b2]
b6=r[b2]
if(!(a0>=0&&a0<4099))return A.a(e0,a0)
d7.dG(a0,b2,b6,e0[a0]===0)}if(b3>d8)continue
if(b2===a5)break
if(d9.ch===0){a0=b2+1
if(!(a0<4099))return A.a(k,a0)
a0=k[a0]<=k[b2]+128}else a0=!1
if(a0)continue
c6=k[b2]+d9.aH(0)
c7=b2*3
if(!(c7<12297))return A.a(l,c7)
a0=l[c7]
d&2&&A.b(e)
e[0]=a0
a0=c7+1
if(!(a0<12297))return A.a(l,a0)
e[1]=l[a0]
a0=c7+2
if(!(a0<12297))return A.a(l,a0)
e[2]=l[a0]
a=e1.hX(h,g,d7.eN(e2,e3,b3,e6,e5,e,e0[b2]===0,p),b3-e4,e5-b3,f)
if(a===0)continue
a0=a-1
if(!(a0>=0&&a0<4096))return A.a(h,a0)
c8=h[a0]
if(c8>p||b2+c8>=4096||b3+c8>=e5){a3=g[a0]
a5=b2+c8
a4=c8
a2=!0
break}for(a8=0;a8<a;++a8){if(!(a8<4096))return A.a(g,a8)
a9=g[a8]
b0=h[a8]
c9=a8>0?h[a8-1]+1:f
if(d9.ch===0)for(d0=b0;d0>=c9;--d0){a7=b2+d0
d1=c6+d9.hT(a9,d0)
if(a7<=a5){if(!(a7>=0&&a7<4099))return A.a(k,a7)
a0=d1<k[a7]}else a0=!0
if(a0){while(a5<a7){++a5
if(!(a5>=0&&a5<4099))return A.a(k,a5)
k[a5]=1073741824
e0[a5]=1}if(!(a7>=0&&a7<4099))return A.a(s,a7)
s[a7]=d0
n&2&&A.b(r)
r[a7]=a9
e0[a7]=0
k[a7]=d1}else break}else for(a0=c6+d9.hS(a9),d0=b0;d0>=c9;--d0){a7=b2+d0
d1=a0+d9.hR(d0)
if(a7<=a5){if(!(a7>=0&&a7<4099))return A.a(k,a7)
b6=d1<k[a7]}else b6=!0
if(b6){while(a5<a7){++a5
if(!(a5>=0&&a5<4099))return A.a(k,a5)
k[a5]=1073741824
e0[a5]=1}if(!(a7>=0&&a7<4099))return A.a(s,a7)
s[a7]=d0
n&2&&A.b(r)
r[a7]=a9
e0[a7]=0
k[a7]=d1}}}a0=a5+1
if(!(a0>=0&&a0<4099))return A.a(k,a0)
k[a0]=1073741824}if(!a2){if(!(a5>=0&&a5<4099))return A.a(s,a5)
a4=s[a5]
a6=e0[a5]
a3=r[a5]
b2=a5-a4}}else b2=0
if(a4===0){o+=a5
continue}if(a6===0){if(!(b2>=0&&b2<4099))return A.a(e0,b2)
d7.dG(b2,4098,a3,e0[b2]===0)
a0=l[12294]
e8.$flags&2&&A.b(e8)
if(0>=3)return A.a(e8,0)
e8[0]=a0
a0=l[12295]
if(1>=3)return A.a(e8,1)
e8[1]=a0
a0=l[12296]
if(2>=3)return A.a(e8,2)
e8[2]=a0}else{a0=a5*3
if(!(a0>=0&&a0<12297))return A.a(l,a0)
b6=l[a0]
e8.$flags&2&&A.b(e8)
if(0>=3)return A.a(e8,0)
e8[0]=b6
b6=a0+1
if(!(b6<12297))return A.a(l,b6)
b6=l[b6]
if(1>=3)return A.a(e8,1)
e8[1]=b6
a0+=2
if(!(a0<12297))return A.a(l,a0)
a0=l[a0]
if(2>=3)return A.a(e8,2)
e8[2]=a0
b2-=a6}d2=b2+2
if(!(d2>=0&&d2<4099))return A.a(s,d2)
s[d2]=a4
n&2&&A.b(r)
r[d2]=a3
e0[d2]=a6
for(d3=b2,d4=d2;;){if(!(d3>=0&&d3<4099))return A.a(s,d3)
d0=s[d3]
d5=e0[d3]
d6=r[d3]
if(!(d4>=0))return A.a(e0,d4)
e0[d4]=d5
if(d0===0)break;--d4
if(!(d4>=0))return A.a(s,d4)
s[d4]=d0
r[d4]=d6
e0[d4]=d5
d3-=d5+d0}for(c7=d4;c7<=d2;++c7){if(!(c7>=0))return A.a(e0,c7)
d5=e0[c7]
d0=s[c7]
a9=r[c7]
if(d0===0){o=c+d5
continue}d9.lY(e2,c,d5,a9,d0)
e7.ao(0,e2,c,d5,a9,d0-3)
c+=d5+d0
o=c}d9.cX()}e7.bz(e2,c,e5)},
jD(a,b){var s=this,r=s.p2
if(s.rx||r===b){s.p2=b
return}if(b-r>384){s.ds(a,r,r+96)
r=b-32}s.ds(a,r,b)
s.p2=b},
fB(a,b,c){var s,r,q,p=this,o=B.a.q(a,p.r),n=p.db,m=p.dx,l=(o^m)>>>0,k=n.length
if(!(l<k))return A.a(n,l)
s=p.x
r=(n[l]-1&s)>>>0
s=r===0?s:r
n.$flags&2&&A.b(n)
n[l]=s
l=p.cx
q=(o|s)>>>0
l.$flags&2&&A.b(l)
if(!(q<l.length))return A.a(l,q)
l[q]=c+1
m=(q^m)>>>0
if(!(m<k))return A.a(n,m)
n[m]=b},
ds(a,b,c){var s,r,q,p
for(s=this.Q,r=this.f,q=b;q<c;){p=A.q(a,q,r,s)
this.fB(p>>>8,p&255,q);++q}},
b_(a,b,c,d,e){return A.nk(a,b,c,d,e)},
ac(a,b,c,d,e){return A.nk(a,b,c,d,e)},
ky(a,b){var s=a.getUint32(b,!0)<<8,r=s&65535
return B.a.an(r*42941+((s>>>16)*42941+r*7733&65535)*65536>>>0,32-this.ay)}}
A.jW.prototype={
ak(a){var s=a+1,r=B.a.gX(s)-1
if(this.ch===0)return r<<8>>>0
return(r<<8>>>0)+B.a.b3(s<<8>>>0,r)},
m_(a,b,c){var s,r,q,p,o,n,m,l=this
l.CW=!1
if(l.f===0){if(c-b<=8)l.CW=!0
s=l.cx
if(s!=null){l.kt(s)
l.fQ()
l.cX()
return}r=l.a
B.f.F(r,0,256,0)
for(q=a.length,p=r.$flags|0,o=b;o<c;++o){if(!(o>=0&&o<q))return A.a(a,o)
n=a[o]
if(!(n<256))return A.a(r,n)
m=r[n]
p&2&&A.b(r)
r[n]=m+1}l.e=l.ff(r,8,!1)
r=l.b
B.f.F(r,0,36,1)
r.$flags&2&&A.b(r)
r[0]=4
r[1]=2
l.f=A.mF(r)
B.f.F(l.c,0,53,1)
l.r=53
r=l.d
B.f.F(r,0,32,1)
for(q=r.$flags|0,o=0;o<11;++o){p=B.c_[o]
q&2&&A.b(r)
r[o]=p}l.w=A.mF(r)}else{l.e=l.cr(l.a,12)
l.f=l.cr(l.b,11)
l.r=l.cr(l.c,11)
l.w=l.cr(l.d,11)}l.fQ()
l.cX()},
kt(a){var s,r,q,p,o,n,m,l=this
l.CW=!1
l.e=0
for(s=l.a,r=s.$flags|0,q=a.b,p=0,o=0;p<256;++p){n=p>a.r?0:q[p]
m=n!==0?B.a.p(1,11-n):1
r&2&&A.b(s)
s[p]=m
o+=m
l.e=o}l.f=A.mE(l.b,l.cy,36)
l.r=A.mE(l.c,l.dx,53)
l.w=A.mE(l.d,l.db,32)},
fQ(){var s,r,q,p,o,n=this
for(s=n.x,r=n.a,q=s.$flags|0,p=0;p<256;++p){o=n.ak(r[p])
q&2&&A.b(s)
s[p]=o}for(s=n.y,r=n.b,q=s.$flags|0,p=0;p<36;++p){o=n.ak(r[p])
q&2&&A.b(s)
s[p]=o}for(s=n.z,r=n.c,q=s.$flags|0,p=0;p<53;++p){o=n.ak(r[p])
q&2&&A.b(s)
s[p]=o}for(s=n.Q,r=n.d,q=s.$flags|0,p=0;p<32;++p){o=n.ak(r[p])
q&2&&A.b(s)
s[p]=o}},
cX(){var s=this
s.as=s.ak(s.e)
s.at=s.ak(s.f)
s.ax=s.ak(s.r)
s.ay=s.ak(s.w)},
ff(a,b,c){var s,r,q,p,o,n
for(s=a.length,r=a.$flags|0,q=0,p=0;p<s;++p){if(c)o=1
else o=a[p]>0?1:0
n=o+B.a.b3(a[p],b)
r&2&&A.b(a)
a[p]=n
q+=n}return q},
cr(a,b){var s=A.mF(a),r=B.a.ba(s,b)
if(r<=1)return s
return this.ff(a,B.a.gX(r)-1,!0)},
el(a,b,c){var s,r,q,p,o,n,m
if(c===0)return 0
if(this.CW)return c*6*256
s=this.as
r=s*c
q=s-256
for(s=this.x,p=a.length,o=0;o<c;++o){n=b+o
if(!(n>=0&&n<p))return A.a(a,n)
n=a[n]
if(!(n<256))return A.a(s,n)
m=s[n]
r-=m>q?q:m}return r},
aH(a){var s,r,q,p,o=this
if(o.CW)return o.ak(a)
if(a===131072)return 256+o.aH(131071)
s=A.pQ(a)
r=$.hq()
if(!(s>=0&&s<r.length))return A.a(r,s)
r=r[s]
q=o.at
p=o.y
if(!(s<36))return A.a(p,s)
return(r<<8>>>0)+q-p[s]},
hT(a,b){var s,r,q,p,o,n=this,m=B.a.gX(a)-1,l=b-3
if(n.CW)return n.ak(l)+(16+m<<8>>>0)
s=n.ay
r=n.Q
if(!(m>=0&&m<32))return A.a(r,m)
q=(m<<8>>>0)+(s-r[m])
if(n.ch<2&&m>=20)q+=(m-19)*2*256
p=A.nf(l)
s=$.eQ()
if(!(p>=0&&p<s.length))return A.a(s,p)
s=s[p]
r=n.ax
o=n.z
if(!(p<53))return A.a(o,p)
return q+((s<<8>>>0)+(r-o[p]))+51},
hS(a){var s,r,q,p=this,o=B.a.gX(a)-1
if(p.CW)return 16+o<<8>>>0
s=p.ay
r=p.Q
if(!(o>=0&&o<32))return A.a(r,o)
q=(o<<8>>>0)+(s-r[o])
return(p.ch<2&&o>=20?q+(o-19)*2*256:q)+51},
hR(a){var s,r,q,p,o=this,n=a-3
if(o.CW)return o.ak(n)
s=A.nf(n)
r=$.eQ()
if(!(s>=0&&s<r.length))return A.a(r,s)
r=r[s]
q=o.ax
p=o.z
if(!(s<53))return A.a(p,s)
return(r<<8>>>0)+(q-p[s])},
lY(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i,h,g=this
for(s=a.length,r=g.a,q=r.$flags|0,p=g.x,o=p.$flags|0,n=0;n<c;++n){m=b+n
if(!(m>=0&&m<s))return A.a(a,m)
l=a[m]
if(!(l<256))return A.a(r,l)
k=r[l]+2
q&2&&A.b(r)
r[l]=k
m=g.ak(k)
o&2&&A.b(p)
p[l]=m}g.e=g.e+c*2
j=A.pQ(c)
s=g.y
r=g.b
if(!(j>=0&&j<36))return A.a(r,j)
q=r[j]+1
r.$flags&2&&A.b(r)
r[j]=q
q=g.ak(q)
s.$flags&2&&A.b(s)
s[j]=q;++g.f
i=B.a.gX(d)-1
q=g.Q
s=g.d
if(!(i>=0&&i<32))return A.a(s,i)
r=s[i]+1
s.$flags&2&&A.b(s)
s[i]=r
r=g.ak(r)
q.$flags&2&&A.b(q)
q[i]=r;++g.w
h=A.nf(e-3)
r=g.z
q=g.c
if(!(h>=0&&h<53))return A.a(q,h)
s=q[h]+1
q.$flags&2&&A.b(q)
q[h]=s
s=g.ak(s)
r.$flags&2&&A.b(r)
r[h]=s;++g.r}}
A.jX.prototype={
lk(a,b,c,d){var s,r,q,p=this
p.b=0
s=b.r
if(s<=4)return 0
p.c=a
p.d=b
p.e=c
p.f=d
p.dV(0,s)
r=p.a
q=p.b
r.$flags&2&&A.b(r)
if(!(q<198))return A.a(r,q)
r[q]=s
return q},
dV(a,b){var s,r,q,p,o=this
if(b-a<300||o.b>=196)return
s=B.a.t(a+b,2)
r=o.dr(a,b)
if(o.dr(a,s)+o.dr(s,b)<r){o.dV(a,s)
q=o.a
p=o.b++
q.$flags&2&&A.b(q)
if(!(p<198))return A.a(q,p)
q[p]=s
o.dV(s,b)}},
dr(a,b){var s,r,q,p=this,o=p.d
o===$&&A.c()
s=o.cM(0,a)
o=p.d
r=b===o.r?o.e:s+o.cM(a,b)
o=p.e
o===$&&A.c()
q=p.c
q===$&&A.c()
q=o.ee(q,p.d.a,s,r)
o=p.f
o===$&&A.c()
return q+o.ee(p.c,p.d,a,b)+3}}
A.k1.prototype={
n(a){return"ZstdSequencesException: "+this.a}}
A.jZ.prototype={
glN(){var s=this.r
if(s===$)s=this.r=new Uint8Array(8)
return s},
em(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this
for(s=a.w,r=a.x,q=a.y,p=f.a,o=p.$flags|0,n=f.b,m=n.$flags|0,l=f.c,k=l.$flags|0,j=0;j<3;++j){i=B.M[j]
if(!(j<s.length))return A.a(s,j)
h=s[j]
if(!(j<r.length))return A.a(r,j)
g=r[j]
if(!(j<q.length))return A.a(q,j)
f.e8(i,j,h,g,q[j])
g=B.M[j]
o&2&&A.b(p)
p[j]=g
if(!(j<q.length))return A.a(q,j)
g=q[j]
m&2&&A.b(n)
n[j]=g
k&2&&A.b(l)
l[j]=2}},
l6(a,b,c,a0,a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this
if(b>=c)A.uQ()
s=b
m=B.c.l(a,s)
r=null
if(m<128){r=m
l=s
if(typeof l!=="number")return l.R()
s=l+1}else if(m<255){l=s
if(typeof l!=="number")return l.R()
if(l+2>c)A.pn()
l=s
if(typeof l!=="number")return l.R();++l
if(l>>>0!==l||l>=a.length)return A.a(a,l)
r=(m-128<<8>>>0)+a[l]
l=s
if(typeof l!=="number")return l.R()
s=l+2}else{l=s
if(typeof l!=="number")return l.R()
if(l+3>c)A.pn()
l=s
if(typeof l!=="number")return l.R();++l
k=a.length
if(l>>>0!==l||l>=k)return A.a(a,l)
l=a[l]
j=s
if(typeof j!=="number")return j.R()
j+=2
if(j>>>0!==j||j>=k)return A.a(a,j)
r=l+(a[j]<<8>>>0)+32512
j=s
if(typeof j!=="number")return j.R()
s=j+3}if(J.T(r,0)){if(!J.T(s,c))A.tS()
i=a0.c
if(i>a3)A.ty()
s=a1.e
l=a1.c
k=s+i
B.c.H(l,s,k,l,s+a3+64)
a1.e=k
return}l=s
if(typeof l!=="number")return l.cW()
if(l>=c)A.tH()
h=B.c.l(a,s)
l=s
if(typeof l!=="number")return l.R()
s=l+1
if((h&3)!==0)A.uE()
l=s
k=d.dQ(a,s,c,0,h>>>6&3)
if(typeof l!=="number")return l.R()
s=l+k
k=s
l=d.dQ(a,s,c,1,h>>>4&3)
if(typeof k!=="number")return k.R()
s=k+l
l=s
k=d.dQ(a,s,c,2,h>>>2&3)
if(typeof l!=="number")return l.R()
s=l+k
k=s
if(typeof k!=="number")return A.Z(k)
q=c-k
l=q
if(typeof l!=="number")return l.bD()
if(l<=0)A.uP()
p=null
o=4
try{l=q
k=o
if(typeof l!=="number")return l.cW()
if(typeof k!=="number")return A.Z(k)
if(l>=k)p=d.i1(a,A.al(a),s,q,a0,a1,a2,r,a3)
else{l=d.glN()
B.c.F(l,0,o,0)
k=o
j=q
if(typeof k!=="number")return k.R()
if(typeof j!=="number")return A.Z(j)
B.c.H(l,o,k+j,a,s)
g=d.w
if(g===$){f=A.al(l)
d.w!==$&&A.bC()
d.w=f
g=f}p=d.i1(l,g,o,q,a0,a1,a2,r,a3)}}catch(e){l=A.G(e)
if(t.b8.b(l)){n=l
A.up(n)}else throw e}a1.sA(p)},
dQ(a,b,c,d,e){var s,r,q,p,o,n=this
if(!(d<3))return A.a(B.M,d)
s=B.M[d]
switch(e){case 0:r=n.a
q=B.bl[d]
r.$flags&2&&A.b(r)
r[d]=q
q=n.b
r=B.bs[d]
q.$flags&2&&A.b(q)
q[d]=r
r=n.c
r.$flags&2&&A.b(r)
r[d]=1
return 0
case 1:if(b>=c)A.uJ()
if(!(b<a.length))return A.a(a,b)
p=a[b]
if(p>B.aa[d])A.uI(p)
r=n.x
r.$flags&2&&A.b(r)
if(!(s<1440))return A.a(r,s)
r[s]=s
r=n.y
r.$flags&2&&A.b(r)
r[s]=0
r=n.z
q=$.nD()[d]
if(!(p<q.length))return A.a(q,p)
q=q[p]
r.$flags&2&&A.b(r)
r[s]=q
q=n.Q
r=$.nC()[d]
if(!(p<r.length))return A.a(r,p)
r=r[p]
q.$flags&2&&A.b(q)
q[s]=r
r=n.a
r.$flags&2&&A.b(r)
r[d]=s
r=n.b
r.$flags&2&&A.b(r)
r[d]=0
r=n.c
r.$flags&2&&A.b(r)
r[d]=2
return 1
case 2:r=n.d
o=A.pJ(a,b,c,r,B.aa[d],B.bv[d])
q=o.c
n.e8(s,d,r,o.b,q)
r=n.a
r.$flags&2&&A.b(r)
r[d]=s
r=n.b
r.$flags&2&&A.b(r)
r[d]=q
q=n.c
q.$flags&2&&A.b(q)
q[d]=2
return o.d
default:if(n.c[d]===0)A.uD()
return 0}}}
A.k0.prototype={
n(a){return"ZstdSequencesEncoderException: "+this.a}}
A.jY.prototype={
ao(a,b,c,d,e,f){var s,r,q,p,o,n=this
if(d>0){s=n.e
B.c.H(n.a,s,s+d,b,c)
n.e+=d}s=n.r
r=s<<2>>>0
q=n.f
q.$flags&2&&A.b(q)
p=q.length
if(!(r<p))return A.a(q,r)
q[r]=d
o=r+1
if(!(o<p))return A.a(q,o)
q[o]=f
o=r+2
if(!(o<p))return A.a(q,o)
q[o]=e
n.r=s+1},
cM(a,b){var s,r,q,p,o
for(s=a*4,r=b*4,q=this.f,p=q.length,o=0;s<r;s+=4){if(!(s<p))return A.a(q,s)
o+=q[s]}return o},
lK(a,b){var s,r,q,p,o,n
for(s=a*4,r=b*4,q=this.f,p=q.length,o=0;s<r;s+=4){n=s+1
if(!(n<p))return A.a(q,n)
o+=q[n]+3}return o},
bz(a,b,c){var s,r=c-b
if(r>0){s=this.e
B.c.H(this.a,s,s+r,a,b)
this.e+=r}}}
A.ey.prototype={
aG(){var s,r=this
if(r.r){s=r.a
r.a=r.b
r.b=s}r.c=r.d
r.e=r.f}}
A.k_.prototype={
lo(a,b,c,d,e){var s,r,q,p,o,n,m=this,l=e-d
m.fu()
if(l<128){s=b+1
a.$flags&2&&A.b(a)
if(!(b>=0&&b<a.length))return A.a(a,b)
a[b]=l}else{s=b+1
r=a.$flags|0
q=s+1
if(l<32512){p=B.a.k(l,8)
r&2&&A.b(a)
r=a.length
if(!(b>=0&&b<r))return A.a(a,b)
a[b]=p+128
if(!(s>=0&&s<r))return A.a(a,s)
a[s]=l&255
s=q}else{r&2&&A.b(a)
r=a.length
if(!(b>=0&&b<r))return A.a(a,b)
a[b]=255
p=l-32512
if(!(s>=0&&s<r))return A.a(a,s)
a[s]=p&255
s=q+1
p=B.a.k(p,8)
if(!(q>=0&&q<r))return A.a(a,q)
a[q]=p}}if(l===0)return s-b
m.f_(c,d,e)
q=s+1
r=m.fc(a,q,c,l,e)
p=m.as
o=m.at
n=m.ax
a.$flags&2&&A.b(a)
if(!(s>=0&&s<a.length))return A.a(a,s)
a[s]=(p<<6|o<<4|n<<2)>>>0
return m.kJ(a,q+r,c,d,e)-b},
ee(a,b,c,d){var s=this,r=d-c,q=r>=128?1:0,p=r>=32512?1:0,o=2+q+p
if(r===0)return o
s.fu()
s.f_(b,c,d)
return o+s.fc(a,0,b,r,d)+A.mG(s.as,s.a,35,s.x,$.m5(),6,$.hq(),r)+A.mG(s.at,s.b,31,s.y,$.m7(),5,null,r)+A.mG(s.ax,s.c,52,s.z,$.m6(),6,$.eQ(),r)},
fu(){var s,r,q,p
for(s=[this.x,this.y,this.z],r=s.length,q=0;q<r;++q){p=s[q]
p.r=!1
p.d=p.c
p.f=p.e}},
f_(a7,a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6=this.a
B.f.F(a6,0,64,0)
s=this.b
B.f.F(s,0,32,0)
r=this.c
B.f.F(r,0,64,0)
q=$.nA()
p=$.nB()
o=$.hq()
n=$.eQ()
m=a7.f
l=a9*4
for(k=a8*4,j=m.length,i=o.length,h=n.length,g=a6.$flags|0,f=s.$flags|0,e=r.$flags|0,d=q.length,c=p.length;k<l;k+=4){if(!(k<j))return A.a(m,k)
b=m[k]
if(b<64){if(!(b>=0&&b<d))return A.a(q,b)
a=q[b]}else a=A.db(b)+19
a0=k+1
if(!(a0<j))return A.a(m,a0)
a1=m[a0]
if(a1<128){if(!(a1>=0&&a1<c))return A.a(p,a1)
a2=p[a1]}else a2=A.db(a1)+36
a0=k+2
if(!(a0<j))return A.a(m,a0)
a3=A.db(m[a0])
a0=k+3
if(!(a>=0&&a<i))return A.a(o,a)
a4=o[a]
if(!(a2>=0&&a2<h))return A.a(n,a2)
a5=n[a2]
m.$flags&2&&A.b(m)
if(!(a0<j))return A.a(m,a0)
m[a0]=(a|a2<<6|a3<<12|a4<<18|a5<<23)>>>0
a5=a&63
a4=a6[a5]
g&2&&A.b(a6)
a6[a5]=a4+1
a4=a3&31
a5=s[a4]
f&2&&A.b(s)
s[a4]=a5+1
a5=a2&63
a4=r[a5]
e&2&&A.b(r)
r[a5]=a4+1}},
fc(a,b,c,d,e){var s,r,q,p,o,n=this,m=c.f,l=(e-1<<2>>>0)+3
if(!(l<m.length))return A.a(m,l)
s=m[l]
r=n.e1(a,b,n.a,d,35,9,$.m5(),6,n.x,s&63)
q=b+r.b
p=n.e1(a,q,n.b,d,31,8,$.m7(),5,n.y,B.a.k(s,12)&63)
q+=p.b
o=n.e1(a,q,n.c,d,52,9,$.m6(),6,n.z,B.a.k(s,6)&63)
n.as=r.a
n.at=p.a
n.ax=o.a
return q+o.b-b},
e1(a,b,a0,a1,a2,a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c=1099511627776
a6.f=a6.d=a6.r=!1
for(s=a0.length,r=0,q=0,p=0,o=0;o<=a2;++o){if(!(o<s))return A.a(a0,o)
n=a0[o]
if(n===0)continue
if(n>q){q=n
r=o}p=o}m=a4.length-1
l=p<=m
if(q===a1){if(l&&a1<=2)return d.dZ(a4,m,a5,a6)
a.$flags&2&&A.b(a)
if(!(b>=0&&b<a.length))return A.a(a,b)
a[b]=r
d.iF(a6.b,r)
a6.r=!0
return B.cd}s=d.Q
if(s<3){if(l&&a6.e&&a1<1000){a6.f=a6.d=!0
return B.av}k=B.a.k(B.a.q(1,a5)*(9-s),3)
if(l)s=a1<k||q<B.a.aJ(a1,a5-1)
else s=!1
if(s)return d.dZ(a4,m,a5,a6)
j=A.nh(a3,a1,p)
d.fb(a0,a1,p,j,a7)
s=d.d
i=A.lZ(a,b,s,p,j)
a6.b.bt(s,p,j,d.e,d.f,d.r)
a6.d=a6.r=!0
return new A.bw(2,i)}j=A.nh(a3,a1,p)
h=l?A.oB(a4,a5,a0,p):c
g=a6.c?A.oA(a6.a,a0,p):-1
f=g<0?c:B.a.k(g,8)
s=d.d
A.ng(s,a0,a1,p,j,a1>=2048)
e=(A.lZ(d.w,0,s,p,j)<<3>>>0)+A.rT(a0,p,a1)
if(l&&h<=f&&h<=e)return d.dZ(a4,m,a5,a6)
if(f<=e){a6.d=!0
a6.f=a6.e
return B.av}d.fb(a0,a1,p,j,a7)
i=A.lZ(a,b,s,p,j)
a6.b.bt(s,p,j,d.e,d.f,d.r)
a6.d=a6.r=!0
return new A.bw(2,i)},
fb(a,b,c,d,e){var s,r,q
if(!(e<a.length))return A.a(a,e)
s=a[e]
if(s>1){a.$flags&2&&A.b(a)
a[e]=s-1
r=b-1}else r=b
q=A.ng(this.d,a,r,c,d,r>=2048)
a.$flags&2&&A.b(a)
a[e]=s
if(!q)throw A.d(new A.k0("One code takes every sequence",null,null))},
dZ(a,b,c,d){d.b.bt(a,b,c,this.e,this.f,this.r)
d.r=!0
return B.cc},
em(a){var s,r=this
if(!a.e)return
s=a.x
if(0>=s.length)return A.a(s,0)
r.dC(r.x,a,0,s[0])
r.dC(r.y,a,1,31)
if(2>=s.length)return A.a(s,2)
r.dC(r.z,a,2,s[2])},
dC(a,b,c,d){var s,r=a.a,q=b.w
if(!(c<q.length))return A.a(q,c)
q=q[c]
s=b.y
if(!(c<s.length))return A.a(s,c)
r.bt(q,d,s[c],this.e,this.f,this.r)
a.e=a.c=!0},
aG(){this.x.aG()
this.y.aG()
this.z.aG()},
iF(a,b){var s,r,q,p=this
for(s=p.d,r=s.$flags|0,q=0;q<=b;++q){r&2&&A.b(s)
if(!(q<53))return A.a(s,q)
s[q]=0}r&2&&A.b(s)
if(!(b<53))return A.a(s,b)
s[b]=1
a.bt(s,b,0,p.e,p.f,p.r)},
kJ(a0,a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=new A.ea(A.al(a0),a1),b=this.x,a=b.r?b.b:b.a
b=this.y
s=b.r?b.b:b.a
b=this.z
r=b.r?b.b:b.a
q=a2.f
p=(a4-1)*4
b=p+3
o=q.length
if(!(b>=0&&b<o))return A.a(q,b)
n=q[b]
m=r.bh(B.a.k(n,6)&63)
b=B.a.k(n,12)&63
l=s.bh(b)
k=a.bh(n&63)
if(!(p>=0&&p<o))return A.a(q,p)
c.W(0,q[p],B.a.k(n,18)&31)
j=p+1
if(!(j<o))return A.a(q,j)
c.W(0,q[j],B.a.k(n,23)&31)
c.T()
j=p+2
if(!(j<o))return A.a(q,j)
c.W(0,q[j],b)
c.T()
i=a3*4
for(a1=p-4;a1>=i;a1-=4){b=a1+3
if(!(b<o))return A.a(q,b)
h=q[b]
g=B.a.k(h,12)&63
f=B.a.k(h,18)&31
e=B.a.k(h,23)&31
d=g+e+f
l=s.aM(c,l,g)
m=r.aM(c,m,B.a.k(h,6)&63)
k=a.aM(c,k,h&63)
if(d>=31)c.T()
if(!(a1<o))return A.a(q,a1)
c.W(0,q[a1],f)
b=a1+1
if(!(b<o))return A.a(q,b)
c.W(0,q[b],e)
if(d>56)c.T()
b=a1+2
if(!(b<o))return A.a(q,b)
c.W(0,q[b],g)
c.T()}c.W(0,m,r.c)
c.T()
c.W(0,l,s.c)
c.T()
c.W(0,k,a.c)
c.T()
return c.al()}}
A.fK.prototype={
fe(a,b,c,d){var s
this.c=B.a.a2(a,d)
s=B.a.E(a,d)*2097152+b
this.d=B.a.a2(s,d)
this.e=B.a.a2(B.a.E(s,d)*2097152+c,d)},
fH(a){var s=this,r=2097152,q=a*s.e,p=a*s.d+B.a.t(q,r)
s.w=B.a.E(q,r)
s.r=B.a.E(p,r)
s.f=a*s.c+B.a.t(p,r)}}
A.k2.prototype={
gi(a){return this.f+this.e-this.w},
aY(a){var s,r,q,p=this,o=p.e
if(o+a<=p.d)return
s=p.w
if(s>0&&o-s>=p.a){r=p.c
B.c.H(r,0,o-s,r,s)
s=p.e
r=p.w
s=p.e=s-r
o=p.y
p.y=o>r?o-r:0
o=p.w=0
q=s
s=o
o=q}if(s===0&&a===p.x&&o>=p.a+a){p.dv(p.b,p.y,o)
o=p.f
s=p.e
p.f=o+s
p.r=s
p.y=p.e=0
return}p.js(a,!0)},
dv(a,b,c){var s,r,q
for(s=b;s<c;s=q){r=c-s
r=r<1048576?r:1048576
q=s+r
a.aq(this.c,s,q)}},
js(a,b){var s,r,q=this,p=q.e,o=p+a,n=q.d
if(n===0)n=o
s=b?q.w+q.a+2*a:0
while(n<o){n=n<<1>>>0
if(b&&n>=33554432){n=s
break}}if(b&&n>s)n=s
if(n<o)n=o
r=new Uint8Array(n+32)
B.c.V(r,0,p,q.c)
q.c=r
q.d=n},
sA(a){this.e=A.H(a)}}
A.jv.prototype={
ea(a,b,c){return A.eO(b,null,new A.jx(this,!1,!0,a))},
kF(a9,b0,b1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8=null
for(p=b0 instanceof A.dG,o=this.a,n=this.b,m=0,l=0;!a9.gP();){if(a9.gi(a9)<4)throw A.d(A.ap("Trailing bytes are not a frame"))
k=A.ot(a9.a6(4,a9.gA()).B(),0)
if(k>=407710288&&k<=407710303){if(a9.gi(a9)<8)throw A.d(A.ap("Skippable frame header is truncated"))
j=8+A.ot(a9.a6(8,a9.gA()).B(),4)
if(a9.gi(a9)<j)throw A.d(A.ap("Skippable frame is truncated"))
a9.a5(0,j);++l
continue}if(k!==4247762216)throw A.d(A.ap("Not a zstd frame"))
i=a9.gi(a9)<18?a9.gi(a9):18
s=A.vO(a9.a6(i,a9.gA()).B(),4,i,o)
r=n
if(s.d!==0)j=r==null||r.a!==s.d
else j=!1
if(j)throw A.d(A.ap("Frame needs dictionary "+s.d))
a9.a5(0,4+s.a)
j=s.b
h=new A.k2(j,b0,new Uint8Array(0))
h.z=p
q=h
if(r!=null&&r.b.length!==0){j=q
g=r.b
f=g.length
j.aY(f)
B.c.V(j.c,0,f,g)
j.w=j.e=f}if(a8==null)a8=new Uint8Array(131075)
j=a8.length
g=s.b
if(j<(g<131072?g:131072)+3){j=s.b
j=j<131072?j:131072
a8=new Uint8Array(j+3)}try{j=new Uint8Array(0)
g=new Uint16Array(2048)
f=A.rM()
e=new Uint32Array(4)
d=new Uint32Array(4)
c=new Uint16Array(1440)
b=new Uint8Array(1440)
a=new Uint8Array(1440)
a0=new Uint32Array(1440)
a1=new DataView(new ArrayBuffer(0))
a2=new Int32Array(3)
a3=new Int32Array(3)
a4=new Int32Array(3)
a5=new Int16Array(53)
a6=new Uint8Array(512)
c=new A.fL(c,b,a,a0,a1,a2,a3,a4,a5,a6,new Uint16Array(53))
b=c.gl1()
b.$5(1280,0,$.m5(),35,6)
b.$5(1376,2,$.m6(),52,6)
b.$5(1344,1,$.m7(),28,5)
new A.jy(new A.jr(new A.jP(j,new A.jL(g),f,e,d),c),new Uint32Array(3),A.iY()).l8(a9,q,s,!1,r,a8)}finally{j=q
a7=j.b
g=j.e
f=j.w
if(g>f){e=j.y
j.dv(a7,e>f?e:f,g)
j.f=j.f+(j.e-j.w)
j.y=j.r=j.w=j.e=0}}++m}if(m===0&&l===0)throw A.d(A.ap("No frame: the input is empty"))}}
A.jx.prototype={
$1(a){var s=this,r=s.b
return A.d8("zstd",r,s.c,new A.jw(s.a,s.d,a,r))},
$S:5}
A.jw.prototype={
$0(){var s=this
s.a.kF(s.b,s.c,s.d)
return!0},
$S:3}
A.fJ.prototype={
lr(a,b,c,d){var s,r,q,p,o,n,m,l
try{q=A.iY()
p=new Uint32Array(3)
o=A.os()
n=a.gi(a)
m=d==null?this.a:d
new A.jz(q,p,o).lt(a,n,b,!1,this.b,m)}catch(l){s=A.G(l)
r=A.aq(l)
q=s
if(A.hn(q)&&!(q instanceof A.aP))q=new A.aP("zstd: "+A.r(q),null,null)
A.me(q,r)}},
hG(a,b,c){return this.lr(a,b,!1,c)}}
A.f5.prototype={
ex(b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9=this
t.L.a(b0)
s=$.m1()
r=$.m2()
q=a9.a^4294967295
p=a9.b^4294967295
o=$.qo()
n=$.qp()
m=b0.length
l=J.eR(B.c.gN(b0),b0.byteOffset,m)
k=m-8
j=0
while(j<=k){i=p^l.getUint32(j,!0)
h=q^l.getUint32(j+4,!0)
g=1792+(i&255)
f=n[g]
e=1536+(i>>>8&255)
d=n[e]
c=1280+(i>>>16&255)
b=n[c]
a=1024+(i>>>24)
if(!(a<2048))return A.a(n,a)
a0=n[a]
a1=768+(h&255)
a2=n[a1]
a3=512+(h>>>8&255)
a4=n[a3]
a5=256+(h>>>16&255)
a6=n[a5]
a7=h>>>24
if(!(a7<2048))return A.a(n,a7)
p=f^d^b^a0^a2^a4^a6^n[a7]
q=o[g]^o[e]^o[c]^o[a]^o[a1]^o[a3]^o[a5]^o[a7]
j+=8}for(;j<m;++j){a8=(p^b0[j])&255
p=(p>>>8|(q&255)<<24)^r[a8]
q=q>>>8^s[a8]}a9.a=(q^4294967295)>>>0
a9.b=(p^4294967295)>>>0}}
A.dG.prototype={
c9(a){var s=this.c
if((this.d+=a)>s){this.e=!0
throw A.d(A.hw("The decoded data is larger than the "+s+" bytes allowed"))}},
gi(a){var s=this.b
return s.gi(s)},
T(){return this.b.T()},
j(a){this.c9(1)
this.b.j(a)},
ah(a,b){t.L.a(a)
this.c9(a.length)
this.b.ah(a,b)},
v(a){return this.ah(a,null)},
b6(a){this.c9(a.gi(a))
this.b.b6(a)},
cU(a,b){this.c9(b)
this.b.cU(a,b)},
ai(a,b){return this.b.ai(a,b)},
aQ(a){return this.ai(a,null)}}
A.by.prototype={
W(a,b,c){var s,r,q=this,p=q.b+c
q.b=p>>>0
s=q.a
r=p>=4294967296?1:0
q.a=s+b+r>>>0},
c6(a,b){var s=this
s.a=(s.a^a)>>>0
s.b=(s.b^b)>>>0},
aa(a,b){var s=this,r=s.b,q=r&65535,p=r>>>16,o=b&65535,n=b>>>16,m=q*o,l=q*n,k=p*o,j=(m>>>16)+(l&65535)+(k&65535)
s.a=(j>>>16)+(l>>>16)+(k>>>16)+p*n+A.pf(s.a,b)+A.pf(r,a)>>>0
s.b=(m&65535|(j&65535)<<16)>>>0},
aI(a){var s=this,r=32-a,q=s.a,p=B.a.q(q,a),o=s.b,n=B.a.an(o,r)
s.b=(B.a.q(o,a)|B.a.an(q,r))>>>0
s.a=(p|n)>>>0},
cZ(a){var s,r,q=this
if(a>=32){q.b=B.a.an(q.a,a-32)
q.a=0
return}s=B.a.bb(q.b,a)
r=q.a
q.b=(s|B.a.p(r,32-a))>>>0
q.a=B.a.bb(r,a)}}
A.iX.prototype={
gd6(){var s,r=this,q=r.z
if(q===$){s=A.al(r.y)
r.z!==$&&A.bC()
r.z=s
q=s}return q},
a0(){var s,r=this,q=3266489917,p=r.c,o=p.a=r.a,n=p.b=r.b
p.W(0,2654435761,2246822535)
p.W(0,q,668265295)
p=r.d
p.a=o
p.b=n
p.W(0,q,668265295)
p=r.e
p.a=o
p.b=n
p=r.f
p.a=o
p.b=n
s=n-2246822535
p.b=s>>>0
n=s<0?1:0
p.a=o-2654435761-n>>>0
r.x=r.w=0},
ag(a,b,c){var s,r,q,p,o,n=this
if(c<=0)return
n.w+=c
s=n.x
if(s>0){r=32-s
if(c<r){B.c.H(n.y,s,s+c,a,b)
n.x+=c
return}B.c.H(n.y,s,32,a,b)
n.eJ(n.gd6(),0,1)
n.x=0
q=b+r
p=c-r}else{p=c
q=b}o=B.a.k(p,5)
if(o>0){n.eJ(A.al(a),q,o)
s=o<<5>>>0
q+=s
p-=s}if(p>0){B.c.H(n.y,0,p,a,q)
n.x=p}},
bS(){var s,r,q,p,o,n,m=this,l=4294967296,k=3266489917,j=668265295,i=2654435761,h=2246822535,g=2654435833,f=new A.by(0,0)
if(m.w>=32){s=m.r
r=m.c
q=r.a
p=r.b
s.a=q
s.b=p
s.aI(1)
p=s.a
s=s.b
f.a=p
f.b=s
s=m.d
m.d4(f,s,7)
p=m.e
m.d4(f,p,12)
q=m.f
m.d4(f,q,18)
m.cj(f,r)
m.cj(f,s)
m.cj(f,p)
m.cj(f,q)}else{f.a=m.a
f.b=m.b
f.W(0,668265263,374761413)}s=m.w
f.W(0,B.a.t(s,l),B.a.E(s,l))
o=m.x
for(s=m.r,n=0;o>=8;){s.b=s.a=0
r=m.gd6()
q=r.getUint32(n+4,!0)
r=r.getUint32(n,!0)
p=$.ho()
p.a=q
p.b=r
p.aa(k,j)
s.W(0,p.a,p.b)
s.aI(31)
s.aa(i,h)
p=s.a
r=s.b
f.a=(f.a^p)>>>0
f.b=(f.b^r)>>>0
f.aI(27)
f.aa(i,h)
f.W(0,2246822519,3266489955)
n+=8
o-=8}if(o>=4){r=m.gd6().getUint32(n,!0)
s.a=0
s.b=r
s.aa(i,h)
f.c6(s.a,s.b)
f.aI(23)
f.aa(k,j)
f.W(0,374761393,g)
n+=4
o-=4}for(r=m.y;o>0;){if(!(n<32))return A.a(r,n)
q=r[n]
s.a=0
s.b=q
s.aa(668265263,374761413)
q=s.a
p=s.b
f.a=(f.a^q)>>>0
f.b=(f.b^p)>>>0
f.aI(11)
f.aa(i,h);++n;--o}s=$.ho()
r=f.a
q=f.b
s.a=r
s.b=q
s.cZ(33)
f.c6(s.a,s.b)
f.aa(k,j)
q=f.a
r=f.b
s.a=q
s.b=r
s.cZ(29)
f.c6(s.a,s.b)
f.aa(374761393,g)
r=f.a
q=f.b
s.a=r
s.b=q
s.cZ(32)
f.c6(s.a,s.b)
return f},
eJ(a,b,c){var s,r,q,p,o,n,m,l,k,j=this,i=3266489917,h=668265295,g=2654435761,f=2246822535
for(s=j.c,r=j.d,q=j.e,p=j.f,o=b,n=0;n<c;++n){m=a.getUint32(o+4,!0)
l=a.getUint32(o,!0)
k=$.ho()
k.a=m
k.b=l
k.aa(i,h)
s.W(0,k.a,k.b)
s.aI(31)
s.aa(g,f)
l=a.getUint32(o+12,!0)
m=a.getUint32(o+8,!0)
k.a=l
k.b=m
k.aa(i,h)
r.W(0,k.a,k.b)
r.aI(31)
r.aa(g,f)
m=a.getUint32(o+20,!0)
l=a.getUint32(o+16,!0)
k.a=m
k.b=l
k.aa(i,h)
q.W(0,k.a,k.b)
q.aI(31)
q.aa(g,f)
l=a.getUint32(o+28,!0)
m=a.getUint32(o+24,!0)
k.a=l
k.b=m
k.aa(i,h)
p.W(0,k.a,k.b)
p.aI(31)
p.aa(g,f)
o+=32}},
d4(a,b,c){var s=this.r,r=b.a,q=b.b
s.a=r
s.b=q
s.aI(c)
a.W(0,s.a,s.b)},
cj(a,b){var s=this.r
s.b=s.a=0
A.rE(s,b.a,b.b)
a.c6(s.a,s.b)
a.aa(2654435761,2246822535)
a.W(0,2246822519,3266489955)}}
A.lY.prototype={
$1(a){var s,r="\xc7\xfc\xe9\xe2\xe4\xe0\xe5\xe7\xea\xeb\xe8\xef\xee\xec\xc4\xc5\xc9\xe6\xc6\xf4\xf6\xf2\xfb\xf9\xff\xd6\xdc\xa2\xa3\xa5\u20a7\u0192\xe1\xed\xf3\xfa\xf1\xd1\xaa\xba\xbf\u2310\xac\xbd\xbc\xa1\xab\xbb\u2591\u2592\u2593\u2502\u2524\u2561\u2562\u2556\u2555\u2563\u2551\u2557\u255d\u255c\u255b\u2510\u2514\u2534\u252c\u251c\u2500\u253c\u255e\u255f\u255a\u2554\u2569\u2566\u2560\u2550\u256c\u2567\u2568\u2564\u2565\u2559\u2558\u2552\u2553\u256b\u256a\u2518\u250c\u2588\u2584\u258c\u2590\u2580\u03b1\xdf\u0393\u03c0\u03a3\u03c3\xb5\u03c4\u03a6\u0398\u03a9\u03b4\u221e\u03c6\u03b5\u2229\u2261\xb1\u2265\u2264\u2320\u2321\xf7\u2248\xb0\u2219\xb7\u221a\u207f\xb2\u25a0\xa0"
A.H(a)
if(a<128)s=a
else{s=a-128
if(!(s<128))return A.a(r,s)
s=r.charCodeAt(s)}return s},
$S:4}
A.hu.prototype={
lR(a,b,c){var s,r=this,q=r.c
if(!q){s=r.e
s===$&&A.c()
s.a.ag(a,b,c)}s=r.d
s===$&&A.c()
s.hW(a,b,b+c)
if(q){q=r.e
q===$&&A.c()
q.a.ag(a,b,c)}q=new Uint8Array(20)
r.f=q
s=r.e
s===$&&A.c()
s.bg(q,0)
r.f=B.c.aZ(r.f,0,10)
return c},
hY(a,b,c){var s,r=this,q=r.c
if(!q){s=r.e
s===$&&A.c()
s.a.ag(a,b,c)}s=r.d
s===$&&A.c()
s.hW(a,b,b+c)
if(q){q=r.e
q===$&&A.c()
q.a.ag(a,b,c)}},
hJ(){var s=new Uint8Array(20),r=this.e
r===$&&A.c()
r.bg(s,0)
this.f=B.c.aZ(s,0,10)}}
A.hv.prototype={
hW(a,b,c){var s,r,q,p,o,n,m,l=this,k=l.e,j=a.length,i=b
for(;;){if(!(i<c&&l.f<32))break
s=i+1
if(!(i<j))return A.a(a,i)
r=a[i]
q=l.f++
if(!(q>=0&&q<32))return A.a(k,q)
q=k[q]
a.$flags&2&&A.b(a)
a[i]=(r^q)>>>0
i=s}while(i<c){l.jO()
p=c-i
p=p<32?p:32
for(r=a.$flags|0,o=0;o<p;++o){q=i+o
if(!(q>=0&&q<j))return A.a(a,q)
n=a[q]
m=k[o]
r&2&&A.b(a)
a[q]=(n^m)>>>0}i+=p
l.f=p}},
jO(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=a1.d,a3=a1.a,a4=a2[0],a5=a2[1],a6=a2[2],a7=a2[3],a8=a2[4],a9=a2[5],b0=a2[6],b1=a2[7],b2=a2[8],b3=a2[9],b4=a2[10],b5=a2[11],b6=a2[12],b7=a2[13],b8=a2[14],b9=a2[15]
a1.fv()
s=a2[0]
r=a2[1]
q=a2[2]
p=a2[3]
o=a3.length
if(0>=o)return A.a(a3,0)
n=((s<<24|r<<16|q<<8|p)^a3[0])>>>0
p=a2[4]
q=a2[5]
r=a2[6]
s=a2[7]
if(1>=o)return A.a(a3,1)
m=((p<<24|q<<16|r<<8|s)^a3[1])>>>0
s=a2[8]
r=a2[9]
q=a2[10]
p=a2[11]
if(2>=o)return A.a(a3,2)
l=((s<<24|r<<16|q<<8|p)^a3[2])>>>0
p=a2[12]
q=a2[13]
r=a2[14]
s=a2[15]
if(3>=o)return A.a(a3,3)
k=((p<<24|q<<16|r<<8|s)^a3[3])>>>0
a1.fv()
j=((a4<<24|a5<<16|a6<<8|a7)^a3[0])>>>0
i=((a8<<24|a9<<16|b0<<8|b1)^a3[1])>>>0
h=((b2<<24|b3<<16|b4<<8|b5)^a3[2])>>>0
g=((b6<<24|b7<<16|b8<<8|b9)^a3[3])>>>0
for(a4=a1.b,f=4,e=1;e<a4;++e,f+=4,k=a0,l=a,m=b,n=c,g=a6,h=a5,i=b3,j=d){a5=j>>>24
if(!(a5<256))return A.a(B.i,a5)
a5=B.i[a5]
a6=B.p[i>>>16&255]
a7=B.q[h>>>8&255]
a8=B.r[g&255]
if(!(f<o))return A.a(a3,f)
a9=a3[f]
d=(a5^a6^a7^a8^a9)>>>0
a8=i>>>24
if(!(a8<256))return A.a(B.i,a8)
a8=B.i[a8]
a7=B.p[h>>>16&255]
a6=B.q[g>>>8&255]
a5=B.r[j&255]
b0=f+1
if(!(b0<o))return A.a(a3,b0)
b0=a3[b0]
b3=(a8^a7^a6^a5^b0)>>>0
a5=h>>>24
if(!(a5<256))return A.a(B.i,a5)
a5=B.i[a5]
a6=B.p[g>>>16&255]
a7=B.q[j>>>8&255]
a8=B.r[i&255]
b1=f+2
if(!(b1<o))return A.a(a3,b1)
b1=a3[b1]
a5=(a5^a6^a7^a8^b1)>>>0
a8=g>>>24
if(!(a8<256))return A.a(B.i,a8)
a8=B.i[a8]
a7=B.p[j>>>16&255]
a6=B.q[i>>>8&255]
b2=B.r[h&255]
b4=f+3
if(!(b4<o))return A.a(a3,b4)
b4=a3[b4]
a6=(a8^a7^a6^b2^b4)>>>0
b2=n>>>24
if(!(b2<256))return A.a(B.i,b2)
c=(B.i[b2]^B.p[m>>>16&255]^B.q[l>>>8&255]^B.r[k&255]^a9)>>>0
a9=m>>>24
if(!(a9<256))return A.a(B.i,a9)
b=(B.i[a9]^B.p[l>>>16&255]^B.q[k>>>8&255]^B.r[n&255]^b0)>>>0
b0=l>>>24
if(!(b0<256))return A.a(B.i,b0)
a=(B.i[b0]^B.p[k>>>16&255]^B.q[n>>>8&255]^B.r[m&255]^b1)>>>0
b1=k>>>24
if(!(b1<256))return A.a(B.i,b1)
a0=(B.i[b1]^B.p[n>>>16&255]^B.q[m>>>8&255]^B.r[l&255]^b4)>>>0}if(!(f<o))return A.a(a3,f)
a1.b1(j,i,h,g,a3[f],0)
a4=f+1
if(!(a4<o))return A.a(a3,a4)
a1.b1(i,h,g,j,a3[a4],4)
a5=f+2
if(!(a5<o))return A.a(a3,a5)
a1.b1(h,g,j,i,a3[a5],8)
a6=f+3
if(!(a6<o))return A.a(a3,a6)
a1.b1(g,j,i,h,a3[a6],12)
a1.b1(n,m,l,k,a3[f],16)
a1.b1(m,l,k,n,a3[a4],20)
a1.b1(l,k,n,m,a3[a5],24)
a1.b1(k,n,m,l,a3[a6],28)},
fv(){var s,r,q,p=this.d
for(s=p.$flags|0,r=0;r<16;++r){q=p[r]
s&2&&A.b(p)
if(!(r<16))return A.a(p,r)
p[r]=q+1
if(p[r]!==0)break}},
b1(a,b,c,d,e,f){var s,r,q=a>>>24
if(!(q<256))return A.a(B.h,q)
s=(B.h[q]<<24|B.h[b>>>16&255]<<16|B.h[c>>>8&255]<<8|B.h[d&255])^e
q=this.e
q.$flags&2&&A.b(q)
if(!(f<32))return A.a(q,f)
q[f]=s>>>24
r=f+1
if(!(r<32))return A.a(q,r)
q[r]=s>>>16&255
r=f+2
if(!(r<32))return A.a(q,r)
q[r]=s>>>8&255
r=f+3
if(!(r<32))return A.a(q,r)
q[r]=s&255}}
A.aP.prototype={}
A.c0.prototype={}
A.df.prototype={}
A.de.prototype={}
A.dg.prototype={}
A.dk.prototype={
bp(){return"ByteOrder."+this.b}}
A.f_.prototype={
gl_(){return this.e-this.d},
a5(a,b){this.d+=b
this.w+=b},
kY(a,b,c,d){var s,r
t.L.a(a)
A.bO(b,c,a.length)
if(t.p.b(a))s=A.Q(a,b,c)
else{s=c-b
r=new Uint8Array(s)
B.c.H(r,0,s,a,b)
s=r}this.iu(s)
if(d)this.al()},
iu(a){var s,r,q=this
if(q.f)throw A.d(A.az("Cannot add to a closed sink"))
s=q.r
if(s!=null)throw A.d(s)
r=a.length
if(r===0)return
if(q.d===q.e){q.b=a
q.d=0
q.e=r
try{q.ci(q.gbG())}finally{q.jH()}return}q.ix(a)
q.ci(q.gbG())},
al(){var s,r=this
if(r.f)return
r.f=!0
s=r.r
if(s!=null)throw A.d(s)
r.ci(r.gbG())
r.ci(r.geg())
r.a.a.T()},
ci(a){var s,r,q,p=this
t.M.a(a)
try{a.$0()}catch(r){s=A.G(r)
q=p.r
if(q==null){q=s
q=p.r=A.hn(q)&&!(q instanceof A.aP)?new A.aP(A.r(q),null,null):q}p.b=p.c=new Uint8Array(0)
p.e=p.d=0
throw A.d(q)}},
ix(a){var s,r,q,p,o,n=this,m=n.e,l=n.d,k=m-l
if(l<k){s=n.b
r=n.c
s=s===r&&m+a.length<=r.length}else s=!1
if(s){l=a.length
B.c.V(n.c,m,m+l,a)
n.e+=l
return}m=a.length
q=k+m
s=n.c
p=s.length
if(q>p||k>p>>>1){if(p===0)p=65536
if(k>p>>>1)p=p<<1>>>0
while(p<q)p=p<<1>>>0
o=new Uint8Array(p)
B.c.H(o,0,k,n.b,l)
n.c=o}else B.c.H(s,0,k,n.b,l)
l=n.c
n.b=l
n.d=0
n.e=k
B.c.V(l,k,q,a)
n.e+=m},
jH(){var s=this,r=s.e-s.d,q=s.c,p=q.length
if(r>p){if(p===0)p=65536
while(p<r)p=p<<1>>>0
q=s.c=new Uint8Array(p)}if(r>0)B.c.H(q,0,r,s.b,s.d)
s.b=s.c
s.d=0
s.e=r}}
A.bQ.prototype={
gi(a){return this.c},
aq(a,b,c){return this.dl(A.Q(a,b,c))},
ah(a,b){var s
t.L.a(a)
s=a.length
this.dl(t.p.b(a)?A.Q(a,0,s):new Uint8Array(A.N(J.qG(a,0,s))))},
v(a){return this.ah(a,null)},
j(a){var s,r,q,p=this;++p.c
s=p.e
r=p.f
q=r+1
p.f=q
s.$flags&2&&A.b(s)
if(!(r>=0&&r<65536))return A.a(s,r)
s[r]=a
if(q===65536)p.aT()},
b6(a){var s,r,q=a.gA(),p=new Uint8Array(65536)
try{while(!a.gP()){s=a.az(p,0,J.B(p))
r=s
if(typeof r!=="number")return r.bD()
if(r<=0)break
this.dl(A.Q(p,0,s))}}finally{a.S(q)}},
dl(a){var s,r,q,p,o,n,m=this,l=a.length
if(l===0)return
m.c+=l
if(l>=65536){m.aT()
for(s=m.b,r=0;r<l;r=q){q=r+65536
s.m(0,new Uint8Array(A.N(A.Q(a,r,q<l?q:l))))}return}for(s=m.e,r=0;r<l;){p=m.f
o=65536-p
n=l-r
if(o>n)o=n
B.c.H(s,p,p+o,a,r)
r+=o
if((m.f+=o)===65536)m.aT()}},
aT(){var s=this,r=s.f
if(r===0)return
s.b.m(0,new Uint8Array(A.N(A.Q(s.e,0,r))))
s.f=0},
ai(a,b){return A.j(A.ao("a streamed result cannot be read back"))},
aQ(a){return this.ai(a,null)},
T(){return this.aT()}}
A.f4.prototype={
gbv(){var s=this.a,r=s.b,q=s.a
return new Uint8Array(A.N(A.i([r&255,r>>>8&255,r>>>16&255,r>>>24&255,q&255,q>>>8&255,q>>>16&255,q>>>24&255],t.t)))},
lI(a,b){var s,r,q,p,o
t.L.a(a)
s=a.length
if(b+8>s)return!1
r=this.gbv()
for(q=r.length,p=0;p<8;++p){o=b+p
if(!(o<s))return A.a(a,o)
o=a[o]
if(!(p<q))return A.a(r,p)
if(o!==r[p])return!1}return!0}}
A.kd.prototype={}
A.i3.prototype={}
A.dw.prototype={
hD(a){a.b6(this.c7())},
gej(){return!1}}
A.bH.prototype={
gi(a){var s=this.a
s=s==null?null:s.length
return s==null?0:s},
am(a){var s=this.a
if(s==null)s=new Uint8Array(0)
return A.U(s,B.d,null,null)},
c7(){return this.am(!0)}}
A.cE.prototype={
gA(){return this.e},
S(a){return this.e=a},
a0(){return this.e=0},
cQ(a){this.e=Math.max(0,this.e-a)},
i0(){return this.cQ(1)},
a5(a,b){this.e+=b},
gi(a){var s=this,r=s.d
if(r!=null)return Math.max(0,r-s.e)
return s.b.i_(s.c+s.e)},
gP(){var s,r,q=this,p=q.d
if(p!=null&&q.e>=p)return!0
s=q.b
r=q.c+q.e
s.cf(r,1)
return r>=s.e+s.f},
aR(a,b,c){var s,r
if(c==null)c=this.e
s=this.d
if(s!=null){r=Math.max(0,s-c)
b=b==null?r:Math.min(b,r)}return A.nY(this,c,b)},
a6(a,b){return this.aR(null,a,b)},
d1(a){return this.aR(null,null,a)},
G(){var s,r=this
if(r.gP())return 0
s=r.b.l2(r.c+r.e);++r.e
return s},
K(a){var s,r,q=this,p=q.d
if(p!=null)a=Math.max(0,Math.min(a,p-q.e))
s=q.e
r=A.nY(q,s,a)
q.e=s+a
return r},
az(a,b,c){var s,r,q,p=this
if(c<=0)return 0
s=p.d
if(s!=null)c=Math.max(0,Math.min(c,s-p.e))
r=p.b.eq(p.c+p.e,c)
q=r.length
B.c.V(a,b,b+q,r)
p.e+=q
return q},
B(){var s,r,q=this,p=q.d
if(p!=null){s=q.e
return q.b.eq(q.c+s,Math.max(0,p-s))}s=q.b
r=q.c+q.e
return s.eq(r,s.i_(r))}}
A.fX.prototype={
gi(a){return this.e+this.f},
cf(a,b){var s,r=this,q=r.e
if(a<q)throw A.d(A.p("Position "+a+" of the decoded data has already been read past, only the last "+r.f+" bytes from "+q+" are still held"))
r.r=a
q=r.b
s=a+b
for(;;){if(!(!r.w&&r.e+r.f<s))break
if(!q.lb(r))r.w=!0}},
l2(a){var s,r,q=this
q.cf(a,1)
s=q.e
if(a>=s+q.f)return 0
r=q.d
s=a-s
if(!(s>=0&&s<r.length))return A.a(r,s)
return r[s]},
eq(a,b){var s,r,q=this
q.cf(a,b)
s=q.e
r=Math.max(0,Math.min(b,s+q.f-a))
if(r===0)return new Uint8Array(0)
s=a-s
return B.c.aZ(q.d,s,s+r)},
i_(a){this.cf(a,1125899906842624)
return Math.max(0,this.e+this.f-a)},
fA(a){var s,r,q,p,o=this,n=o.f,m=o.d
if(n+a<=m.length)return
s=o.e
r=Math.max(s,Math.min(o.r-o.c,s+n))-s
if(r>0){B.c.H(m,0,n-r,m,r)
n=o.f-=r
o.e+=r}m=n+a
s=o.d
q=s.length
if(m>q){m=Math.max(q*2,m)
p=new Uint8Array(m)
B.c.V(p,0,n,s)
o.d=p}},
j(a){var s,r,q=this
if(q.f===q.d.length)q.fA(1)
s=q.d
r=q.f++
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a},
ah(a,b){var s,r,q=this
t.L.a(a)
if(b==null)b=a.length
q.fA(b)
s=q.d
r=q.f
B.c.V(s,r,r+b,a)
q.f+=b},
v(a){return this.ah(a,null)},
ai(a,b){var s,r=this
if(a<0)a=r.e+r.f+a
if(b==null)b=r.e+r.f
else if(b<0)b=r.e+r.f+b
s=r.e
if(a<s)throw A.d(A.p("Position "+a+" of the decoded data is no longer held"))
return B.c.aZ(r.d,a-s,b-s)},
aQ(a){return this.ai(a,null)}}
A.a6.prototype={
bn(a,b,c,d){var s,r,q,p
if(d==null)d=0
A.bN(d,"offset")
if(d<0)d=0
else{s=a.length
if(d>s)d=s}r=a.length-d
if(c==null)c=r
if(c<0||c>r)c=r
q=t.p.b(a)?a:new Uint8Array(A.N(a))
p=J.ak(B.c.gN(q),q.byteOffset+d,c)
this.b=p
this.d=p.length},
gA(){return this.c},
gi(a){var s=this.b
return s==null?0:s.length-this.c},
gP(){var s=this.c,r=this.d
r===$&&A.c()
return s>=r},
S(a){this.c=a},
a0(){this.c=0},
cQ(a){var s,r=this,q=r.c
if(a>=q)r.c=0
else{s=r.d
s===$&&A.c()
if(a<=q-s)r.c=s
else r.c=q-a}},
i0(){return this.cQ(1)},
a5(a,b){var s,r=this,q=r.d
q===$&&A.c()
s=r.c
if(b>=q-s)r.c=q
else if(b<=-s)r.c=0
else r.c=s+b},
aR(a,b,c){var s,r=this,q=r.b
if(q==null)return A.U(A.i([],t.t),B.d,null,null)
if(c==null)c=r.c
if(b==null){s=r.d
s===$&&A.c()
b=s-c}return A.U(q,r.a,b,c)},
a6(a,b){return this.aR(null,a,b)},
d1(a){return this.aR(null,null,a)},
G(){var s,r=this.b
r.toString
s=this.c++
if(!(s>=0&&s<r.length))return A.a(r,s)
return r[s]},
c5(a){var s,r,q=this,p=q.b
if(p==null||a>p.length-q.c)return null
s=q.c
r=A.Q(p,s,s+a)
q.c+=a
return r},
az(a,b,c){var s,r,q,p=this.b
if(p==null)return 0
s=p.length
r=this.c
q=s-r
q=c>q?q:c
if(q<=0)return 0
B.c.H(a,b,b+q,p,r)
this.c+=q
return q},
B(){var s,r,q,p,o=this,n=o.b
if(n==null)return new Uint8Array(0)
s=o.gi(0)
r=n.length
q=o.c
p=r-q
if(s<0||s>p)s=p
if(q<0)throw A.d(A.ac(q,0,r,"position",null))
return J.ak(B.c.gN(n),o.b.byteOffset+o.c,s)}}
A.cF.prototype={
c5(a){return null},
eo(a){return this.a6(a,this.gA())},
O(){var s=this.G(),r=this.G()
if(this.a===B.y)return(s<<8|r)>>>0
return(r<<8|s)>>>0},
J(){var s=this,r=s.G(),q=s.G(),p=s.G(),o=s.G()
if(s.a===B.y)return(r<<24|q<<16|p<<8|o)>>>0
return(o<<24|p<<16|q<<8|r)>>>0},
aA(){var s=this,r=s.G(),q=s.G(),p=s.G(),o=s.G(),n=s.G(),m=s.G(),l=s.G(),k=s.G()
if(s.a===B.y)return(B.a.q(r,56)|B.a.q(q,48)|B.a.q(p,40)|B.a.q(o,32)|n<<24|m<<16|l<<8|k)>>>0
return(B.a.q(k,56)|B.a.q(l,48)|B.a.q(m,40)|B.a.q(n,32)|o<<24|p<<16|q<<8|r)>>>0},
K(a){var s=this,r=s.a6(a,s.gA())
s.S(s.gA()+r.gi(r))
return r},
hZ(a,b){return new A.io(b).$1(this.K(a).B())},
er(a){return this.hZ(a,!0)},
sbu(a){this.a=t.c.a(a)}}
A.io.prototype={
$1(a){var s,r,q
t.L.a(a)
try{s=this.a?B.aw.a4(a):A.cb(a,0,null)
return s}catch(r){q=A.cb(a,0,null)
return q}},
$S:29}
A.bg.prototype={
T(){},
Z(){return J.ak(B.c.gN(this.c),this.c.byteOffset,this.b)},
aY(a){var s,r=this.c
if(a>r.length){s=new Uint8Array(a)
B.c.V(s,0,this.b,r)
this.c=s}},
j(a){var s,r,q=this
if(q.b===q.c.length)q.jc()
s=q.c
r=q.b++
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a},
ah(a,b){var s,r,q,p,o=this
t.L.a(a)
if(b==null)b=a.length
while(s=o.b,r=s+b,q=o.c,p=q.length,r>p)o.cg(r-p)
B.c.V(q,s,r,a)
o.b+=b},
v(a){return this.ah(a,null)},
b6(a){var s,r,q,p,o,n=this
if(a instanceof A.a6){s=a.gi(0)
while(r=n.b,q=r+s,p=n.c,o=p.length,q>o)n.cg(q-o)
o=a.b
if(o!=null)B.c.H(p,r,q,o,a.c)
n.b+=s
return}if(a instanceof A.cE){n.v(a.B())
return}n.aY(n.b+a.gi(a))
A.vt(a,n)},
cU(a,b){var s,r,q,p,o,n,m,l,k,j,i=this
while(s=i.b,r=s+b,q=i.c,p=q.length,r>p)i.cg(r-p)
o=s-a
if(a>=b)B.c.H(q,s,r,q,o)
else for(n=q.$flags|0,m=o;s<r;s=l,m=k){l=s+1
k=m+1
if(!(m>=0&&m<p))return A.a(q,m)
j=q[m]
n&2&&A.b(q)
if(!(s>=0))return A.a(q,s)
q[s]=j}i.b+=b},
ai(a,b){var s=this
if(a<0)a=s.b+a
if(b==null)b=s.b
else if(b<0)b=s.b+b
return J.ak(B.c.gN(s.c),s.c.byteOffset+a,b-a)},
aQ(a){return this.ai(a,null)},
cg(a){var s,r=this.c,q=r.length,p=q+(a==null?1:a),o=q===0?32768:q*2
if(o<p)o=p
s=new Uint8Array(o)
B.c.V(s,0,this.b,r)
this.c=s},
jc(){return this.cg(null)},
gi(a){return this.b}}
A.aI.prototype={
aq(a,b,c){this.v(A.Q(a,b,c))},
aY(a){},
U(a){var s=this,r=a&255,q=a>>>8&255
if(s.a===B.y){s.j(q)
s.j(r)}else{s.j(r)
s.j(q)}},
L(a){var s=this,r=a&255
if(s.a===B.y){s.j(B.a.k(a,24)&255)
s.j(B.a.k(a,16)&255)
s.j(B.a.k(a,8)&255)
s.j(r)}else{s.j(r)
s.j(B.a.k(a,8)&255)
s.j(B.a.k(a,16)&255)
s.j(B.a.k(a,24)&255)}},
aB(a){var s,r=this
if((a&9223372036854776e3)>>>0!==0){a=(a^9223372036854776e3)>>>0
s=128}else s=0
if(r.a===B.y){r.j(s|B.a.k(a,56)&255)
r.j(B.a.k(a,48)&255)
r.j(B.a.k(a,40)&255)
r.j(B.a.k(a,32)&255)
r.j(B.a.k(a,24)&255)
r.j(B.a.k(a,16)&255)
r.j(B.a.k(a,8)&255)
r.j(a&255)
return}r.j(a&255)
r.j(B.a.k(a,8)&255)
r.j(B.a.k(a,16)&255)
r.j(B.a.k(a,24)&255)
r.j(B.a.k(a,32)&255)
r.j(B.a.k(a,40)&255)
r.j(B.a.k(a,48)&255)
r.j(s|B.a.k(a,56)&255)},
cU(a,b){var s,r=this
for(s=-a;b>a;){r.v(r.aQ(s))
b-=a}if(b===a)r.v(r.aQ(s))
else r.v(r.ai(s,b-a))},
Z(){return this.ai(0,this.gi(this))},
sbu(a){this.a=t.c.a(a)}}
A.iH.prototype={
a0(){B.f.ab(this.a,0,B.bS)
this.e=this.d=0},
ag(a,b,c){var s,r,q,p,o,n,m=this
if(c<=0)return
m.e+=c
s=b+c
r=m.d
if(r>0){q=64-r
if(c<q)q=c
p=m.c
B.c.H(p,r,r+q,a,b)
o=b+q
if((m.d+=q)<64)return
m.cd(p,0,64)
m.d=0}else o=b
n=o+((s-o&4294967232)>>>0)
m.cd(a,o,n)
r=s-n
B.c.H(m.c,0,r,a,n)
m.d=r},
bg(a,b){var s,r,q,p,o,n,m,l,k=this,j=k.c,i=k.d,h=i+1
j.$flags&2&&A.b(j)
if(!(i>=0&&i<64))return A.a(j,i)
j[i]=128
if(h>56){B.c.F(j,h,64,0)
k.cd(j,0,64)
i=0}else i=h
B.c.F(j,i,56,0)
s=k.e*8
for(r=j.$flags|0,q=63;q>=56;--q){p=B.a.E(s,256)
r&2&&A.b(j)
if(!(q<64))return A.a(j,q)
j[q]=p
s=B.a.t(s,256)}k.cd(j,0,64)
for(r=k.a,p=a.$flags|0,q=0;q<5;++q){o=r[q]
n=b+4*q
p&2&&A.b(a)
m=a.length
if(!(n<m))return A.a(a,n)
a[n]=o>>>24
l=n+1
if(!(l<m))return A.a(a,l)
a[l]=o>>>16&255
l=n+2
if(!(l<m))return A.a(a,l)
a[l]=o>>>8&255
n+=3
if(!(n<m))return A.a(a,n)
a[n]=o&255}k.a0()},
dU(a){B.f.ab(this.a,0,a)
this.d=0
this.e=64},
cd(a,b,c){var s,r,q,p,o,n,m,l,k=this.b
for(s=a.length;b<c;b+=64){for(r=k.$flags|0,q=0;q<16;++q){p=b+4*q
if(!(p>=0&&p<s))return A.a(a,p)
o=a[p]
n=p+1
if(!(n<s))return A.a(a,n)
n=a[n]
m=p+2
if(!(m<s))return A.a(a,m)
m=a[m]
l=p+3
if(!(l<s))return A.a(a,l)
l=a[l]
r&2&&A.b(k)
if(!(q<80))return A.a(k,q)
k[q]=(o<<24|n<<16|m<<8|l)>>>0}this.eZ()}},
eZ(){var s,r,q,p,o,n,m,l,k,j=this.a,i=this.b
for(s=i.$flags|0,r=16;r<80;++r){q=i[r-3]^i[r-8]^i[r-14]^i[r-16]
s&2&&A.b(i)
if(!(r<80))return A.a(i,r)
i[r]=(q<<1|q>>>31)>>>0}p=j[0]
o=j[1]
n=j[2]
m=j[3]
l=j[4]
for(k=p,r=0;r<20;r+=5){l=l+1518500249+i[r]+((m^o&(n^m))>>>0)+((k<<5|k>>>27)>>>0)>>>0
o=(o<<30|o>>>2)>>>0
m=m+1518500249+i[r+1]+((n^k&(o^n))>>>0)+((l<<5|l>>>27)>>>0)>>>0
k=(k<<30|k>>>2)>>>0
n=n+1518500249+i[r+2]+((o^l&(k^o))>>>0)+((m<<5|m>>>27)>>>0)>>>0
l=(l<<30|l>>>2)>>>0
o=o+1518500249+i[r+3]+((k^m&(l^k))>>>0)+((n<<5|n>>>27)>>>0)>>>0
m=(m<<30|m>>>2)>>>0
k=k+1518500249+i[r+4]+((l^n&(m^l))>>>0)+((o<<5|o>>>27)>>>0)>>>0
n=(n<<30|n>>>2)>>>0}for(r=20;r<40;r+=5){l=l+1859775393+i[r]+((o^n^m)>>>0)+((k<<5|k>>>27)>>>0)>>>0
o=(o<<30|o>>>2)>>>0
m=m+1859775393+i[r+1]+((k^o^n)>>>0)+((l<<5|l>>>27)>>>0)>>>0
k=(k<<30|k>>>2)>>>0
n=n+1859775393+i[r+2]+((l^k^o)>>>0)+((m<<5|m>>>27)>>>0)>>>0
l=(l<<30|l>>>2)>>>0
o=o+1859775393+i[r+3]+((m^l^k)>>>0)+((n<<5|n>>>27)>>>0)>>>0
m=(m<<30|m>>>2)>>>0
k=k+1859775393+i[r+4]+((n^m^l)>>>0)+((o<<5|o>>>27)>>>0)>>>0
n=(n<<30|n>>>2)>>>0}for(r=40;r<60;r+=5){l=l+2400959708+i[r]+((o&n|m&(o|n))>>>0)+((k<<5|k>>>27)>>>0)>>>0
o=(o<<30|o>>>2)>>>0
m=m+2400959708+i[r+1]+((k&o|n&(k|o))>>>0)+((l<<5|l>>>27)>>>0)>>>0
k=(k<<30|k>>>2)>>>0
n=n+2400959708+i[r+2]+((l&k|o&(l|k))>>>0)+((m<<5|m>>>27)>>>0)>>>0
l=(l<<30|l>>>2)>>>0
o=o+2400959708+i[r+3]+((m&l|k&(m|l))>>>0)+((n<<5|n>>>27)>>>0)>>>0
m=(m<<30|m>>>2)>>>0
k=k+2400959708+i[r+4]+((n&m|l&(n|m))>>>0)+((o<<5|o>>>27)>>>0)>>>0
n=(n<<30|n>>>2)>>>0}for(r=60;r<80;r+=5){l=l+3395469782+i[r]+((o^n^m)>>>0)+((k<<5|k>>>27)>>>0)>>>0
o=(o<<30|o>>>2)>>>0
s=r+1
if(!(s<80))return A.a(i,s)
m=m+3395469782+i[s]+((k^o^n)>>>0)+((l<<5|l>>>27)>>>0)>>>0
k=(k<<30|k>>>2)>>>0
s=r+2
if(!(s<80))return A.a(i,s)
n=n+3395469782+i[s]+((l^k^o)>>>0)+((m<<5|m>>>27)>>>0)>>>0
l=(l<<30|l>>>2)>>>0
s=r+3
if(!(s<80))return A.a(i,s)
o=o+3395469782+i[s]+((m^l^k)>>>0)+((n<<5|n>>>27)>>>0)>>>0
m=(m<<30|m>>>2)>>>0
s=r+4
if(!(s<80))return A.a(i,s)
k=k+3395469782+i[s]+((n^m^l)>>>0)+((o<<5|o>>>27)>>>0)>>>0
n=(n<<30|n>>>2)>>>0}j.$flags&2&&A.b(j)
if(0>=5)return A.a(j,0)
j[0]=p+k
s=j[1]
if(1>=5)return A.a(j,1)
j[1]=s+o
s=j[2]
if(2>=5)return A.a(j,2)
j[2]=s+n
s=j[3]
if(3>=5)return A.a(j,3)
j[3]=s+m
s=j[4]
if(4>=5)return A.a(j,4)
j[4]=s+l}}
A.ik.prototype={
ip(a){var s,r,q,p,o=this,n=new Uint8Array(64),m=a.length
if(m>64){s=o.a
s.ag(a,0,m)
s.bg(n,0)}else B.c.V(n,0,m,a)
for(r=0;r<64;++r){m=n[r]
if(!(r<64))return A.a(n,r)
n[r]=m^54}m=o.a
m.ag(n,0,64)
s=o.b
q=m.a
B.f.ab(s,0,q)
for(r=0;r<64;++r){p=n[r]
if(!(r<64))return A.a(n,r)
n[r]=p^106}m.a0()
m.ag(n,0,64)
B.f.ab(o.c,0,q)
m.dU(s)},
bg(a,b){var s=this,r=s.a,q=s.d
r.bg(q,0)
r.dU(s.c)
r.ag(q,0,20)
r.bg(a,b)
r.dU(s.b)}}
A.iI.prototype={
a0(){B.f.ab(this.a,0,B.bL)
this.e=this.d=0},
ag(a,b,c){var s,r,q,p,o,n,m=this
if(c<=0)return
m.e+=c
s=b+c
r=m.d
if(r>0){q=64-r
if(c<q)q=c
p=m.c
B.c.H(p,r,r+q,a,b)
o=b+q
if((m.d+=q)<64)return
m.dX(p,0,64)
m.d=0}else o=b
n=o+((s-o&4294967232)>>>0)
m.dX(a,o,n)
r=s-n
B.c.H(m.c,0,r,a,n)
m.d=r},
hE(){var s,r,q,p,o,n=this,m=n.d,l=m<56?64:128,k=new Uint8Array(l)
B.c.V(k,0,m,n.c)
m=n.d
if(!(m>=0&&m<l))return A.a(k,m)
k[m]=128
s=n.e*8
for(r=l-1,m=l-8;r>=m;--r){q=B.a.E(s,256)
if(!(r<l))return A.a(k,r)
k[r]=q
s=B.a.t(s,256)}n.dX(k,0,l)
p=new Uint8Array(32)
for(m=n.a,r=0;r<8;++r){o=m[r]
l=4*r
if(!(l<32))return A.a(p,l)
p[l]=o>>>24
q=l+1
if(!(q<32))return A.a(p,q)
p[q]=o>>>16&255
q=l+2
if(!(q<32))return A.a(p,q)
p[q]=o>>>8&255
l+=3
if(!(l<32))return A.a(p,l)
p[l]=o&255}n.a0()
return p},
dX(a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this.a,a5=this.b
for(s=a4.$flags|0,r=a5.$flags|0,q=a6.length;a7<a8;a7+=64){for(p=0;p<16;++p){o=a7+4*p
if(!(o>=0&&o<q))return A.a(a6,o)
n=a6[o]
m=o+1
if(!(m<q))return A.a(a6,m)
m=a6[m]
l=o+2
if(!(l<q))return A.a(a6,l)
l=a6[l]
k=o+3
if(!(k<q))return A.a(a6,k)
k=a6[k]
r&2&&A.b(a5)
if(!(p<64))return A.a(a5,p)
a5[p]=(n<<24|m<<16|l<<8|k)>>>0}for(p=16;p<64;++p){j=a5[p-15]
i=a5[p-2]
n=a5[p-16]
m=a5[p-7]
r&2&&A.b(a5)
if(!(p<64))return A.a(a5,p)
a5[p]=n+(((j>>>7|j<<25)^(j>>>18|j<<14)^j>>>3)>>>0)+m+(((i>>>17|i<<15)^(i>>>19|i<<13)^i>>>10)>>>0)}h=a4[0]
g=a4[1]
f=a4[2]
e=a4[3]
d=a4[4]
c=a4[5]
b=a4[6]
a=a4[7]
for(a0=h,p=0;p<64;++p,a=b,b=c,c=d,d=a2,e=f,f=g,g=a0,a0=a3){a1=a+(((d>>>6|d<<26)^(d>>>11|d<<21)^(d>>>25|d<<7))>>>0)+((b^d&(c^b))>>>0)+B.k[p]+a5[p]>>>0
a2=e+a1>>>0
a3=a1+(((a0>>>2|a0<<30)^(a0>>>13|a0<<19)^(a0>>>22|a0<<10))>>>0)+((a0&(g|f)|g&f)>>>0)>>>0}s&2&&A.b(a4)
if(0>=8)return A.a(a4,0)
a4[0]=h+a0
n=a4[1]
if(1>=8)return A.a(a4,1)
a4[1]=n+g
n=a4[2]
if(2>=8)return A.a(a4,2)
a4[2]=n+f
n=a4[3]
if(3>=8)return A.a(a4,3)
a4[3]=n+e
n=a4[4]
if(4>=8)return A.a(a4,4)
a4[4]=n+d
n=a4[5]
if(5>=8)return A.a(a4,5)
a4[5]=n+c
n=a4[6]
if(6>=8)return A.a(a4,6)
a4[6]=n+b
n=a4[7]
if(7>=8)return A.a(a4,7)
a4[7]=n+a}}}
A.aR.prototype={
aC(a,b){var s,r,q,p,o,n,m
if(b==null)return!1
if(b instanceof A.aR){s=this.a
r=b.a
q=s.length
p=r.length
if(q!==p)return!1
for(o=0,n=0;n<q;++n){m=s[n]
if(!(n<p))return A.a(r,n)
o|=m^r[n]}return o===0}return!1},
ga1(a){return A.rp(this.a)},
n(a){return A.eJ(this.a)}}
A.f9.prototype={
m(a,b){if(this.a!=null)throw A.d(A.az("add may only be called once."))
this.a=b},
al(){if(this.a==null)throw A.d(A.az("add must be called once."))},
$iS:1}
A.fc.prototype={
a4(a){var s,r,q
t.L.a(a)
s=new A.f9()
r=this.d0(s)
r.m(0,a)
r.al()
q=s.a
q.toString
return q}}
A.fd.prototype={
m(a,b){var s,r=this
t.L.a(b)
if(r.w)throw A.d(A.az("Hash.add() called after close()."))
s=J.aj(b)
r.r=r.r+s.gi(b)
r.d3(b,0,s.gi(b))},
d3(a,b,c){var s,r,q,p,o,n=this
t.L.a(a)
s=n.e
r=n.d
q=r.length
for(p=b;;s=0){o=s+c-p
if(o<q){B.c.H(r,s,o,a,p)
n.e=o
return}B.c.H(r,s,q,a,p)
p+=q-s
n.dK()}},
dK(){var s,r=this,q=r.f,p=r.c,o=B.B===r.b,n=q.$flags|0,m=q.length,l=0
do{s=p.getUint32(l*4,o)
n&2&&A.b(q)
if(!(l<m))return A.a(q,l)
q[l]=s;++l}while(l<m)
r.i9(q)},
al(){var s,r,q,p,o,n,m,l,k,j=this
if(j.w)return
j.w=!0
if(j.r>1125899906842623)A.j(A.ao("Hashing is unsupported for messages with more than 2^53 bits."))
s=j.d
r=j.e
q=j.e=r+1
s.$flags&2&&A.b(s)
p=s.length
if(!(r>=0&&r<p))return A.a(s,r)
s[r]=128
if(q>p-j.x){B.c.F(s,q,p,0)
j.dK()
r=j.e=0}else r=q
o=j.r*8
n=p-8
B.c.F(s,r,n,0)
m=B.a.t(o,4294967296)
l=o>>>0
s=j.b
r=j.c
q=B.B===s
p=n+4
k=r.$flags|0
if(s===B.J){k&2&&A.b(r,11)
r.setUint32(n,m,q)
r.setUint32(p,l,q)}else{k&2&&A.b(r,11)
r.setUint32(n,l,q)
r.setUint32(p,m,q)}j.dK()
j.e=0
s=j.a
s.m(0,new A.aR(j.iH()))
s.al()},
iH(){var s,r,q,p,o,n,m
if(this.b===$.dc())return J.ht(B.f.gN(this.gec()))
s=this.gec()
r=s.byteLength
q=new Uint8Array(r)
p=J.hs(B.c.gN(q))
for(r=s.length,o=p.$flags|0,n=0;n<r;++n){m=s[n]
o&2&&A.b(p,11)
p.setUint32(n*4,m,!1)}return q}}
A.h6.prototype={
d0(a){var s,r,q,p,o
t.E.a(a)
s=new Uint32Array(5)
r=new Uint32Array(80)
q=new Uint8Array(64)
p=new Uint32Array(16)
o=J.hs(B.c.gN(q))
s[0]=1732584193
s[1]=4023233417
s[2]=2562383102
s[3]=271733878
s[4]=3285377520
return new A.h7(s,r,a,B.J,o,q,p,8)}}
A.h7.prototype={
i9(a){var s,r,q,p,o,n,m,l=this.y,k=l[0],j=l[1],i=l[2],h=l[3],g=l[4]
for(s=this.z,r=s.$flags|0,q=a.length,p=0;p<80;++p,g=h,h=i,i=m,j=k,k=n){if(p<16){if(!(p<q))return A.a(a,p)
o=a[p]
r&2&&A.b(s)
s[p]=o}else{o=s[p-3]^s[p-8]^s[p-14]^s[p-16]
r&2&&A.b(s)
s[p]=(o<<1|o>>>31)>>>0}n=(((k<<5|k>>>27)>>>0)+g>>>0)+s[p]>>>0
if(p<20)n=(n+((j&i|~j&h)>>>0)>>>0)+1518500249>>>0
else if(p<40)n=(n+((j^i^h)>>>0)>>>0)+1859775393>>>0
else n=p<60?(n+((j&i|j&h|i&h)>>>0)>>>0)+2400959708>>>0:(n+((j^i^h)>>>0)>>>0)+3395469782>>>0
m=(j<<30|j>>>2)>>>0}s=l[0]
l.$flags&2&&A.b(l)
l[0]=k+s>>>0
l[1]=j+l[1]>>>0
l[2]=i+l[2]>>>0
l[3]=h+l[3]>>>0
l[4]=g+l[4]>>>0},
gec(){return this.y}}
A.h8.prototype={
d0(a){var s,r,q,p
t.E.a(a)
s=new Uint32Array(A.N(A.i([1779033703,3144134277,1013904242,2773480762,1359893119,2600822924,528734635,1541459225],t.t)))
r=new Uint32Array(64)
q=new Uint8Array(64)
p=new Uint32Array(16)
return new A.ew(s,r,a,B.J,J.hs(B.c.gN(q)),q,p,8)}}
A.h9.prototype={
i9(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=a.length
if(15>=b)return A.a(a,15)
s=this.z
r=this.y
if(7>=r.length)return A.a(r,7)
for(q=s.$flags|0,p=0;p<16;++p){if(!(p<b))return A.a(a,p)
o=a[p]
q&2&&A.b(s)
s[p]=o}for(p=16;p<64;++p){b=s[p-2]
o=s[p-7]
n=s[p-15]
m=s[p-16]
q&2&&A.b(s)
s[p]=((((b>>>17|b<<15)^(b>>>19|b<<13)^b>>>10)>>>0)+o>>>0)+((((n>>>7|n<<25)^(n>>>18|n<<14)^n>>>3)>>>0)+m>>>0)>>>0}l=r[0]
k=r[1]
j=r[2]
i=r[3]
h=r[4]
g=r[5]
f=r[6]
e=r[7]
for(d=l,p=0;p<64;p+=8){c=(e+(((h>>>6|h<<26)^(h>>>11|h<<21)^(h>>>25|h<<7))>>>0)>>>0)+(((h&g^~h&f)>>>0)+(B.k[p]+s[p]>>>0)>>>0)>>>0
i=i+c>>>0
b=d&k
e=c+((((d>>>2|d<<30)^(d>>>13|d<<19)^(d>>>22|d<<10))>>>0)+((b^d&j^k&j)>>>0)>>>0)>>>0
q=p+1
if(!(q<64))return A.a(B.k,q)
c=(f+(((i>>>6|i<<26)^(i>>>11|i<<21)^(i>>>25|i<<7))>>>0)>>>0)+(((i&h^~i&g)>>>0)+(B.k[q]+s[q]>>>0)>>>0)>>>0
j=j+c>>>0
q=e&d
f=c+((((e>>>2|e<<30)^(e>>>13|e<<19)^(e>>>22|e<<10))>>>0)+((q^e&k^b)>>>0)>>>0)>>>0
b=p+2
if(!(b<64))return A.a(B.k,b)
c=(g+(((j>>>6|j<<26)^(j>>>11|j<<21)^(j>>>25|j<<7))>>>0)>>>0)+(((j&i^~j&h)>>>0)+(B.k[b]+s[b]>>>0)>>>0)>>>0
k=k+c>>>0
b=f&e
g=c+((((f>>>2|f<<30)^(f>>>13|f<<19)^(f>>>22|f<<10))>>>0)+((b^f&d^q)>>>0)>>>0)>>>0
q=p+3
if(!(q<64))return A.a(B.k,q)
c=(h+(((k>>>6|k<<26)^(k>>>11|k<<21)^(k>>>25|k<<7))>>>0)>>>0)+(((k&j^~k&i)>>>0)+(B.k[q]+s[q]>>>0)>>>0)>>>0
d=d+c>>>0
q=g&f
h=c+((((g>>>2|g<<30)^(g>>>13|g<<19)^(g>>>22|g<<10))>>>0)+((q^g&e^b)>>>0)>>>0)>>>0
b=p+4
if(!(b<64))return A.a(B.k,b)
c=(i+(((d>>>6|d<<26)^(d>>>11|d<<21)^(d>>>25|d<<7))>>>0)>>>0)+(((d&k^~d&j)>>>0)+(B.k[b]+s[b]>>>0)>>>0)>>>0
e=e+c>>>0
b=h&g
i=c+((((h>>>2|h<<30)^(h>>>13|h<<19)^(h>>>22|h<<10))>>>0)+((b^h&f^q)>>>0)>>>0)>>>0
q=p+5
if(!(q<64))return A.a(B.k,q)
c=(j+(((e>>>6|e<<26)^(e>>>11|e<<21)^(e>>>25|e<<7))>>>0)>>>0)+(((e&d^~e&k)>>>0)+(B.k[q]+s[q]>>>0)>>>0)>>>0
f=f+c>>>0
q=i&h
j=c+((((i>>>2|i<<30)^(i>>>13|i<<19)^(i>>>22|i<<10))>>>0)+((q^i&g^b)>>>0)>>>0)>>>0
b=p+6
if(!(b<64))return A.a(B.k,b)
c=(k+(((f>>>6|f<<26)^(f>>>11|f<<21)^(f>>>25|f<<7))>>>0)>>>0)+(((f&e^~f&d)>>>0)+(B.k[b]+s[b]>>>0)>>>0)>>>0
g=g+c>>>0
b=j&i
k=c+((((j>>>2|j<<30)^(j>>>13|j<<19)^(j>>>22|j<<10))>>>0)+((b^j&h^q)>>>0)>>>0)>>>0
q=p+7
if(!(q<64))return A.a(B.k,q)
c=(d+(((g>>>6|g<<26)^(g>>>11|g<<21)^(g>>>25|g<<7))>>>0)>>>0)+(((g&f^~g&e)>>>0)+(B.k[q]+s[q]>>>0)>>>0)>>>0
h=h+c>>>0
d=c+((((k>>>2|k<<30)^(k>>>13|k<<19)^(k>>>22|k<<10))>>>0)+((k&j^k&i^b)>>>0)>>>0)>>>0}r.$flags&2&&A.b(r)
r[0]=d+l>>>0
r[1]=k+r[1]>>>0
r[2]=j+r[2]>>>0
r[3]=i+r[3]>>>0
r[4]=h+r[4]>>>0
r[5]=g+r[5]>>>0
r[6]=f+r[6]>>>0
r[7]=e+r[7]>>>0}}
A.ew.prototype={
gec(){return this.y}}
A.eY.prototype={
aW(a,b,c,d){var s=t.L
s.a(a)
t.u.a(c)
return this.lu(a,s.a(b),c,d)},
lu(a,b,c,d){var s=0,r=A.a3(t.aX),q,p=this,o,n,m,l
var $async$aW=A.a4(function(e,f){if(e===1)return A.a0(f,r)
for(;;)switch(s){case 0:if(c==null)c=p.hU()
s=3
return A.A(A.i0(d,!1,!0,!1,p.c,"AES-GCM"),$async$aW)
case 3:o=f
s=4
return A.A(A.lw({name:"AES-GCM",iv:A.lF(c),additionalData:A.lF(b),tagLength:128},o,A.lF(a)),$async$aW)
case 4:n=f
m=a.length
l=J.cw(n)
q=new A.cO(l.bs(n,0,m),new A.dK(l.bs(n,m,null)),c)
s=1
break
case 1:return A.a1(q,r)}})
return A.a2($async$aW,r)},
gbl(){return this.c},
gbj(){return this.d}}
A.i_.prototype={
e5(a,b){var s=this.im(a,b),r=$.m3()
if(r&&b!==24)return new A.eY(b,a,null)
return s}}
A.c_.prototype={
ga1(a){return A.iA(B.cg,this.gbl(),this.gbj(),B.G)},
aC(a,b){if(b==null)return!1
return b instanceof A.c_&&this.gbl()===b.gbl()&&this.gbj()===b.gbj()},
n(a){var s=this
if(s.gbj()===12)return A.lz(s).n(0)+".with"+s.gbl()*8+"bits()"
return A.lz(s).n(0)+".with"+s.gbl()*8+"bits(nonceLength: "+s.gbj()+")"}}
A.i6.prototype={
hU(){var s=this.gbj(),r=new Uint8Array(s)
A.vy(r,this.a)
return r}}
A.ia.prototype={}
A.dK.prototype={
ga1(a){return B.C.cJ(this.a)},
aC(a,b){if(b==null)return!1
return b instanceof A.dK&&B.C.cF(this.a,b.a)},
n(a){var s=this.a
if(s.length===0)return"Mac.empty"
return"Mac(["+B.c.bi(s,",")+"])"}}
A.iF.prototype={}
A.it.prototype={
n(a){return A.lz(this).n(0)+"()"}}
A.cO.prototype={
ga1(a){return(B.C.cJ(this.b.a)^B.C.cJ(this.c)^B.C.cJ(this.a))>>>0},
aC(a,b){var s
if(b==null)return!1
if(b instanceof A.cO){s=B.C.cF(this.b.a,b.b.a)
s=s&&B.C.cF(this.c,b.c)&&B.C.cF(this.a,b.a)}else s=!1
return s},
n(a){return"SecretBox(\n  [~~"+this.a.length+" bytes~~],\n  nonce: ["+J.qD(this.c,",")+"],\n  mac: "+this.b.n(0)+",\n)"}}
A.mx.prototype={
$1(a){return t.bE.a(a).gbv()},
$S:39}
A.f6.prototype={
aW(a,b,c,d){var s=t.L
s.a(a)
t.u.a(c)
return this.lv(a,s.a(b),c,d)},
lv(a,b,c,d){var s=0,r=A.a3(t.aX),q,p=this,o,n,m
var $async$aW=A.a4(function(e,f){if(e===1)return A.a0(f,r)
for(;;)switch(s){case 0:o=a
n=b
m=c
s=3
return A.A(d.m9(),$async$aW)
case 3:q=p.lw(o,n,m,f)
s=1
break
case 1:return A.a1(q,r)}})
return A.a2($async$aW,r)},
lw(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=t.L
e.a(a)
t.u.a(c)
e.a(b)
s=d.gbv().gi(0)
r=this.d
if(s!==r)throw A.d(A.aZ(d,"secretKeyData","Expected "+r+" bytes, got "+s+" bytes"))
if(c==null)c=this.hU()
q=A.vi(d)
p=new Uint32Array(4)
A.n6(p,0,p,0,q)
p[0]=A.b9(p[0])
p[1]=A.b9(p[1])
p[2]=A.b9(p[2])
p[3]=A.b9(p[3])
o=A.r_(p,c)
n=J.qx(B.c.gN(o),0,null)
m=new Uint32Array(A.N(n))
A.pw(o,1)
e=a.length
l=(B.a.t(e+15,16)+1)*4
k=new Uint32Array(l)
for(j=0;j<l;j+=4){A.n6(k,j,n,0,q)
A.pw(o,1)}i=J.ak(B.f.gN(k),k.byteOffset,e)
for(l=i.length,h=i.$flags|0,j=0;j<e;++j){if(!(j<l))return A.a(i,j)
g=i[j]
f=a[j]
h&2&&A.b(i)
i[j]=g^f}return new A.cO(i,B.aF.iK(i,b,q,p,m),c)},
gbj(){return this.c},
gbl(){return this.d}}
A.ic.prototype={
n(a){return"DartGcm()"},
iK(a,b,c,d,e){var s,r,q,p,o,n=4294967296,m=t.L
m.a(a)
m.a(b)
s=new Uint32Array(4)
A.f7(s,d,b)
A.f7(s,d,a)
r=8*b.length
q=8*a.length
p=new DataView(new ArrayBuffer(16))
p.setUint32(0,B.a.t(r,n),!1)
p.setUint32(4,B.a.E(r,n),!1)
p.setUint32(8,B.a.t(q,n),!1)
p.setUint32(12,B.a.E(q,n),!1)
A.f7(s,d,J.ak(B.K.gN(p),0,null))
o=new Uint32Array(4)
A.n6(o,0,e,0,c)
s[0]=(s[0]^o[0])>>>0
s[1]=(s[1]^o[1])>>>0
s[2]=(s[2]^o[2])>>>0
s[3]=(s[3]^o[3])>>>0
return new A.dK(J.ak(B.f.gN(s),0,null))}}
A.fV.prototype={}
A.fW.prototype={}
A.ib.prototype={}
A.dq.prototype={
e5(a,b){if($.dc()!==B.B)A.j(A.az("BigEndian systems are unsupported"))
return new A.f6(a,b,this.a)}}
A.id.prototype={}
A.kc.prototype={
cF(a,b){var s,r,q,p=t.L
p.a(a)
p.a(b)
p=J.aj(a)
s=J.aj(b)
if(p.gi(a)!==s.gi(b))return!1
for(r=0,q=0;q<p.gi(a);++q)r=(r|p.l(a,q)^s.l(b,q))>>>0
return r===0},
cJ(a){var s,r,q,p,o
t.L.a(a)
for(s=J.aj(a),r=0,q=0;q<s.gi(a);++q){p=s.l(a,q)
o=B.a.E(q,16)
r=(r^B.a.q(p,o)^B.a.aJ(p,16-o))>>>0}return r}}
A.dp.prototype={}
A.fp.prototype={}
A.ls.prototype={
$1(a){var s=t.G.a(a).b
return s==="user"||s==="assistant"},
$S:6}
A.lt.prototype={
$1(a){var s=t.G.a(a).b
return s==="user"||s==="assistant"},
$S:6}
A.lr.prototype={
$1(a){return this.a.c+": "+A.a9(a)},
$S:12}
A.ln.prototype={
$1(a){return this.a.c+": "+A.a9(a)},
$S:12}
A.lo.prototype={
$1(a){return this.ie(t.I.a(a))},
ie(a){var s=0,r=A.a3(t.H),q,p=this
var $async$$1=A.a4(function(b,c){if(b===1)return A.a0(c,r)
for(;;)switch(s){case 0:q=B.b.m(p.a,a)
s=1
break
case 1:return A.a1(q,r)}})
return A.a2($async$$1,r)},
$S:33}
A.lp.prototype={
$0(){return A.i([],t.d)},
$S:34}
A.bE.prototype={}
A.bj.prototype={
gey(){var s=this.e,r=A.F(s)
return new A.aT(s,r.h("K(1)").a(new A.i9()),r.h("aT<1>")).gi(0)},
ge7(){var s=this.e,r=A.F(s)
return new A.aT(s,r.h("K(1)").a(new A.i7()),r.h("aT<1>")).gi(0)},
gd2(){var s=this.e,r=A.F(s)
return new A.aT(s,r.h("K(1)").a(new A.i8()),r.h("aT<1>")).gi(0)}}
A.i9.prototype={
$1(a){return t.G.a(a).b==="user"},
$S:6}
A.i7.prototype={
$1(a){return t.G.a(a).b==="assistant"},
$S:6}
A.i8.prototype={
$1(a){return t.G.a(a).b==="system"},
$S:6}
A.dU.prototype={}
A.M.prototype={
n(a){return this.a}}
A.kV.prototype={
$1(a){return t.f.b(a)&&a.a3("messages")},
$S:20}
A.kW.prototype={
$1(a){var s
if(t.f.b(a))s=a.a3("role")||a.a3("content")
else s=!1
return s},
$S:20}
A.bU.prototype={}
A.l2.prototype={
$0(){var s,r,q,p,o=null,n=this.a
if(n.e==null||n.d==null)return
s=B.e.ad(J.aY(n.d))
r=n.c
q=B.e.cN(B.a.n(r.length+1),6,"0")
p=n.e
p.toString
B.b.m(r,new A.bE("m-"+q,p,s,B.m.aL(A.z(["format","markdown","role",p,"line",n.f],t.N,t.X),o),o,o,o))
n.d=n.e=null},
$S:0}
A.l3.prototype={
$0(){var s,r,q,p,o,n,m,l=this
l.b.$0()
s=l.a
if(s.c.length===0)return
r=l.c
q=l.d
p=A.eJ(B.a6.a4(B.t.a4(q+"|"+s.a+"|"+r.length)).a)
o=s.a
n=s.c
m=A.i([],t.s)
if(s.b)m.push("\u672a\u627e\u5230 Markdown \u6807\u9898\uff0c\u4f7f\u7528\u6587\u4ef6\u540d\u4f5c\u4e3a\u4f1a\u8bdd\u6807\u9898\u3002")
B.b.m(r,A.nR(null,"Chatbox Markdown",p,n,null,q,o,m))
s.c=A.i([],t.e)},
$S:0}
A.l4.prototype={
$2$allowHeading(a,b){var s,r,q=A.an("^\\s{0,3}(?:#{2,4}\\s+)?(?:\\*\\*|__)?\\s*(\u7528\u6237|\u73a9\u5bb6|\u6211|User|Human|You|Assistant|AI|Bot|ChatGPT|DeepSeek|\u52a9\u624b|\u6a21\u578b|System|\u7cfb\u7edf)\\s*(?:\\*\\*|__)?\\s*[:\uff1a]\\s*(.*)$",!1).bA(a)
if(q!=null){s=q.b
if(1>=s.length)return A.a(s,1)
return s[1]}if(!b)return null
r=A.an("^\\s{0,3}(?:#{2,4}\\s+|\\*\\*|__)\\s*(\u7528\u6237|\u73a9\u5bb6|\u6211|User|Human|You|Assistant|AI|Bot|ChatGPT|DeepSeek|\u52a9\u624b|\u6a21\u578b|System|\u7cfb\u7edf)\\s*(?:\\*\\*|__)?\\s*$",!1).bA(a)
if(r==null)s=null
else{s=r.b
if(1>=s.length)return A.a(s,1)
s=s[1]}return s},
$1(a){return this.$2$allowHeading(a,!0)},
$S:36}
A.l5.prototype={
$1(a){var s,r=A.an("[:\uff1a]\\s*(.*)$",!1).bA(a)
if(r==null)r=null
else{r=r.b
if(1>=r.length)return A.a(r,1)
r=r[1]}s=B.e.ad(r==null?"":r)
r=A.an("^(\\*\\*|__)\\s*",!0)
return B.e.ad(A.vV(s,r,"",0))},
$S:12}
A.aA.prototype={
n(a){return this.a}}
A.j1.prototype={
ic(a,b){var s=0,r=A.a3(t.H),q=this,p,o,n,m,l,k,j,i,h,g
var $async$$2$last=A.a4(function(c,d){if(c===1)return A.a0(d,r)
for(;;)switch(s){case 0:h=B.t.a4(B.m.aL(a,null))
g=h.length
if(g>8388592||++q.a.b>1e5)throw A.d(B.cv)
if(!b){p=q.b
p.m(0,A.j_(g))
p.m(0,h)}g=q.c
s=g==null?2:4
break
case 2:o=h
s=3
break
case 4:p=$.qc()
n=q.d
m=q.a
l=A.rF(n,m.b)
k=t.S
n=A.aS(n,k)
B.b.af(n,A.j_(m.b))
s=5
return A.A(p.aW(h,n,l,g),$async$$2$last)
case 5:j=d
g=A.aS(j.a,k)
B.b.af(g,j.b.a)
o=g
case 3:g=q.a
p=g.a
n=o.length
i=p+(4+n)
g.a=i
if(i>67108864)throw A.d(B.ax)
g=q.e
g.m(0,A.j_(n))
g.m(0,o)
return A.a1(null,r)}})
return A.a2($async$$2$last,r)},
$2$last(a,b){return this.ic(t.I.a(a),b)},
$1(a){return this.$2$last(a,!1)},
$S:37}
A.ei.prototype={
m(a,b){return this.a=b},
al(){},
$iS:1}
A.ky.prototype={
aX(a){var s=0,r=A.a3(t.p),q,p=this,o,n,m,l
var $async$aX=A.a4(function(b,c){if(b===1)return A.a0(c,r)
for(;;)switch(s){case 0:if(a<=0||p.b>=p.a.length){q=new Uint8Array(0)
s=1
break}o=p.b
n=p.a
m=Math.min(o+a,n.length)
l=A.Q(n,o,m)
p.b=m
q=l
s=1
break
case 1:return A.a1(q,r)}})
return A.a2($async$aX,r)}}
A.lG.prototype={
$1(a){var s,r
A.f(a)
s=A.v(this.a.files)
if(s!=null&&A.H(s.length)>0){r=A.v(s.item(0))
r.toString
A.hi(r)}},
$S:2}
A.lH.prototype={
$1(a){A.f(a).preventDefault()
this.a.className="drop drag"},
$S:2}
A.lI.prototype={
$1(a){A.f(a)
this.a.className="drop"},
$S:2}
A.lM.prototype={
$1(a){var s,r,q
A.f(a)
a.preventDefault()
this.a.className="drop"
s=A.v(a.dataTransfer)
r=s==null?null:A.f(s.files)
if(r!=null&&A.H(r.length)>0){q=A.v(r.item(0))
q.toString
A.hi(q)}},
$S:2}
A.lN.prototype={
$1(a){A.f(a)
A.cr(!1,!0)
return null},
$S:1}
A.lO.prototype={
$1(a){A.f(a)
A.cr(!1,!1)
return null},
$S:1}
A.lP.prototype={
$1(a){A.f(a)
A.cr(!0,!1)
return null},
$S:1}
A.lQ.prototype={
$1(a){A.f(a)
A.lj()
return null},
$S:1}
A.lR.prototype={
$1(a){A.f(a)
return A.uo()},
$S:1}
A.lS.prototype={
$1(a){A.f(a)
return A.pg()},
$S:1}
A.lT.prototype={
$1(a){A.f(a)
return A.oZ()},
$S:1}
A.lJ.prototype={
$1(a){A.f(a)
return A.oZ()},
$S:1}
A.lK.prototype={
$1(a){A.f(a)
A.bX()
return null},
$S:1}
A.lL.prototype={
$1(a){A.f(a)
A.bX()
return null},
$S:1}
A.l9.prototype={
$1(a){A.b8(a)
return this.a},
$S:40}
A.l_.prototype={
$1(a){A.d2(a)},
$S:41}
A.l0.prototype={
$1(a){A.b8(a)},
$S:42}
A.l1.prototype={
$2(a,b){return A.H(a)+t.r.a(b).e.length},
$S:17}
A.l7.prototype={
$1(a){var s,r,q,p,o=this
A.f(a)
try{s=o.a.result
if(s==null){o.b.c_(B.aZ)
return}r=t.e9.a(s)
o.b.cA(A.od(r,0,null))}catch(p){q=A.G(p)
o.b.c_(q)}},
$S:2}
A.l8.prototype={
$1(a){var s
A.f(a)
s=this.a
if((s.a.a&30)===0)s.c_(B.b4)},
$S:2}
A.lc.prototype={
$2(a,b){return A.H(a)+t.r.a(b).e.length},
$S:17}
A.ld.prototype={
$1(a){var s
A.f(a)
s=this.b
if(A.d2(this.a.checked))$.bA.m(0,s)
else $.bA.lZ(0,s)
A.kT()
A.aM(null,!1)
A.la(this.c)},
$S:2}
A.le.prototype={
$1(a){return A.f(a).stopPropagation()},
$S:1}
A.lf.prototype={
$1(a){var s
A.f(a)
$.l6=this.a
s=this.b
A.pj(s)
A.pi(s)},
$S:2}
A.lb.prototype={
$2(a,b){var s
A.H(a)
A.H(b)
s=this.a.b
if(!(b>=0&&b<s.length))return A.a(s,b)
return a+s[b].e.length},
$S:8}
A.li.prototype={
$0(){return v.G.URL.revokeObjectURL(this.a)},
$S:0};(function aliases(){var s=J.bJ.prototype
s.io=s.n
s=A.o.prototype
s.eI=s.H
s=A.dq.prototype
s.im=s.e5})();(function installTearOffs(){var s=hunkHelpers._static_2,r=hunkHelpers._static_1,q=hunkHelpers._static_0,p=hunkHelpers._instance_2u,o=hunkHelpers._instance_0u,n=hunkHelpers._instance_1u,m=hunkHelpers.installInstanceTearOff
s(J,"u1","o1",44)
r(A,"vk","rW",9)
r(A,"vl","rX",9)
r(A,"vm","rY",9)
q(A,"pv","uV",0)
s(A,"vo","un",11)
q(A,"vn","um",0)
p(A.x.prototype,"giO","iP",11)
var l
o(l=A.ch.prototype,"gjV","jW",0)
o(l,"gjX","jY",0)
n(l=A.co.prototype,"gjP","jQ",31)
p(l,"gjT","jU",11)
o(l,"gjR","jS",0)
r(A,"vs","tM",19)
o(l=A.dh.prototype,"gbG","bH",0)
o(l,"geg","bf",0)
o(l=A.e5.prototype,"gbG","bH",0)
o(l,"geg","bf",0)
m(A.fL.prototype,"gl1",0,5,null,["$5"],["e8"],28,0,0)
o(l=A.ed.prototype,"gbG","bH",0)
o(l,"geg","bf",0)
r(A,"vj","n3",30)})();(function inheritance(){var s=hunkHelpers.mixin,r=hunkHelpers.inherit,q=hunkHelpers.inheritMany
r(A.m,null)
q(A.m,[A.mk,J.fh,A.dX,J.at,A.ka,A.h,A.dl,A.D,A.bD,A.L,A.o,A.iG,A.au,A.dL,A.e4,A.du,A.bl,A.R,A.b3,A.b7,A.cB,A.ck,A.bP,A.iP,A.iz,A.dv,A.ex,A.ir,A.dI,A.dJ,A.dH,A.dC,A.eo,A.fO,A.fA,A.hb,A.kb,A.hf,A.b1,A.h_,A.hd,A.kF,A.fP,A.cp,A.aa,A.fR,A.b5,A.x,A.fQ,A.dZ,A.d0,A.ee,A.ef,A.bv,A.fY,A.b6,A.co,A.jo,A.h4,A.el,A.en,A.aD,A.a_,A.k7,A.eZ,A.kw,A.kK,A.eE,A.aF,A.bG,A.kf,A.fu,A.dY,A.kg,A.ay,A.a7,A.W,A.hc,A.fx,A.bS,A.iy,A.h0,A.fa,A.bc,A.hZ,A.aI,A.i1,A.i2,A.hx,A.hA,A.is,A.h3,A.ke,A.cM,A.iE,A.h5,A.iW,A.hg,A.iT,A.fH,A.eF,A.j8,A.j5,A.dw,A.eg,A.fU,A.e8,A.j6,A.fT,A.eG,A.kP,A.j9,A.jc,A.cF,A.il,A.j2,A.j4,A.cR,A.ii,A.aU,A.ks,A.kC,A.im,A.e6,A.e9,A.jZ,A.ea,A.jr,A.js,A.ju,A.mB,A.jB,A.jy,A.jz,A.jG,A.jD,A.jC,A.jL,A.jK,A.jH,A.jN,A.jV,A.jM,A.jO,A.jP,A.jQ,A.jS,A.jW,A.jX,A.jY,A.ey,A.k_,A.fK,A.k2,A.jv,A.fJ,A.f5,A.by,A.iX,A.hu,A.hv,A.f4,A.kd,A.i3,A.iH,A.ik,A.iI,A.aR,A.f9,A.i6,A.ia,A.dK,A.iF,A.it,A.cO,A.ib,A.id,A.kc,A.dp,A.fp,A.bE,A.bj,A.dU,A.M,A.bU,A.aA,A.ei,A.ky])
q(J.fh,[J.dz,J.dB,J.dD,J.cI,J.cJ,J.cH,J.bI])
q(J.dD,[J.bJ,J.u,A.bK,A.dO])
q(J.bJ,[J.fv,J.cc,J.bm])
r(J.fi,A.dX)
r(J.ip,J.u)
q(J.cH,[J.dA,J.fj])
q(A.h,[A.cW,A.n,A.c8,A.aT,A.dy,A.cj,A.fN,A.ha,A.bx,A.cN,A.dd])
r(A.c1,A.cW)
r(A.ej,A.c1)
q(A.D,[A.c2,A.bn,A.h1])
q(A.bD,[A.f1,A.i4,A.f0,A.fB,A.lB,A.lD,A.k4,A.k3,A.kR,A.kq,A.iK,A.iM,A.iu,A.ku,A.ig,A.ih,A.lW,A.lX,A.hz,A.hX,A.hY,A.hW,A.hN,A.hL,A.hO,A.hK,A.hG,A.hE,A.hF,A.hI,A.hH,A.hD,A.hV,A.hT,A.hP,A.hU,A.hR,A.iV,A.jk,A.je,A.jg,A.jj,A.ja,A.j3,A.jx,A.lY,A.io,A.mx,A.ls,A.lt,A.lr,A.ln,A.lo,A.i9,A.i7,A.i8,A.kV,A.kW,A.l4,A.l5,A.j1,A.lG,A.lH,A.lI,A.lM,A.lN,A.lO,A.lP,A.lQ,A.lR,A.lS,A.lT,A.lJ,A.lK,A.lL,A.l9,A.l_,A.l0,A.l7,A.l8,A.ld,A.le,A.lf])
q(A.f1,[A.i5,A.lC,A.kS,A.lm,A.kr,A.iv,A.kx,A.hM,A.hJ,A.hC,A.hB,A.hQ,A.hS,A.l1,A.lc,A.lb])
q(A.L,[A.c5,A.bs,A.fk,A.fD,A.fy,A.fZ,A.dF,A.eU,A.aQ,A.e3,A.fC,A.bR,A.f3])
r(A.cP,A.o)
q(A.cP,[A.f2,A.e2])
q(A.f0,[A.lV,A.k5,A.k6,A.kG,A.ij,A.kh,A.km,A.kl,A.kj,A.ki,A.kp,A.ko,A.kn,A.iL,A.iJ,A.iN,A.kE,A.kD,A.k9,A.k8,A.kA,A.kz,A.jq,A.jp,A.lg,A.kJ,A.kI,A.f8,A.hy,A.iU,A.jm,A.jl,A.jf,A.jh,A.jn,A.jd,A.j7,A.jb,A.kN,A.jw,A.lp,A.l2,A.l3,A.li])
q(A.n,[A.P,A.dt,A.bo,A.bp,A.c6,A.em])
q(A.P,[A.e0,A.av,A.b0,A.h2])
r(A.ds,A.c8)
r(A.dr,A.dy)
q(A.b7,[A.cm,A.cZ])
q(A.cm,[A.cn,A.bw])
r(A.d_,A.cZ)
q(A.cB,[A.dn,A.c4])
q(A.bP,[A.dm,A.ev])
r(A.cC,A.dm)
r(A.dT,A.bs)
q(A.fB,[A.fz,A.cA])
r(A.dE,A.bn)
r(A.cL,A.bK)
q(A.dO,[A.dM,A.ad])
q(A.ad,[A.er,A.et])
r(A.es,A.er)
r(A.bL,A.es)
r(A.eu,A.et)
r(A.aH,A.eu)
q(A.bL,[A.fq,A.fr])
q(A.aH,[A.fs,A.dN,A.ft,A.dP,A.dR,A.dS,A.c9])
r(A.ez,A.fZ)
r(A.cg,A.fR)
r(A.cV,A.d0)
r(A.ch,A.ef)
q(A.bv,[A.eh,A.cY])
r(A.ep,A.dZ)
r(A.eq,A.cV)
r(A.ek,A.ev)
q(A.aD,[A.cD,A.di,A.fl])
q(A.cD,[A.eS,A.fE])
q(A.a_,[A.he,A.eW,A.fo,A.fn,A.fG,A.fF,A.fc])
r(A.eT,A.he)
r(A.fm,A.dF)
r(A.kv,A.kw)
q(A.aQ,[A.bq,A.fe])
q(A.kf,[A.be,A.aw,A.iS,A.e7,A.cX,A.dk])
q(A.aI,[A.eX,A.iZ,A.fM,A.dG,A.bQ,A.fX,A.bg])
q(A.eZ,[A.f_,A.fd])
q(A.f_,[A.dh,A.e5,A.ed])
q(A.dw,[A.bT,A.bH])
q(A.cF,[A.fS,A.cE,A.a6])
r(A.kM,A.j2)
r(A.kO,A.j4)
r(A.fL,A.jZ)
r(A.aP,A.ay)
q(A.aP,[A.jt,A.jA,A.jF,A.jE,A.jJ,A.jI,A.jR,A.k1,A.k0,A.c0,A.de,A.dg])
r(A.df,A.c0)
q(A.fc,[A.h6,A.h8])
q(A.fd,[A.h7,A.h9])
r(A.ew,A.h9)
r(A.c_,A.i6)
q(A.c_,[A.eY,A.fV])
r(A.dq,A.ia)
r(A.i_,A.dq)
r(A.f6,A.fV)
r(A.fW,A.it)
r(A.ic,A.fW)
s(A.cP,A.b3)
s(A.er,A.o)
s(A.es,A.R)
s(A.et,A.o)
s(A.eu,A.R)
s(A.cV,A.ee)
s(A.fV,A.ib)
s(A.fW,A.id)})()
var v={G:typeof self!="undefined"?self:globalThis,typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{e:"int",t:"double",aC:"num",l:"String",K:"bool",W:"Null",k:"List",m:"Object",V:"Map",J:"JSObject"},mangledNames:{},types:["~()","~(J)","W(J)","K()","e(e)","K(aI)","K(bE)","~(e)","e(e,e)","~(~())","~(@)","~(m,b2)","l(l)","K(e)","~(e,e,e)","@(l)","W(@)","e(e,bj)","W()","@(@)","K(@)","~(m?,m?)","@()","~(bh)","e(l?)","~(e,e)","e(e,e,e)","am<~>()","~(e,e,ff,e,e)","l(k<e>)","m?(m?)","~(m?)","W(m,b2)","am<~>(V<l,m?>)","k<V<l,m?>>()","~(e,@)","l?(l{allowHeading:K})","am<~>(V<l,m?>{last:K})","W(@,b2)","k<e>(mw)","J(m)","W(K)","W(m)","W(~())","e(@,@)","@(@,l)","0&()"],interceptorsByTag:null,leafTags:null,arrayRti:Symbol("$ti"),rttc:{"2;":(a,b)=>c=>c instanceof A.cn&&a.b(c.a)&&b.b(c.b),"2;mode,size":(a,b)=>c=>c instanceof A.bw&&a.b(c.a)&&b.b(c.b),"3;":(a,b,c)=>d=>d instanceof A.d_&&a.b(d.a)&&b.b(d.b)&&c.b(d.c)}}
A.tl(v.typeUniverse,JSON.parse('{"bm":"bJ","fv":"bJ","cc":"bJ","wk":"bK","dz":{"K":[],"E":[]},"dB":{"W":[],"E":[]},"dD":{"J":[]},"bJ":{"J":[]},"u":{"k":["1"],"n":["1"],"J":[],"h":["1"],"af":["1"]},"fi":{"dX":[]},"ip":{"u":["1"],"k":["1"],"n":["1"],"J":[],"h":["1"],"af":["1"]},"at":{"C":["1"]},"cH":{"t":[],"aC":[],"aE":["aC"]},"dA":{"t":[],"e":[],"aC":[],"aE":["aC"],"E":[]},"fj":{"t":[],"aC":[],"aE":["aC"],"E":[]},"bI":{"l":[],"aE":["l"],"iB":[],"af":["@"],"E":[]},"cW":{"h":["2"]},"dl":{"C":["2"]},"c1":{"cW":["1","2"],"h":["2"],"h.E":"2"},"ej":{"c1":["1","2"],"cW":["1","2"],"n":["2"],"h":["2"],"h.E":"2"},"c2":{"D":["3","4"],"V":["3","4"],"D.K":"3","D.V":"4"},"c5":{"L":[]},"f2":{"o":["e"],"b3":["e"],"k":["e"],"n":["e"],"h":["e"],"o.E":"e","b3.E":"e"},"n":{"h":["1"]},"P":{"n":["1"],"h":["1"]},"e0":{"P":["1"],"n":["1"],"h":["1"],"P.E":"1","h.E":"1"},"au":{"C":["1"]},"c8":{"h":["2"],"h.E":"2"},"ds":{"c8":["1","2"],"n":["2"],"h":["2"],"h.E":"2"},"dL":{"C":["2"]},"av":{"P":["2"],"n":["2"],"h":["2"],"P.E":"2","h.E":"2"},"aT":{"h":["1"],"h.E":"1"},"e4":{"C":["1"]},"dt":{"n":["1"],"h":["1"],"h.E":"1"},"du":{"C":["1"]},"dy":{"h":["+(e,1)"],"h.E":"+(e,1)"},"dr":{"dy":["1"],"n":["+(e,1)"],"h":["+(e,1)"],"h.E":"+(e,1)"},"bl":{"C":["+(e,1)"]},"cP":{"o":["1"],"b3":["1"],"k":["1"],"n":["1"],"h":["1"]},"b0":{"P":["1"],"n":["1"],"h":["1"],"P.E":"1","h.E":"1"},"cn":{"cm":[],"b7":[]},"bw":{"cm":[],"b7":[]},"d_":{"cZ":[],"b7":[]},"cB":{"V":["1","2"]},"dn":{"cB":["1","2"],"V":["1","2"]},"cj":{"h":["1"],"h.E":"1"},"ck":{"C":["1"]},"c4":{"cB":["1","2"],"V":["1","2"]},"dm":{"bP":["1"],"n":["1"],"h":["1"]},"cC":{"dm":["1"],"bP":["1"],"n":["1"],"h":["1"]},"dT":{"bs":[],"L":[]},"fk":{"L":[]},"fD":{"L":[]},"ex":{"b2":[]},"bD":{"c3":[]},"f0":{"c3":[]},"f1":{"c3":[]},"fB":{"c3":[]},"fz":{"c3":[]},"cA":{"c3":[]},"fy":{"L":[]},"bn":{"D":["1","2"],"mm":["1","2"],"V":["1","2"],"D.K":"1","D.V":"2"},"bo":{"n":["1"],"h":["1"],"h.E":"1"},"dI":{"C":["1"]},"bp":{"n":["1"],"h":["1"],"h.E":"1"},"dJ":{"C":["1"]},"c6":{"n":["a7<1,2>"],"h":["a7<1,2>"],"h.E":"a7<1,2>"},"dH":{"C":["a7<1,2>"]},"dE":{"bn":["1","2"],"D":["1","2"],"mm":["1","2"],"V":["1","2"],"D.K":"1","D.V":"2"},"cm":{"b7":[]},"cZ":{"b7":[]},"dC":{"rw":[],"iB":[]},"eo":{"dW":[],"cK":[]},"fN":{"h":["dW"],"h.E":"dW"},"fO":{"C":["dW"]},"fA":{"cK":[]},"ha":{"h":["cK"],"h.E":"cK"},"hb":{"C":["cK"]},"cL":{"bK":[],"J":[],"dj":[],"E":[]},"bK":{"J":[],"dj":[],"E":[]},"dO":{"J":[],"Y":[]},"hf":{"dj":[]},"dM":{"mb":[],"J":[],"Y":[],"E":[]},"ad":{"aG":["1"],"J":[],"Y":[],"af":["1"]},"bL":{"o":["t"],"ad":["t"],"k":["t"],"aG":["t"],"n":["t"],"J":[],"Y":[],"af":["t"],"h":["t"],"R":["t"]},"aH":{"o":["e"],"ad":["e"],"k":["e"],"aG":["e"],"n":["e"],"J":[],"Y":[],"af":["e"],"h":["e"],"R":["e"]},"fq":{"bL":[],"o":["t"],"ad":["t"],"k":["t"],"aG":["t"],"n":["t"],"J":[],"Y":[],"af":["t"],"h":["t"],"R":["t"],"E":[],"o.E":"t","R.E":"t"},"fr":{"bL":[],"o":["t"],"ad":["t"],"k":["t"],"aG":["t"],"n":["t"],"J":[],"Y":[],"af":["t"],"h":["t"],"R":["t"],"E":[],"o.E":"t","R.E":"t"},"fs":{"aH":[],"ff":[],"o":["e"],"ad":["e"],"k":["e"],"aG":["e"],"n":["e"],"J":[],"Y":[],"af":["e"],"h":["e"],"R":["e"],"E":[],"o.E":"e","R.E":"e"},"dN":{"aH":[],"fg":[],"o":["e"],"ad":["e"],"k":["e"],"aG":["e"],"n":["e"],"J":[],"Y":[],"af":["e"],"h":["e"],"R":["e"],"E":[],"o.E":"e","R.E":"e"},"ft":{"aH":[],"o":["e"],"ad":["e"],"k":["e"],"aG":["e"],"n":["e"],"J":[],"Y":[],"af":["e"],"h":["e"],"R":["e"],"E":[],"o.E":"e","R.E":"e"},"dP":{"aH":[],"mz":[],"o":["e"],"ad":["e"],"k":["e"],"aG":["e"],"n":["e"],"J":[],"Y":[],"af":["e"],"h":["e"],"R":["e"],"E":[],"o.E":"e","R.E":"e"},"dR":{"aH":[],"e1":[],"o":["e"],"ad":["e"],"k":["e"],"aG":["e"],"n":["e"],"J":[],"Y":[],"af":["e"],"h":["e"],"R":["e"],"E":[],"o.E":"e","R.E":"e"},"dS":{"aH":[],"o":["e"],"ad":["e"],"k":["e"],"aG":["e"],"n":["e"],"J":[],"Y":[],"af":["e"],"h":["e"],"R":["e"],"E":[],"o.E":"e","R.E":"e"},"c9":{"aH":[],"bh":[],"o":["e"],"ad":["e"],"k":["e"],"aG":["e"],"n":["e"],"J":[],"Y":[],"af":["e"],"h":["e"],"R":["e"],"E":[],"o.E":"e","R.E":"e"},"fZ":{"L":[]},"ez":{"bs":[],"L":[]},"iw":{"S":["1"]},"cp":{"C":["1"]},"bx":{"h":["1"],"h.E":"1"},"aa":{"L":[]},"cg":{"fR":["1"]},"x":{"am":["1"]},"d0":{"S":["1"],"mL":["1"],"bV":["1"]},"cV":{"ee":["1"],"d0":["1"],"S":["1"],"mL":["1"],"bV":["1"]},"ch":{"ef":["1"],"e_":["1"],"bV":["1"]},"ef":{"e_":["1"],"bV":["1"]},"eh":{"bv":["1"]},"cY":{"bv":["@"]},"fY":{"bv":["@"]},"ep":{"dZ":["1"]},"eq":{"ee":["1"],"d0":["1"],"iw":["1"],"S":["1"],"mL":["1"],"bV":["1"]},"ek":{"bP":["1"],"n":["1"],"h":["1"]},"el":{"C":["1"]},"e2":{"o":["1"],"b3":["1"],"k":["1"],"n":["1"],"h":["1"],"o.E":"1","b3.E":"1"},"o":{"k":["1"],"n":["1"],"h":["1"]},"D":{"V":["1","2"]},"em":{"n":["2"],"h":["2"],"h.E":"2"},"en":{"C":["2"]},"bP":{"n":["1"],"h":["1"]},"ev":{"bP":["1"],"n":["1"],"h":["1"]},"h1":{"D":["l","@"],"V":["l","@"],"D.K":"l","D.V":"@"},"h2":{"P":["l"],"n":["l"],"h":["l"],"P.E":"l","h.E":"l"},"eS":{"cD":[],"aD":["l","k<e>"],"aD.S":"l"},"he":{"a_":["l","k<e>"]},"eT":{"a_":["l","k<e>"],"a_.T":"k<e>"},"di":{"aD":["k<e>","l"],"aD.S":"k<e>"},"eW":{"a_":["k<e>","l"],"a_.T":"l"},"eZ":{"S":["k<e>"]},"cD":{"aD":["l","k<e>"]},"dF":{"L":[]},"fm":{"L":[]},"fl":{"aD":["m?","l"],"aD.S":"m?"},"fo":{"a_":["m?","l"],"a_.T":"l"},"fn":{"a_":["l","m?"],"a_.T":"m?"},"fE":{"cD":[],"aD":["l","k<e>"],"aD.S":"l"},"fG":{"a_":["l","k<e>"],"a_.T":"k<e>"},"fF":{"a_":["k<e>","l"],"a_.T":"l"},"aF":{"aE":["aF"]},"t":{"aC":[],"aE":["aC"]},"bG":{"aE":["bG"]},"e":{"aC":[],"aE":["aC"]},"k":{"n":["1"],"h":["1"]},"aC":{"aE":["aC"]},"dW":{"cK":[]},"l":{"aE":["l"],"iB":[]},"eU":{"L":[]},"bs":{"L":[]},"aQ":{"L":[]},"bq":{"L":[]},"fe":{"bq":[],"L":[]},"e3":{"L":[]},"fC":{"L":[]},"bR":{"L":[]},"f3":{"L":[]},"fu":{"L":[]},"dY":{"L":[]},"hc":{"b2":[]},"cN":{"h":["e"],"h.E":"e"},"fx":{"C":["e"]},"bS":{"rz":[]},"h0":{"rt":[]},"mb":{"Y":[]},"rb":{"k":["e"],"n":["e"],"Y":[],"h":["e"]},"bh":{"k":["e"],"n":["e"],"Y":[],"h":["e"]},"rC":{"k":["e"],"n":["e"],"Y":[],"h":["e"]},"ff":{"k":["e"],"n":["e"],"Y":[],"h":["e"]},"mz":{"k":["e"],"n":["e"],"Y":[],"h":["e"]},"fg":{"k":["e"],"n":["e"],"Y":[],"h":["e"]},"e1":{"k":["e"],"n":["e"],"Y":[],"h":["e"]},"r7":{"k":["t"],"n":["t"],"Y":[],"h":["t"]},"r8":{"k":["t"],"n":["t"],"Y":[],"h":["t"]},"dd":{"h":["bc"],"h.E":"bc"},"eX":{"aI":[]},"dh":{"S":["k<e>"]},"e5":{"S":["k<e>"]},"iZ":{"aI":[]},"bT":{"dw":[]},"eg":{"qT":[]},"fU":{"S":["k<e>"]},"fT":{"S":["k<e>"]},"fS":{"cF":[]},"fM":{"aI":[]},"cR":{"S":["k<e>"]},"ed":{"S":["k<e>"]},"dG":{"aI":[]},"f_":{"S":["k<e>"]},"bQ":{"aI":[]},"bH":{"dw":[]},"cE":{"cF":[]},"fX":{"aI":[]},"a6":{"cF":[]},"bg":{"aI":[]},"f9":{"S":["aR"]},"fc":{"a_":["k<e>","aR"]},"fd":{"S":["k<e>"]},"h6":{"a_":["k<e>","aR"],"a_.T":"aR"},"h7":{"S":["k<e>"]},"h8":{"a_":["k<e>","aR"],"a_.T":"aR"},"h9":{"S":["k<e>"]},"ew":{"S":["k<e>"]},"eY":{"c_":[]},"mw":{"wn":[]},"f6":{"c_":[]},"ei":{"S":["aR"]}}'))
A.tk(v.typeUniverse,JSON.parse('{"cP":1,"ad":1,"cV":1,"bv":1,"ev":1}'))
var u={c:"Error handler must accept one Object or one Object and a StackTrace as arguments, and return a value of the returned future's type"}
var t=(function rtii(){var s=A.aW
return{a7:s("@<~>"),bv:s("bc"),n:s("aa"),bB:s("di"),dI:s("dj"),c:s("dk"),e8:s("aE<@>"),ew:s("be"),R:s("cC<l>"),h:s("dp"),G:s("bE"),r:s("bj"),dy:s("aF"),fu:s("bG"),U:s("n<@>"),C:s("L"),Y:s("c3"),w:s("fg"),bM:s("h<t>"),hf:s("h<@>"),hb:s("h<e>"),V:s("u<bc>"),e:s("u<bE>"),b:s("u<bj>"),eO:s("u<J>"),gE:s("u<V<l,l>>"),d:s("u<V<l,m?>>"),J:s("u<m>"),g1:s("u<aI>"),gK:s("u<cM>"),s:s("u<l>"),a:s("u<bh>"),fT:s("u<e8>"),et:s("u<h5>"),ey:s("u<hg>"),c5:s("u<eF>"),aY:s("u<eG>"),o:s("u<@>"),t:s("u<e>"),ff:s("u<bh?>"),aP:s("af<@>"),T:s("dB"),m:s("J"),W:s("bm"),aU:s("aG<@>"),A:s("k<fg>"),aS:s("k<V<l,m?>>"),x:s("k<l>"),fb:s("k<e1>"),B:s("k<bh>"),fz:s("k<eF>"),dX:s("k<eG>"),j:s("k<@>"),L:s("k<e>"),d1:s("V<l,@>"),f:s("V<@,@>"),I:s("V<l,m?>"),gJ:s("fp"),e9:s("cL"),d4:s("bL"),eB:s("aH"),gu:s("ad<@>"),bm:s("c9"),P:s("W"),K:s("m"),bl:s("bg"),b8:s("bq"),gT:s("wm"),bQ:s("+()"),cz:s("dW"),al:s("cN"),aX:s("cO"),bE:s("mw"),E:s("S<aR>"),l:s("b2"),N:s("l"),dm:s("E"),eK:s("bs"),ai:s("e1"),p:s("bh"),ak:s("cc"),gm:s("e2<bc>"),dS:s("bT"),gz:s("cg<bh>"),fg:s("x<bh>"),k:s("x<K>"),_:s("x<@>"),fJ:s("x<e>"),D:s("x<~>"),fv:s("d1<m?>"),eQ:s("co<V<l,m?>>"),as:s("bx<e8>"),y:s("K"),gg:s("K()"),bN:s("K(m)"),i:s("t"),z:s("@"),O:s("@()"),v:s("@(m)"),Q:s("@(m,b2)"),S:s("e"),eH:s("am<W>?"),an:s("J?"),bF:s("k<@>?"),u:s("k<e>?"),X:s("m?"),dk:s("l?"),ev:s("bv<@>?"),F:s("b5<@,@>?"),g:s("h4?"),fQ:s("K?"),cD:s("t?"),h6:s("e?"),cg:s("aC?"),Z:s("~()?"),q:s("aC"),H:s("~"),M:s("~()"),d5:s("~(m)"),da:s("~(m,b2)"),cA:s("~(l,@)"),cl:s("~(e,@)")}})();(function constants(){var s=hunkHelpers.makeConstList
B.be=J.fh.prototype
B.b=J.u.prototype
B.bf=J.dz.prototype
B.a=J.dA.prototype
B.w=J.cH.prototype
B.e=J.bI.prototype
B.bg=J.bm.prototype
B.bh=J.dD.prototype
B.K=A.dM.prototype
B.c8=A.dN.prototype
B.j=A.dP.prototype
B.f=A.dR.prototype
B.c=A.c9.prototype
B.au=J.fv.prototype
B.Z=J.cc.prototype
B.d=new A.dk(0,"littleEndian")
B.y=new A.dk(1,"bigEndian")
B.aC=new A.eS()
B.a3=new A.eT()
B.aE=new A.eW()
B.aD=new A.di()
B.aF=new A.ic()
B.aG=new A.du(A.aW("du<0&>"))
B.J=new A.fa()
B.B=new A.fa()
B.a5=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
B.aH=function() {
  var toStringFunction = Object.prototype.toString;
  function getTag(o) {
    var s = toStringFunction.call(o);
    return s.substring(8, s.length - 1);
  }
  function getUnknownTag(object, tag) {
    if (/^HTML[A-Z].*Element$/.test(tag)) {
      var name = toStringFunction.call(object);
      if (name == "[object Object]") return null;
      return "HTMLElement";
    }
  }
  function getUnknownTagGenericBrowser(object, tag) {
    if (object instanceof HTMLElement) return "HTMLElement";
    return getUnknownTag(object, tag);
  }
  function prototypeForTag(tag) {
    if (typeof window == "undefined") return null;
    if (typeof window[tag] == "undefined") return null;
    var constructor = window[tag];
    if (typeof constructor != "function") return null;
    return constructor.prototype;
  }
  function discriminator(tag) { return null; }
  var isBrowser = typeof HTMLElement == "function";
  return {
    getTag: getTag,
    getUnknownTag: isBrowser ? getUnknownTagGenericBrowser : getUnknownTag,
    prototypeForTag: prototypeForTag,
    discriminator: discriminator };
}
B.aM=function(getTagFallback) {
  return function(hooks) {
    if (typeof navigator != "object") return hooks;
    var userAgent = navigator.userAgent;
    if (typeof userAgent != "string") return hooks;
    if (userAgent.indexOf("DumpRenderTree") >= 0) return hooks;
    if (userAgent.indexOf("Chrome") >= 0) {
      function confirm(p) {
        return typeof window == "object" && window[p] && window[p].name == p;
      }
      if (confirm("Window") && confirm("HTMLElement")) return hooks;
    }
    hooks.getTag = getTagFallback;
  };
}
B.aI=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
B.aL=function(hooks) {
  if (typeof navigator != "object") return hooks;
  var userAgent = navigator.userAgent;
  if (typeof userAgent != "string") return hooks;
  if (userAgent.indexOf("Firefox") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "GeoGeolocation": "Geolocation",
    "Location": "!Location",
    "WorkerMessageEvent": "MessageEvent",
    "XMLDocument": "!Document"};
  function getTagFirefox(o) {
    var tag = getTag(o);
    return quickMap[tag] || tag;
  }
  hooks.getTag = getTagFirefox;
}
B.aK=function(hooks) {
  if (typeof navigator != "object") return hooks;
  var userAgent = navigator.userAgent;
  if (typeof userAgent != "string") return hooks;
  if (userAgent.indexOf("Trident/") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "HTMLDDElement": "HTMLElement",
    "HTMLDTElement": "HTMLElement",
    "HTMLPhraseElement": "HTMLElement",
    "Position": "Geoposition"
  };
  function getTagIE(o) {
    var tag = getTag(o);
    var newTag = quickMap[tag];
    if (newTag) return newTag;
    if (tag == "Object") {
      if (window.DataView && (o instanceof window.DataView)) return "DataView";
    }
    return tag;
  }
  function prototypeForTagIE(tag) {
    var constructor = window[tag];
    if (constructor == null) return null;
    return constructor.prototype;
  }
  hooks.getTag = getTagIE;
  hooks.prototypeForTag = prototypeForTagIE;
}
B.aJ=function(hooks) {
  var getTag = hooks.getTag;
  var prototypeForTag = hooks.prototypeForTag;
  function getTagFixed(o) {
    var tag = getTag(o);
    if (tag == "Document") {
      if (!!o.xmlVersion) return "!Document";
      return "!HTMLDocument";
    }
    return tag;
  }
  function prototypeForTagFixed(tag) {
    if (tag == "Document") return null;
    return prototypeForTag(tag);
  }
  hooks.getTag = getTagFixed;
  hooks.prototypeForTag = prototypeForTagFixed;
}
B.a4=function(hooks) { return hooks; }

B.m=new A.fl()
B.aN=new A.fu()
B.G=new A.iG()
B.T=new A.fE()
B.t=new A.fG()
B.n=new A.jo()
B.C=new A.kc()
B.U=new A.fY()
B.a6=new A.h6()
B.aO=new A.h8()
B.a7=new A.kM()
B.a8=new A.kO()
B.l=new A.be(0,"none")
B.u=new A.be(1,"deflate")
B.H=new A.be(2,"bzip2")
B.z=new A.be(3,"zstd")
B.D=new A.be(4,"lzma")
B.E=new A.be(5,"xz")
B.aP=new A.M("ZIP \u635f\u574f\u6216\u4e0d\u662f\u6807\u51c6 ZIP \u6587\u4ef6\uff1b\u539f\u59cb\u6587\u4ef6\u672a\u88ab\u4fee\u6539\u3002")
B.aQ=new A.M("ZIP \u6761\u76ee\u8d85\u8fc7 5000 \u4e2a\uff0c\u5df2\u505c\u6b62\u3002")
B.aR=new A.M("\u4f1a\u8bdd\u6570\u91cf\u8d85\u8fc7 200 \u4e2a\uff0c\u8bf7\u62c6\u5206\u6587\u4ef6\u540e\u518d\u8f6c\u6362\u3002")
B.a9=new A.M("\u6ca1\u6709\u9009\u4e2d\u4f1a\u8bdd\u3002")
B.aS=new A.M("\u672a\u8bc6\u522b\u5230\u5bf9\u8bdd\u89d2\u8272\u6807\u8bb0\uff08\u5982 User: / Assistant: / \u7528\u6237\uff1a/ \u52a9\u624b\uff1a\uff09\u3002\u672a\u8f6c\u6362\u4efb\u4f55\u5185\u5bb9\u3002")
B.aT=new A.M("\u5355\u6587\u4ef6\u6d88\u606f\u6570\u8d85\u8fc7 50000 \u6761\uff0c\u8bf7\u62c6\u5206\u540e\u518d\u8f6c\u6362\u3002")
B.aU=new A.M("\u6587\u4ef6\u8d85\u8fc7 32 MiB\uff0c\u8f6c\u6362\u5668\u4e0d\u652f\u6301\u8fd9\u4e48\u5927\u7684\u5355\u6587\u4ef6\u3002")
B.aV=new A.M("ZIP \u89e3\u538b\u540e\u7684 JSON \u8d85\u8fc7 64 MiB\uff0c\u5df2\u505c\u6b62\u3002")
B.aW=new A.M("\u6587\u4ef6\u4e0d\u662f\u6709\u6548\u7684 UTF-8 \u6587\u672c\uff1b\u8f6c\u6362\u5668\u4e0d\u4f1a\u731c\u6d4b\u7f16\u7801\u3002")
B.aX=new A.M("ZIP \u4e2d\u6ca1\u6709\u8bc6\u522b\u5230\u4f1a\u8bdd\u6d88\u606f\u3002\u82e5\u662f Chatbox \u5907\u4efd\uff0c\u8bf7\u786e\u8ba4\u9009\u62e9\u7684\u662f\u804a\u5929\u8bb0\u5f55\u800c\u4e0d\u662f\u8bbe\u7f6e/\u8d44\u6e90\u5305\u3002")
B.aY=new A.M("\u5185\u90e8\u5f52\u6863\u7ed3\u6784\u4e0d\u5b8c\u6574\uff0c\u672a\u751f\u6210\u5408\u5e76\u5f52\u6863\u3002")
B.aZ=new A.M("\u6587\u4ef6\u8bfb\u53d6\u7ed3\u679c\u4e3a\u7a7a\u3002")
B.b_=new A.M("\u6d88\u606f\u5143\u6570\u636e\u5305\u542b\u7591\u4f3c API Key\uff1b\u5df2\u505c\u6b62\u3002\u8bf7\u5148\u5728\u6e90\u5bfc\u51fa\u4e2d\u79fb\u9664\u8be5\u5b57\u6bb5\u3002")
B.b0=new A.M("\u5bf9\u8bdd\u6b63\u6587\u5305\u542b\u7591\u4f3c API Key\uff1b\u5df2\u505c\u6b62\uff0c\u4e0d\u4f1a\u628a\u5bc6\u94a5\u5199\u8fdb .yuzhe\u3002")
B.b1=new A.M("\u6ca1\u6709\u8bc6\u522b\u5230\u5305\u542b messages \u7684\u5bf9\u8bdd\u7ed3\u6784\u3002\u8bf7\u786e\u8ba4\u8fd9\u662f Chatbox/DeepSeek \u7684\u5bf9\u8bdd\u5bfc\u51fa\uff0c\u800c\u4e0d\u662f\u8bbe\u7f6e\u5907\u4efd\u3002")
B.b2=new A.M("\u6587\u4ef6\u770b\u8d77\u6765\u662f JSON\uff0c\u4f46\u65e0\u6cd5\u89e3\u6790\uff1b\u539f\u59cb\u6587\u4ef6\u672a\u88ab\u4fee\u6539\u3002")
B.b3=new A.M("\u6587\u4ef6\u4e3a\u7a7a\u3002")
B.b4=new A.M("\u6587\u4ef6\u8bfb\u53d6\u5931\u8d25\uff0c\u8bf7\u91cd\u65b0\u9009\u62e9\u3002")
B.b5=new A.M("\u4f1a\u8bdd\u6ca1\u6709\u6d88\u606f\uff0c\u672a\u751f\u6210\u5f52\u6863\u3002")
B.b6=new A.M("\u6d88\u606f\u6b63\u6587\u5408\u8ba1\u8d85\u8fc7 32 MiB\uff0c\u672a\u751f\u6210\u5f52\u6863\u3002")
B.b7=new A.M("\u6ca1\u6709\u53ef\u5408\u5e76\u7684\u4e16\u754c\u3002")
B.b8=new A.M("\u5bf9\u8bdd\u6b63\u6587\u5305\u542b\u7591\u4f3c API Key\uff1b\u4e3a\u907f\u514d\u628a\u5bc6\u94a5\u5199\u8fdb\u5f52\u6863\uff0c\u8f6c\u6362\u5df2\u505c\u6b62\u3002\u8bf7\u5148\u79fb\u9664\u5bc6\u94a5\u3002")
B.b9=new A.bG(0)
B.ba=new A.bG(2e7)
B.bb=new A.ay("Invalid Huffman code length",null,null)
B.bc=new A.ay("Incomplete Huffman table",null,null)
B.bd=new A.ay("Oversubscribed Huffman table",null,null)
B.bi=new A.fn(null)
B.bj=new A.fo(null)
B.V=s([0,1,2,4],t.t)
B.M=s([0,512,768],t.t)
B.bl=s([1280,1344,1376],t.t)
B.bm=s([1,4,8],t.t)
B.bn=s([0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0],t.t)
B.bo=s([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,16,17,17,18,18,19,19,20,20,20,20,21,21,21,21,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24],t.t)
B.bp=s([0,1,2,3,4,5,6,7,8,10,12,14,16,20,24,28,32,40,48,56,64,80,96,112,128,160,192,224,0],t.t)
B.bq=s([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,3,7],t.t)
B.aa=s([35,31,52],t.t)
B.ab=s([4294967295,16777215,65535,255],t.t)
B.ac=s([43,11,5,1],t.t)
B.br=s([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,2,2,3,3,4,4,5,7,8,9,10,11,12,13,14,15,16],t.t)
B.ad=s([1,2,4,8,16,32,64,128,27,54,108,216,171,77,154,47,94,188,99,198,151,53,106,212,179,125,250,239,197,145],t.t)
B.ae=s([66,90,104],t.t)
B.af=s([0,1,2,2,3,3,3,3],t.t)
B.bs=s([6,5,6],t.t)
B.bt=s([8,9,10,10],t.t)
B.bu=s([0,1,2,3,4,6,8,12,16,24,32,48,64,96,128,192,256,384,512,768,1024,1536,2048,3072,4096,6144,8192,12288,16384,24576],t.t)
B.bv=s([9,8,9],t.t)
B.N=s([0,473195,504333,520860,55e4,7e5,75e4,83e4],t.t)
B.bw=s([0,1,2,3,4,4,5,5,6,6,6,6,7,7,7,7,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,16,17,18,18,19,19,20,20,20,20,21,21,21,21,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29],t.t)
B.bx=s([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,18,20,22,24,28,32,40,48,64,128,256,512,1024,2048,4096,8192,16384,32768,65536],t.t)
B.by=s(["\u5bfc\u5165\u5bf9\u8bdd"],t.s)
B.bz=s([0,0,0,0,0,0,0,0],t.t)
B.bA=s([0,1,2,3,4,5,6,7,8,8,9,9,10,10,11,11,12,12,12,12,13,13,13,13,14,14,14,14,15,15,15,15,16,16,16,16,16,16,16,16,17,17,17,17,17,17,17,17,18,18,18,18,18,18,18,18,19,19,19,19,19,19,19,19,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,28],t.t)
B.p=s([2781242211,2230877308,2582542199,2381740923,234877682,3184946027,2984144751,1418839493,1348481072,50462977,2848876391,2102799147,434634494,1656084439,3863849899,2599188086,1167051466,2636087938,1082771913,2281340285,368048890,3954334041,3381544775,201060592,3963727277,1739838676,4250903202,3930435503,3206782108,4149453988,2531553906,1536934080,3262494647,484572669,2923271059,1783375398,1517041206,1098792767,49674231,1334037708,1550332980,4098991525,886171109,150598129,2481090929,1940642008,1398944049,1059722517,201851908,1385547719,1699095331,1587397571,674240536,2704774806,252314885,3039795866,151914247,908333586,2602270848,1038082786,651029483,1766729511,3447698098,2682942837,454166793,2652734339,1951935532,775166490,758520603,3000790638,4004797018,4217086112,4137964114,1299594043,1639438038,3464344499,2068982057,1054729187,1901997871,2534638724,4121318227,1757008337,0,750906861,1614815264,535035132,3363418545,3988151131,3201591914,1183697867,3647454910,1265776953,3734260298,3566750796,3903871064,1250283471,1807470800,717615087,3847203498,384695291,3313910595,3617213773,1432761139,2484176261,3481945413,283769337,100925954,2180939647,4037038160,1148730428,3123027871,3813386408,4087501137,4267549603,3229630528,2315620239,2906624658,3156319645,1215313976,82966005,3747855548,3245848246,1974459098,1665278241,807407632,451280895,251524083,1841287890,1283575245,337120268,891687699,801369324,3787349855,2721421207,3431482436,959321879,1469301956,4065699751,2197585534,1199193405,2898814052,3887750493,724703513,2514908019,2696962144,2551808385,3516813135,2141445340,1715741218,2119445034,2872807568,2198571144,3398190662,700968686,3547052216,1009259540,2041044702,3803995742,487983883,1991105499,1004265696,1449407026,1316239930,504629770,3683797321,168560134,1816667172,3837287516,1570751170,1857934291,4014189740,2797888098,2822345105,2754712981,936633572,2347923833,852879335,1133234376,1500395319,3084545389,2348912013,1689376213,3533459022,3762923945,3034082412,4205598294,133428468,634383082,2949277029,2398386810,3913789102,403703816,3580869306,2297460856,1867130149,1918643758,607656988,4049053350,3346248884,1368901318,600565992,2090982877,2632479860,557719327,3717614411,3697393085,2249034635,2232388234,2430627952,1115438654,3295786421,2865522278,3633334344,84280067,33027830,303828494,2747425121,1600795957,4188952407,3496589753,2434238086,1486471617,658119965,3106381470,953803233,334231800,3005978776,857870609,3151128937,1890179545,2298973838,2805175444,3056442267,574365214,2450884487,550103529,1233637070,4289353045,2018519080,2057691103,2399374476,4166623649,2148108681,387583245,3664101311,836232934,3330556482,3100665960,3280093505,2955516313,2002398509,287182607,3413881008,4238890068,3597515707,975967766],t.t)
B.k=s([1116352408,1899447441,3049323471,3921009573,961987163,1508970993,2453635748,2870763221,3624381080,310598401,607225278,1426881987,1925078388,2162078206,2614888103,3248222580,3835390401,4022224774,264347078,604807628,770255983,1249150122,1555081692,1996064986,2554220882,2821834349,2952996808,3210313671,3336571891,3584528711,113926993,338241895,666307205,773529912,1294757372,1396182291,1695183700,1986661051,2177026350,2456956037,2730485921,2820302411,3259730800,3345764771,3516065817,3600352804,4094571909,275423344,430227734,506948616,659060556,883997877,958139571,1322822218,1537002063,1747873779,1955562222,2024104815,2227730452,2361852424,2428436474,2756734187,3204031479,3329325298],t.t)
B.W=s([0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13],t.t)
B.I=s([1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,65536,131072,262144,524288,1048576,2097152,4194304,8388608,16777216,33554432,67108864,134217728,268435456,536870912,1073741824,2147483648,4294967296],t.t)
B.ag=s([0,0,0,0,1,2,3,4,5,6,4,5],t.t)
B.bB=s([1,1,1,1,1,1,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,-1,-1,-1,-1,-1],t.t)
B.bC=s([12,8,140,8,76,8,204,8,44,8,172,8,108,8,236,8,28,8,156,8,92,8,220,8,60,8,188,8,124,8,252,8,2,8,130,8,66,8,194,8,34,8,162,8,98,8,226,8,18,8,146,8,82,8,210,8,50,8,178,8,114,8,242,8,10,8,138,8,74,8,202,8,42,8,170,8,106,8,234,8,26,8,154,8,90,8,218,8,58,8,186,8,122,8,250,8,6,8,134,8,70,8,198,8,38,8,166,8,102,8,230,8,22,8,150,8,86,8,214,8,54,8,182,8,118,8,246,8,14,8,142,8,78,8,206,8,46,8,174,8,110,8,238,8,30,8,158,8,94,8,222,8,62,8,190,8,126,8,254,8,1,8,129,8,65,8,193,8,33,8,161,8,97,8,225,8,17,8,145,8,81,8,209,8,49,8,177,8,113,8,241,8,9,8,137,8,73,8,201,8,41,8,169,8,105,8,233,8,25,8,153,8,89,8,217,8,57,8,185,8,121,8,249,8,5,8,133,8,69,8,197,8,37,8,165,8,101,8,229,8,21,8,149,8,85,8,213,8,53,8,181,8,117,8,245,8,13,8,141,8,77,8,205,8,45,8,173,8,109,8,237,8,29,8,157,8,93,8,221,8,61,8,189,8,125,8,253,8,19,9,275,9,147,9,403,9,83,9,339,9,211,9,467,9,51,9,307,9,179,9,435,9,115,9,371,9,243,9,499,9,11,9,267,9,139,9,395,9,75,9,331,9,203,9,459,9,43,9,299,9,171,9,427,9,107,9,363,9,235,9,491,9,27,9,283,9,155,9,411,9,91,9,347,9,219,9,475,9,59,9,315,9,187,9,443,9,123,9,379,9,251,9,507,9,7,9,263,9,135,9,391,9,71,9,327,9,199,9,455,9,39,9,295,9,167,9,423,9,103,9,359,9,231,9,487,9,23,9,279,9,151,9,407,9,87,9,343,9,215,9,471,9,55,9,311,9,183,9,439,9,119,9,375,9,247,9,503,9,15,9,271,9,143,9,399,9,79,9,335,9,207,9,463,9,47,9,303,9,175,9,431,9,111,9,367,9,239,9,495,9,31,9,287,9,159,9,415,9,95,9,351,9,223,9,479,9,63,9,319,9,191,9,447,9,127,9,383,9,255,9,511,9,0,7,64,7,32,7,96,7,16,7,80,7,48,7,112,7,8,7,72,7,40,7,104,7,24,7,88,7,56,7,120,7,4,7,68,7,36,7,100,7,20,7,84,7,52,7,116,7,3,8,131,8,67,8,195,8,35,8,163,8,99,8,227,8],t.t)
B.bD=s([0,5,16,5,8,5,24,5,4,5,20,5,12,5,28,5,2,5,18,5,10,5,26,5,6,5,22,5,14,5,30,5,1,5,17,5,9,5,25,5,5,5,21,5,13,5,29,5,3,5,19,5,11,5,27,5,7,5,23,5],t.t)
B.ah=s([0,1,2,2,3,4],t.t)
B.bE=s([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,32,33,33,34,34,35,35,36,36,36,36,37,37,37,37,38,38,38,38,38,38,38,38,39,39,39,39,39,39,39,39,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42,42],t.t)
B.o=s([0,79764919,159529838,222504665,319059676,398814059,445009330,507990021,638119352,583659535,797628118,726387553,890018660,835552979,1015980042,944750013,1276238704,1221641927,1167319070,1095957929,1595256236,1540665371,1452775106,1381403509,1780037320,1859660671,1671105958,1733955601,2031960084,2111593891,1889500026,1952343757,2552477408,2632100695,2443283854,2506133561,2334638140,2414271883,2191915858,2254759653,3190512472,3135915759,3081330742,3009969537,2905550212,2850959411,2762807018,2691435357,3560074640,3505614887,3719321342,3648080713,3342211916,3287746299,3467911202,3396681109,4063920168,4143685023,4223187782,4286162673,3779000052,3858754371,3904687514,3967668269,881225847,809987520,1023691545,969234094,662832811,591600412,771767749,717299826,311336399,374308984,453813921,533576470,25881363,88864420,134795389,214552010,2023205639,2086057648,1897238633,1976864222,1804852699,1867694188,1645340341,1724971778,1587496639,1516133128,1461550545,1406951526,1302016099,1230646740,1142491917,1087903418,2896545431,2825181984,2770861561,2716262478,3215044683,3143675388,3055782693,3001194130,2326604591,2389456536,2200899649,2280525302,2578013683,2640855108,2418763421,2498394922,3769900519,3832873040,3912640137,3992402750,4088425275,4151408268,4197601365,4277358050,3334271071,3263032808,3476998961,3422541446,3585640067,3514407732,3694837229,3640369242,1762451694,1842216281,1619975040,1682949687,2047383090,2127137669,1938468188,2001449195,1325665622,1271206113,1183200824,1111960463,1543535498,1489069629,1434599652,1363369299,622672798,568075817,748617968,677256519,907627842,853037301,1067152940,995781531,51762726,131386257,177728840,240578815,269590778,349224269,429104020,491947555,4046411278,4126034873,4172115296,4234965207,3794477266,3874110821,3953728444,4016571915,3609705398,3555108353,3735388376,3664026991,3290680682,3236090077,3449943556,3378572211,3174993278,3120533705,3032266256,2961025959,2923101090,2868635157,2813903052,2742672763,2604032198,2683796849,2461293480,2524268063,2284983834,2364738477,2175806836,2238787779,1569362073,1498123566,1409854455,1355396672,1317987909,1246755826,1192025387,1137557660,2072149281,2135122070,1912620623,1992383480,1753615357,1816598090,1627664531,1707420964,295390185,358241886,404320391,483945776,43990325,106832002,186451547,266083308,932423249,861060070,1041341759,986742920,613929101,542559546,756411363,701822548,3316196985,3244833742,3425377559,3370778784,3601682597,3530312978,3744426955,3689838204,3819031489,3881883254,3928223919,4007849240,4037393693,4100235434,4180117107,4259748804,2310601993,2373574846,2151335527,2231098320,2596047829,2659030626,2470359227,2550115596,2947551409,2876312838,2788305887,2733848168,3165939309,3094707162,3040238851,2985771188],t.t)
B.ai=s([0,1,2,3,3,4,5,5,5],t.t)
B.aj=s([23,114,69,56,80,144],t.t)
B.bF=s(["worldId","description","genreTags","emptyCharacters","emptyLocations","emptyWorldRules","emptyMemories","currentTime","startingLocation"],t.s)
B.a1=new A.aw(0,"litLit")
B.cH=new A.aw(1,"matchLitLit")
B.cI=new A.aw(2,"repLitLit")
B.cJ=new A.aw(3,"shortRepLitLit")
B.cK=new A.aw(4,"matchLit")
B.cL=new A.aw(5,"repLit")
B.cM=new A.aw(6,"shortRepLit")
B.az=new A.aw(7,"litMatch")
B.aA=new A.aw(8,"litLongRep")
B.aB=new A.aw(9,"litShortRep")
B.ay=new A.aw(10,"nonLitMatch")
B.a2=new A.aw(11,"nonLitRep")
B.ak=s([B.a1,B.cH,B.cI,B.cJ,B.cK,B.cL,B.cM,B.az,B.aA,B.aB,B.ay,B.a2],A.aW("u<aw>"))
B.q=s([1671808611,2089089148,2006576759,2072901243,4061003762,1807603307,1873927791,3310653893,810573872,16974337,1739181671,729634347,4263110654,3613570519,2883997099,1989864566,3393556426,2191335298,3376449993,2106063485,4195741690,1508618841,1204391495,4027317232,2917941677,3563566036,2734514082,2951366063,2629772188,2767672228,1922491506,3227229120,3082974647,4246528509,2477669779,644500518,911895606,1061256767,4144166391,3427763148,878471220,2784252325,3845444069,4043897329,1905517169,3631459288,827548209,356461077,67897348,3344078279,593839651,3277757891,405286936,2527147926,84871685,2595565466,118033927,305538066,2157648768,3795705826,3945188843,661212711,2999812018,1973414517,152769033,2208177539,745822252,439235610,455947803,1857215598,1525593178,2700827552,1391895634,994932283,3596728278,3016654259,695947817,3812548067,795958831,2224493444,1408607827,3513301457,0,3979133421,543178784,4229948412,2982705585,1542305371,1790891114,3410398667,3201918910,961245753,1256100938,1289001036,1491644504,3477767631,3496721360,4012557807,2867154858,4212583931,1137018435,1305975373,861234739,2241073541,1171229253,4178635257,33948674,2139225727,1357946960,1011120188,2679776671,2833468328,1374921297,2751356323,1086357568,2408187279,2460827538,2646352285,944271416,4110742005,3168756668,3066132406,3665145818,560153121,271589392,4279952895,4077846003,3530407890,3444343245,202643468,322250259,3962553324,1608629855,2543990167,1154254916,389623319,3294073796,2817676711,2122513534,1028094525,1689045092,1575467613,422261273,1939203699,1621147744,2174228865,1339137615,3699352540,577127458,712922154,2427141008,2290289544,1187679302,3995715566,3100863416,339486740,3732514782,1591917662,186455563,3681988059,3762019296,844522546,978220090,169743370,1239126601,101321734,611076132,1558493276,3260915650,3547250131,2901361580,1655096418,2443721105,2510565781,3828863972,2039214713,3878868455,3359869896,928607799,1840765549,2374762893,3580146133,1322425422,2850048425,1823791212,1459268694,4094161908,3928346602,1706019429,2056189050,2934523822,135794696,3134549946,2022240376,628050469,779246638,472135708,2800834470,3032970164,3327236038,3894660072,3715932637,1956440180,522272287,1272813131,3185336765,2340818315,2323976074,1888542832,1044544574,3049550261,1722469478,1222152264,50660867,4127324150,236067854,1638122081,895445557,1475980887,3117443513,2257655686,3243809217,489110045,2662934430,3778599393,4162055160,2561878936,288563729,1773916777,3648039385,2391345038,2493985684,2612407707,505560094,2274497927,3911240169,3460925390,1442818645,678973480,3749357023,2358182796,2717407649,2306869641,219617805,3218761151,3862026214,1120306242,1756942440,1103331905,2578459033,762796589,252780047,2966125488,1425844308,3151392187,372911126],t.t)
B.bG=s([3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,37,39,41,43,47,51,59,67,83,99,131,259,515,1027,2051,4099,8195,16387,32771,65539],t.t)
B.h=s([99,124,119,123,242,107,111,197,48,1,103,43,254,215,171,118,202,130,201,125,250,89,71,240,173,212,162,175,156,164,114,192,183,253,147,38,54,63,247,204,52,165,229,241,113,216,49,21,4,199,35,195,24,150,5,154,7,18,128,226,235,39,178,117,9,131,44,26,27,110,90,160,82,59,214,179,41,227,47,132,83,209,0,237,32,252,177,91,106,203,190,57,74,76,88,207,208,239,170,251,67,77,51,133,69,249,2,127,80,60,159,168,81,163,64,143,146,157,56,245,188,182,218,33,16,255,243,210,205,12,19,236,95,151,68,23,196,167,126,61,100,93,25,115,96,129,79,220,34,42,144,136,70,238,184,20,222,94,11,219,224,50,58,10,73,6,36,92,194,211,172,98,145,149,228,121,231,200,55,109,141,213,78,169,108,86,244,234,101,122,174,8,186,120,37,46,28,166,180,198,232,221,116,31,75,189,139,138,112,62,181,102,72,3,246,14,97,53,87,185,134,193,29,158,225,248,152,17,105,217,142,148,155,30,135,233,206,85,40,223,140,161,137,13,191,230,66,104,65,153,45,15,176,84,187,22],t.t)
B.al=s(["worlds","pending_imports","imported_conversations","imported_messages","imported_attachments","derived_import_results","roleplay_saves","roleplay_turns","roleplay_memories","world_definitions","story_checkpoints","story_branches","timeline_entries","context_summaries"],t.s)
B.bH=s([0,0,0,1,2,2,0,2,3],t.t)
B.i=s([3328402341,4168907908,4000806809,4135287693,4294111757,3597364157,3731845041,2445657428,1613770832,33620227,3462883241,1445669757,3892248089,3050821474,1303096294,3967186586,2412431941,528646813,2311702848,4202528135,4026202645,2992200171,2387036105,4226871307,1101901292,3017069671,1604494077,1169141738,597466303,1403299063,3832705686,2613100635,1974974402,3791519004,1033081774,1277568618,1815492186,2118074177,4126668546,2211236943,1748251740,1369810420,3521504564,4193382664,3799085459,2883115123,1647391059,706024767,134480908,2512897874,1176707941,2646852446,806885416,932615841,168101135,798661301,235341577,605164086,461406363,3756188221,3454790438,1311188841,2142417613,3933566367,302582043,495158174,1479289972,874125870,907746093,3698224818,3025820398,1537253627,2756858614,1983593293,3084310113,2108928974,1378429307,3722699582,1580150641,327451799,2790478837,3117535592,0,3253595436,1075847264,3825007647,2041688520,3059440621,3563743934,2378943302,1740553945,1916352843,2487896798,2555137236,2958579944,2244988746,3151024235,3320835882,1336584933,3992714006,2252555205,2588757463,1714631509,293963156,2319795663,3925473552,67240454,4269768577,2689618160,2017213508,631218106,1269344483,2723238387,1571005438,2151694528,93294474,1066570413,563977660,1882732616,4059428100,1673313503,2008463041,2950355573,1109467491,537923632,3858759450,4260623118,3218264685,2177748300,403442708,638784309,3287084079,3193921505,899127202,2286175436,773265209,2479146071,1437050866,4236148354,2050833735,3362022572,3126681063,840505643,3866325909,3227541664,427917720,2655997905,2749160575,1143087718,1412049534,999329963,193497219,2353415882,3354324521,1807268051,672404540,2816401017,3160301282,369822493,2916866934,3688947771,1681011286,1949973070,336202270,2454276571,201721354,1210328172,3093060836,2680341085,3184776046,1135389935,3294782118,965841320,831886756,3554993207,4068047243,3588745010,2345191491,1849112409,3664604599,26054028,2983581028,2622377682,1235855840,3630984372,2891339514,4092916743,3488279077,3395642799,4101667470,1202630377,268961816,1874508501,4034427016,1243948399,1546530418,941366308,1470539505,1941222599,2546386513,3421038627,2715671932,3899946140,1042226977,2521517021,1639824860,227249030,260737669,3765465232,2084453954,1907733956,3429263018,2420656344,100860677,4160157185,470683154,3261161891,1781871967,2924959737,1773779408,394692241,2579611992,974986535,664706745,3655459128,3958962195,731420851,571543859,3530123707,2849626480,126783113,865375399,765172662,1008606754,361203602,3387549984,2278477385,2857719295,1344809080,2782912378,59542671,1503764984,160008576,437062935,1707065306,3622233649,2218934982,3496503480,2185314755,697932208,1512910199,504303377,2075177163,2824099068,1841019862,739644986],t.t)
B.x=s([619,720,127,481,931,816,813,233,566,247,985,724,205,454,863,491,741,242,949,214,733,859,335,708,621,574,73,654,730,472,419,436,278,496,867,210,399,680,480,51,878,465,811,169,869,675,611,697,867,561,862,687,507,283,482,129,807,591,733,623,150,238,59,379,684,877,625,169,643,105,170,607,520,932,727,476,693,425,174,647,73,122,335,530,442,853,695,249,445,515,909,545,703,919,874,474,882,500,594,612,641,801,220,162,819,984,589,513,495,799,161,604,958,533,221,400,386,867,600,782,382,596,414,171,516,375,682,485,911,276,98,553,163,354,666,933,424,341,533,870,227,730,475,186,263,647,537,686,600,224,469,68,770,919,190,373,294,822,808,206,184,943,795,384,383,461,404,758,839,887,715,67,618,276,204,918,873,777,604,560,951,160,578,722,79,804,96,409,713,940,652,934,970,447,318,353,859,672,112,785,645,863,803,350,139,93,354,99,820,908,609,772,154,274,580,184,79,626,630,742,653,282,762,623,680,81,927,626,789,125,411,521,938,300,821,78,343,175,128,250,170,774,972,275,999,639,495,78,352,126,857,956,358,619,580,124,737,594,701,612,669,112,134,694,363,992,809,743,168,974,944,375,748,52,600,747,642,182,862,81,344,805,988,739,511,655,814,334,249,515,897,955,664,981,649,113,974,459,893,228,433,837,553,268,926,240,102,654,459,51,686,754,806,760,493,403,415,394,687,700,946,670,656,610,738,392,760,799,887,653,978,321,576,617,626,502,894,679,243,440,680,879,194,572,640,724,926,56,204,700,707,151,457,449,797,195,791,558,945,679,297,59,87,824,713,663,412,693,342,606,134,108,571,364,631,212,174,643,304,329,343,97,430,751,497,314,983,374,822,928,140,206,73,263,980,736,876,478,430,305,170,514,364,692,829,82,855,953,676,246,369,970,294,750,807,827,150,790,288,923,804,378,215,828,592,281,565,555,710,82,896,831,547,261,524,462,293,465,502,56,661,821,976,991,658,869,905,758,745,193,768,550,608,933,378,286,215,979,792,961,61,688,793,644,986,403,106,366,905,644,372,567,466,434,645,210,389,550,919,135,780,773,635,389,707,100,626,958,165,504,920,176,193,713,857,265,203,50,668,108,645,990,626,197,510,357,358,850,858,364,936,638],t.t)
B.X=s([1,4,13,40,121,364,1093,3280,9841,29524,88573,265720,797161,2391484],t.t)
B.bJ=s([0,2048,1792,1642,1536,1453,1386,1329,1280,1236,1197,1162,1130,1100,1073,1047,1024,1001,980,960,941,923,906,889,874,859,844,830,817,804,791,779,768,756,745,734,724,714,704,694,685,676,667,658,650,642,633,626,618,610,603,595,588,581,574,567,561,554,548,542,535,529,523,517,512,506,500,495,489,484,478,473,468,463,458,453,448,443,438,434,429,424,420,415,411,407,402,398,394,390,386,382,377,373,370,366,362,358,354,350,347,343,339,336,332,329,325,322,318,315,311,308,305,302,298,295,292,289,286,282,279,276,273,270,267,264,261,258,256,253,250,247,244,241,239,236,233,230,228,225,222,220,217,215,212,209,207,204,202,199,197,194,192,190,187,185,182,180,178,175,173,171,168,166,164,162,159,157,155,153,151,149,146,144,142,140,138,136,134,132,130,128,126,123,121,119,117,115,114,112,110,108,106,104,102,100,98,96,94,93,91,89,87,85,83,82,80,78,76,74,73,71,69,67,66,64,62,61,59,57,55,54,52,50,49,47,46,44,42,41,39,37,36,34,33,31,30,28,26,25,23,22,20,19,17,16,14,13,11,10,8,7,5,4,2,1],t.t)
B.bK=s(["attachments","files","images","links"],t.s)
B.am=s([0,0,0,0,0,3137339392,3214606336,3215287040,3081069667],t.t)
B.bL=s([1779033703,3144134277,1013904242,2773480762,1359893119,2600822924,528734635,1541459225],t.t)
B.O=s([4122539820,1601664860,2224250662,1803207698,3058150825,3396537548,2959457099,290435550,878202494,2352652240,1318576508,1793223429,973330243,3164186116,3469542436,583271503,1994290885,2233738654,2625972470,1538124490,2253797126,3792270633,688015199,2742409353,2947754647,967175142,3458667738,948168249,35565442,388163230,228194,2250290728,77237573,1569245941,2237060881,3868557632,83340916,4234173471,2191461428,1757231648,1342032005,3324319646,2222185988,2319298331,1358989346,2958444210,1775721746,3000093791,2359118361,361845948,3284930804,2881306627,3496860700,3971576721,3192448743,3984601134,880925489,3470800199,2898523772,3668038160,1707833117,2357171916,2394059127,89596893,3347682573,1154323646,2471488220,922792235,1581801233,3988648322,506341958,4251219578,694798961,3626957436,2638670227,1589361198,3763779198,98992683,2497134421,1939669920,3446673597,3063634435,1163852284,3617293044,2258416970,2269757793,953263354,1636160037,3027572335,2495343035,2752787784,1913215473,2062370688,3127584442,3503171140,970990354,2218159476,1618531592,2832111420,1928140734,566436770,2588084993,2573391383,3819929838,2869750045,2626484059,1393463014,3516550588,787909644,4114570610,3225053206,1084773638,1231965855,2620459367,2019034226,3046839456,657990850,993559927,1723830842,3562845523,1202592346,613595782,904070230,2653066841,1197807658,1183255407,1824175653,3909719058,3719076398,1501897409,1903298670,1717970162,3746563018,1346074679,2294333915,2018917641,1490360421,2902206621,393638318,3327272177,4219066530,1105815511,736223489,3403261082,1713727535,1848186987,966087493,2059431504,56491956,3258628980,1117631065,525642462,3307733672,58527753,1791698744,520824307,4099810641,3998188091,2332992217,2508243703,1005408668,3165970913,267670146,1035665674,2638409057,1329451623,1536365504,1649919355,2702489600,2338198594,3254661404,297876811,1726510654,2739688808,2342005489,3261263965,4001920762,2859858871,2321720528,3513957162,3242038435,3074726551,1841019549,3244098428,3347451935,496165105,3615916457,127973275,4128943913,1657383865,754783996,3553327833,2257345383,1147292961,635850889,2624904663,3120835316,2814604387,1320265017,1180319434,3188317168,990238154,2001623606,726954682,1201742354,701596621,1347095713,2398462687,3757825981,3796201145,1187851055,3202565684,4071553278,2174589123,897536630,3562642785,614811704,2042909667,142616200,2442310841,685413991,394451948,1324579904,1485740714,2285353222,1371316147,3244619585,3555780054,3155384842,1883992250,110942312,4150405850,3157768841,3770269867,1203849729,842355446,1325431115,2901317819,1896341117,1668966869,2293201211,3069322590,4089857643,2274997656,3263743510,2860464985,2177524687,1123853309,2295880398,916612939,218459091,2032372199,3848026476,1318966061,3204141125,1910948006,2527801873,1586620620,3213544216,3733928145,1725621640,23537158,2201706519,2267224059,3095140082,3519621220,3681970804,3851118236,2305138565,3323205566,3369774469,1611786764,1990505829,3070131886,2758398085,4129518354,2867869270,2208557420,1304130671,2217015224,104363354,4108627137,1031276533,3185984646,398355855,1539012153,151253197,1155282396,1740010218,4260436332,2792816531,3981214449,1377636356,3305455005,934976208,2630652418,2229620009,2058156881,168512375,1779708997,136369265,3792385166,410269756,3091023580,2548952775,2716852508,3006326027,467419818,500767061,3463503922,2769604024,2401843669,663823167,3641555411,2070350412,3306125979,2009103658,96919461,3816262502,1188079354,3013381850,1203070793,2470368328,2916871976,2944690934,2877098996,240841224,3949358665,1583751927,892652906,696102602,1122982766,2251140851,3545577894,3867615817,2408455849,2551993097,1036047730,4194939071,3213294581,816965985,1713479445,1894241382,3183803267,1516663662,905095401,3453704658,3082926831,3603419719,3530394006,3930995178,3369999267,1402768305,2678304754,167317068,1607796952,2739820886,4222563205,774868501,490664821,389452265,3091181249,3092942166,3204539257,2206349330,1732283107,3104804891,3183479149,2087375657,868019301,1991990831,747296149,957318426,1827958056,3286632013,2713901682,3307867152,486167433,3616452484,2751186224,931248610,680237438,1942157022,2822571460,69373494,1281056471,2642034399,228866321,2396847834,610821974,1584818087,3081352097,1280260255,2705553693,2961948930,1034407388,2058665530,3844714956,1968070962,3689369593,1902335042,2822364997,795849060,1069437662,2518551106,3480912247,4088683907,3634295530,3997033679,1248738971,3446163540,741512679,3838763366,1282958895,2571588747,1196189892,634861431,2783808267,13178289,3593910268,566409845,3652244186,1600871887,1619682465,3706925861,1610176268,1664848420,416208110,3241598432,2953098058,1489798064,1565208410,1588864221,2727232210,1658799926,2537147800,3034625060,2246364695,383905985,4188590567,2395181415,123080383,1656385069,4073495987,3422156031,2010659350,2027542480,2100018372,4015344865,3760996852,2373288210,2127362381,2847224630,3409742341,952380427,4099690385,1678283725,4098394211,2162963644,1465820520,972236021,3029248576,3923373343,2399097471,2451897349,2361762324,3132752048,1291745089,815439634,265245359,2774070252,1700946450,1112272011,2061155887,1096951059,2796463155,3096290005,843884440,3532092219,609560740,2588174718,1835577027,2064683966,793361192,1354493027,775785133,1826162467,3790242435,2306580084,833629171,564067787,864710727,990056944,2726037078,3675766673,3235616487,2362768747,1317381554,4205867269,1269186717,1087831683,531226585,2939522539,2910681374,3951889957,2791194200,3150697439,350258560,217534962,2127407915,726507855,638834932],t.t)
B.bN=s([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,2,2,3,3,4,6,7,8,9,10,11,12,13,14,15,16],t.t)
B.F=s([],A.aW("u<V<l,@>>"))
B.P=s([],t.s)
B.cN=s([],t.t)
B.an=s([],t.o)
B.bO=s([5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5],t.t)
B.bP=s(["id","messageId","message_id","uuid"],t.s)
B.bQ=s(["id","sessionId","uuid"],t.s)
B.v=s([0,1996959894,3993919788,2567524794,124634137,1886057615,3915621685,2657392035,249268274,2044508324,3772115230,2547177864,162941995,2125561021,3887607047,2428444049,498536548,1789927666,4089016648,2227061214,450548861,1843258603,4107580753,2211677639,325883990,1684777152,4251122042,2321926636,335633487,1661365465,4195302755,2366115317,997073096,1281953886,3579855332,2724688242,1006888145,1258607687,3524101629,2768942443,901097722,1119000684,3686517206,2898065728,853044451,1172266101,3705015759,2882616665,651767980,1373503546,3369554304,3218104598,565507253,1454621731,3485111705,3099436303,671266974,1594198024,3322730930,2970347812,795835527,1483230225,3244367275,3060149565,1994146192,31158534,2563907772,4023717930,1907459465,112637215,2680153253,3904427059,2013776290,251722036,2517215374,3775830040,2137656763,141376813,2439277719,3865271297,1802195444,476864866,2238001368,4066508878,1812370925,453092731,2181625025,4111451223,1706088902,314042704,2344532202,4240017532,1658658271,366619977,2362670323,4224994405,1303535960,984961486,2747007092,3569037538,1256170817,1037604311,2765210733,3554079995,1131014506,879679996,2909243462,3663771856,1141124467,855842277,2852801631,3708648649,1342533948,654459306,3188396048,3373015174,1466479909,544179635,3110523913,3462522015,1591671054,702138776,2966460450,3352799412,1504918807,783551873,3082640443,3233442989,3988292384,2596254646,62317068,1957810842,3939845945,2647816111,81470997,1943803523,3814918930,2489596804,225274430,2053790376,3826175755,2466906013,167816743,2097651377,4027552580,2265490386,503444072,1762050814,4150417245,2154129355,426522225,1852507879,4275313526,2312317920,282753626,1742555852,4189708143,2394877945,397917763,1622183637,3604390888,2714866558,953729732,1340076626,3518719985,2797360999,1068828381,1219638859,3624741850,2936675148,906185462,1090812512,3747672003,2825379669,829329135,1181335161,3412177804,3160834842,628085408,1382605366,3423369109,3138078467,570562233,1426400815,3317316542,2998733608,733239954,1555261956,3268935591,3050360625,752459403,1541320221,2607071920,3965973030,1969922972,40735498,2617837225,3943577151,1913087877,83908371,2512341634,3803740692,2075208622,213261112,2463272603,3855990285,2094854071,198958881,2262029012,4057260610,1759359992,534414190,2176718541,4139329115,1873836001,414664567,2282248934,4279200368,1711684554,285281116,2405801727,4167216745,1634467795,376229701,2685067896,3608007406,1308918612,956543938,2808555105,3495958263,1231636301,1047427035,2932959818,3654703836,1088359270,936918e3,2847714899,3736837829,1202900863,817233897,3183342108,3401237130,1404277552,615818150,3134207493,3453421203,1423857449,601450431,3009837614,3294710456,1567103746,711928724,3020668471,3272380065,1510334235,755167117],t.t)
B.bk=s([19,12,13,1,6,1,0,19,13,14,1,7,0,0,20,15,16,1,6,0,0,21,16,17,1,5,0,1,21,18,18,1,5,0,1,21,18,19,3,5,64,2,21,18,19,3,5,64,3,21,19,20,4,5,96,3,21,19,20,4,5,128,4,22,20,21,4,5,128,4,22,21,22,5,5,192,4,22,21,22,6,5,256,4,22,22,23,6,5,512,4,22,22,22,4,5,32,5,22,22,23,5,5,32,5,22,23,23,6,5,32,5,22,22,22,5,5,48,6,23,23,22,5,4,64,6,23,23,22,6,3,64,7,23,24,22,7,3,256,8,25,25,23,7,3,256,8,26,26,24,7,3,512,8,27,27,25,9,3,999,8],t.t)
B.bI=s([18,12,13,1,5,1,0,18,13,14,1,6,0,0,18,14,14,1,5,0,1,18,16,16,1,4,0,1,18,16,17,3,5,64,2,18,17,18,5,5,64,2,18,18,19,3,5,64,3,18,18,19,4,4,96,3,18,18,19,4,4,128,4,18,18,19,5,4,128,4,18,18,19,6,4,192,4,18,18,19,5,4,12,5,18,19,19,7,4,12,5,18,18,19,4,4,16,6,18,18,19,4,3,32,6,18,18,19,6,3,128,6,18,19,19,6,3,128,7,18,19,19,8,3,256,7,18,19,19,6,3,128,8,18,19,19,8,3,256,8,18,19,19,10,3,512,8,18,19,19,12,3,512,8,18,19,19,13,3,999,8],t.t)
B.bM=s([17,12,12,1,5,1,0,17,12,13,1,6,0,0,17,13,15,1,5,0,0,17,15,16,2,5,0,1,17,17,17,2,4,0,1,17,16,17,3,4,64,2,17,16,17,3,4,64,3,17,16,17,3,4,96,4,17,16,17,4,4,128,4,17,16,17,5,4,128,4,17,16,17,6,4,192,4,17,17,17,5,4,8,5,17,18,17,7,4,12,5,17,18,17,3,4,12,6,17,18,17,4,3,32,6,17,18,17,6,3,256,6,17,18,17,6,3,128,7,17,18,17,8,3,256,7,17,18,17,10,3,512,7,17,18,17,5,3,256,8,17,18,17,7,3,512,8,17,18,17,9,3,512,8,17,18,17,11,3,999,8],t.t)
B.c1=s([14,12,13,1,5,1,0,14,14,15,1,5,0,0,14,14,15,1,4,0,0,14,14,15,2,4,0,1,14,14,14,4,4,64,2,14,14,14,3,4,64,3,14,14,14,4,4,64,4,14,14,14,6,4,96,4,14,14,14,8,4,128,4,14,15,14,5,4,8,5,14,15,14,9,4,8,5,14,15,14,3,4,12,6,14,15,14,4,3,24,6,14,15,14,5,3,32,7,14,15,15,6,3,64,7,14,15,15,7,3,256,7,14,15,15,5,3,48,8,14,15,15,6,3,128,8,14,15,15,7,3,256,8,14,15,15,8,3,256,8,14,15,15,8,3,512,8,14,15,15,9,3,512,8,14,15,15,10,3,999,8],t.t)
B.bR=s([B.bk,B.bI,B.bM,B.c1],A.aW("u<k<e>>"))
B.bS=s([1732584193,4023233417,2562383102,271733878,3285377520],t.t)
B.Q=s([0,1,3,7,15,31,63,127,255],t.t)
B.ao=s([16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15],t.t)
B.bT=s([4,3,2,2,2,2,2,2,2,2,2,2,2,1,1,1,2,2,2,2,2,2,2,2,2,3,2,1,1,1,1,1,-1,-1,-1,-1],t.t)
B.bU=s([1,4,3,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,-1,-1,-1,-1,-1,-1,-1],t.t)
B.ap=s(["model"],t.s)
B.r=s([1667474886,2088535288,2004326894,2071694838,4075949567,1802223062,1869591006,3318043793,808472672,16843522,1734846926,724270422,4278065639,3621216949,2880169549,1987484396,3402253711,2189597983,3385409673,2105378810,4210693615,1499065266,1195886990,4042263547,2913856577,3570689971,2728590687,2947541573,2627518243,2762274643,1920112356,3233831835,3082273397,4261223649,2475929149,640051788,909531756,1061110142,4160160501,3435941763,875846760,2779116625,3857003729,4059105529,1903268834,3638064043,825316194,353713962,67374088,3351728789,589522246,3284360861,404236336,2526454071,84217610,2593830191,117901582,303183396,2155911963,3806477791,3958056653,656894286,2998062463,1970642922,151591698,2206440989,741110872,437923380,454765878,1852748508,1515908788,2694904667,1381168804,993742198,3604373943,3014905469,690584402,3823320797,791638366,2223281939,1398011302,3520161977,0,3991743681,538992704,4244381667,2981218425,1532751286,1785380564,3419096717,3200178535,960056178,1246420628,1280103576,1482221744,3486468741,3503319995,4025428677,2863326543,4227536621,1128514950,1296947098,859002214,2240123921,1162203018,4193849577,33687044,2139062782,1347481760,1010582648,2678045221,2829640523,1364325282,2745433693,1077985408,2408548869,2459086143,2644360225,943212656,4126475505,3166494563,3065430391,3671750063,555836226,269496352,4294908645,4092792573,3537006015,3452783745,202118168,320025894,3974901699,1600119230,2543297077,1145359496,387397934,3301201811,2812801621,2122220284,1027426170,1684319432,1566435258,421079858,1936954854,1616945344,2172753945,1330631070,3705438115,572679748,707427924,2425400123,2290647819,1179044492,4008585671,3099120491,336870440,3739122087,1583276732,185277718,3688593069,3772791771,842159716,976899700,168435220,1229577106,101059084,606366792,1549591736,3267517855,3553849021,2897014595,1650632388,2442242105,2509612081,3840161747,2038008818,3890688725,3368567691,926374254,1835907034,2374863873,3587531953,1313788572,2846482505,1819063512,1448540844,4109633523,3941213647,1701162954,2054852340,2930698567,134748176,3132806511,2021165296,623210314,774795868,471606328,2795958615,3031746419,3334885783,3907527627,3722280097,1953799400,522133822,1263263126,3183336545,2341176845,2324333839,1886425312,1044267644,3048588401,1718004428,1212733584,50529542,4143317495,235803164,1633788866,892690282,1465383342,3115962473,2256965911,3250673817,488449850,2661202215,3789633753,4177007595,2560144171,286339874,1768537042,3654906025,2391705863,2492770099,2610673197,505291324,2273808917,3924369609,3469625735,1431699370,673740880,3755965093,2358021891,2711746649,2307489801,218961690,3217021541,3873845719,1111672452,1751693520,1094828930,2576986153,757954394,252645662,2964376443,1414855848,3149649517,370555436],t.t)
B.aq=s([3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258],t.t)
B.bV=s(["timestamp","createdAt","created_at","time"],t.s)
B.bW=s([1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577],t.t)
B.bX=s(["parentId","parent_id","parent"],t.s)
B.bY=s(["role","author","from","sender"],t.s)
B.ar=s(["text","input_text","output_text"],t.s)
B.bZ=s(["title","name","topic","subject"],t.s)
B.c_=s([6,2,1,1,2,3,4,4,4,3,2],t.t)
B.c0=s([0,2,4,8,12,20,28,44,60,92],t.t)
B.c2=s([8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8],t.t)
B.c3=s(["createdAt","created_at","timestamp","updatedAt","updated_at"],t.s)
B.c4=s([1,0,16,0,0,0,0,0,0,0,0,0],t.t)
B.as=s([0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0,0,0],t.t)
B.at=s([49,65,89,38,83,89],t.t)
B.c5=s(["sessions","chats","conversations","data","backup","items","chat","session"],t.s)
B.c6=new A.c4([16,10,24,12,32,14],A.aW("c4<e,e>"))
B.Y=new A.c4([0,B.l,8,B.u,12,B.H,14,B.D,93,B.z,95,B.E],A.aW("c4<e,be>"))
B.cb={user:0,human:1,you:2,me:3,"\u7528\u6237":4,"\u73a9\u5bb6":5,"\u6211":6,assistant:7,ai:8,bot:9,model:10,chatgpt:11,deepseek:12,"\u52a9\u624b":13,"\u6a21\u578b":14,"\u7cfb\u7edf":15,system:16,developer:17,tool:18,function:19,"\u5de5\u5177":20}
B.c7=new A.dn(B.cb,["user","user","user","user","user","user","user","assistant","assistant","assistant","assistant","assistant","assistant","assistant","assistant","system","system","system","tool","tool","tool"],A.aW("dn<l,l>"))
B.cc=new A.bw(0,0)
B.cd=new A.bw(1,1)
B.av=new A.bw(3,0)
B.c9={authorization:0,apikey:1,api_key:2,access_token:3,refresh_token:4,cookie:5,password:6,bearer:7}
B.ce=new A.cC(B.c9,8,t.R)
B.ca={"CRC32 check failed":0,"CRC64 check failed":1,"SHA-256 check failed":2,"Block check failed":3}
B.cf=new A.cC(B.ca,4,t.R)
B.cg=A.aX("c_")
B.ch=A.aX("dj")
B.ci=A.aX("mb")
B.cj=A.aX("r7")
B.ck=A.aX("r8")
B.cl=A.aX("ff")
B.cm=A.aX("fg")
B.cn=A.aX("rb")
B.co=A.aX("m")
B.cp=A.aX("mz")
B.cq=A.aX("e1")
B.cr=A.aX("rC")
B.cs=A.aX("bh")
B.aw=new A.fF(!1)
B.ct=new A.iS(2,"crc64")
B.cu=new A.aA("\u5f52\u6863\u8bb0\u5f55\u635f\u574f\u6216\u4e0d\u5b8c\u6574\u3002")
B.cv=new A.aA("\u4e16\u754c\u5f52\u6863\u8d85\u8fc7\u5355\u6761\u8bb0\u5f55\u6216\u8bb0\u5f55\u6570\u9650\u5236\u3002")
B.cw=new A.aA("\u5f52\u6863\u5bc6\u7801\u9519\u8bef\u6216\u52a0\u5bc6\u6587\u4ef6\u635f\u574f\u3002")
B.cx=new A.aA("\u6682\u4e0d\u652f\u6301\u8fd9\u4e2a\u5f52\u6863\u7248\u672c\uff0c\u8bf7\u66f4\u65b0\u9c7c\u8005\u3002")
B.cy=new A.aA("\u8bf7\u8f93\u5165\u5f52\u6863\u5bc6\u7801\u3002")
B.cz=new A.aA("\u5f52\u6863\u6587\u4ef6\u4e0d\u5b8c\u6574\u3002")
B.cA=new A.aA("\u5f52\u6863\u5b8c\u6574\u6027\u6821\u9a8c\u5931\u8d25\u3002")
B.cB=new A.aA("\u5f52\u6863\u8d85\u8fc7\u8bb0\u5f55\u6570\u9650\u5236\u6216\u7f3a\u5c11\u5b8c\u6574\u6027\u6821\u9a8c\u3002")
B.cC=new A.aA("\u5f52\u6863\u8bb0\u5f55\u7ed3\u6784\u65e0\u6548\u3002")
B.cD=new A.aA("\u8fd9\u4e0d\u662f\u9c7c\u8005\u5f52\u6863\u3002")
B.ax=new A.aA("\u4e16\u754c\u5f52\u6863\u8d85\u8fc7 64 MiB\u3002")
B.cE=new A.aA("\u5f52\u6863\u683c\u5f0f\u635f\u574f\u3002")
B.A=new A.e7(0,"none")
B.a_=new A.e7(1,"zipCrypto")
B.a0=new A.e7(2,"aes")
B.R=new A.cX(0,"none")
B.cF=new A.cX(1,"partial")
B.cG=new A.cX(2,"full")
B.L=new A.cX(3,"finish")
B.S=new A.hc("")})();(function staticFields(){$.kt=null
$.aN=A.i([],t.J)
$.of=null
$.nN=null
$.nM=null
$.pC=null
$.pu=null
$.pH=null
$.lv=null
$.lE=null
$.na=null
$.kB=A.i([],A.aW("u<k<m>?>"))
$.d4=null
$.eK=null
$.eL=null
$.mY=!1
$.w=B.n
$.bF=A.mH()
$.pq=null
$.mO=null
$.n1=null
$.l6=0
$.bA=A.o8(t.S)
$.eH=!1
$.mS=null
$.mU=null
$.mT=null})();(function lazyInitializers(){var s=hunkHelpers.lazyFinal,r=hunkHelpers.lazy
s($,"wd","pW",()=>A.lx("_$dart_dartClosure"))
s($,"wc","no",()=>A.lx("_$dart_dartClosure_dartJSInterop"))
s($,"wF","qd",()=>A.mp(0))
s($,"x5","qq",()=>B.n.cq(B.n,A.aW("am<~>()").a(new A.lV()),A.aW("am<~>")))
s($,"wZ","qn",()=>A.i([new J.fi()],A.aW("u<dX>")))
s($,"wr","q2",()=>A.bt(A.iQ({
toString:function(){return"$receiver$"}})))
s($,"ws","q3",()=>A.bt(A.iQ({$method$:null,
toString:function(){return"$receiver$"}})))
s($,"wt","q4",()=>A.bt(A.iQ(null)))
s($,"wu","q5",()=>A.bt(function(){var $argumentsExpr$="$arguments$"
try{null.$method$($argumentsExpr$)}catch(q){return q.message}}()))
s($,"wx","q8",()=>A.bt(A.iQ(void 0)))
s($,"wy","q9",()=>A.bt(function(){var $argumentsExpr$="$arguments$"
try{(void 0).$method$($argumentsExpr$)}catch(q){return q.message}}()))
s($,"ww","q7",()=>A.bt(A.oo(null)))
s($,"wv","q6",()=>A.bt(function(){try{null.$method$}catch(q){return q.message}}()))
s($,"wA","qb",()=>A.bt(A.oo(void 0)))
s($,"wz","qa",()=>A.bt(function(){try{(void 0).$method$}catch(q){return q.message}}()))
s($,"wE","nr",()=>A.rV())
s($,"wh","eP",()=>$.qq())
s($,"wg","pY",()=>A.t0(!1,B.n,t.y))
s($,"wV","qm",()=>A.mp(4096))
s($,"wT","qk",()=>new A.kJ().$0())
s($,"wU","ql",()=>new A.kI().$0())
s($,"we","pX",()=>A.an("^([+-]?\\d{4,6})-?(\\d\\d)-?(\\d\\d)(?:[ T](\\d\\d)(?::?(\\d\\d)(?::?(\\d\\d)(?:[.,](\\d+))?)?)?( ?[zZ]| ?([-+])(\\d\\d)(?::?(\\d\\d))?)?)?$",!0))
s($,"wX","hp",()=>A.nd(B.co))
s($,"wl","np",()=>{var q=new A.h0(A.rj(8))
q.is()
return q})
s($,"wf","dc",()=>A.qS(B.j.gN(A.dQ(A.i([1],t.t))),0,null).getInt8(0)===1?B.B:B.J)
s($,"w8","nn",()=>A.mp(0))
s($,"w7","pS",()=>A.rn(0))
s($,"w6","nm",()=>A.rl(0))
s($,"wM","nu",()=>A.bf(B.bn))
s($,"wL","m_",()=>A.bf(B.W))
s($,"wK","qg",()=>A.bf(B.bq))
s($,"wJ","nt",()=>A.bf(B.ao))
s($,"wG","ns",()=>A.bf(B.bw))
s($,"wN","nv",()=>A.bf(B.bA))
s($,"wI","qf",()=>A.dQ(B.bp))
s($,"wH","qe",()=>A.dQ(B.bu))
s($,"wS","m0",()=>A.dQ(B.bC))
s($,"wQ","nw",()=>A.dQ(B.bD))
s($,"wR","qj",()=>A.mK($.m0(),$.nu(),257,286,15))
s($,"wP","qi",()=>A.mK($.nw(),$.m_(),0,30,15))
s($,"wO","qh",()=>A.mK(null,$.qg(),0,19,7))
s($,"wj","q_",()=>A.mh(B.c2,!1))
s($,"wi","pZ",()=>A.mh(B.bO,!1))
s($,"x7","m4",()=>A.ix(B.bm))
s($,"x8","qr",()=>A.ix(B.bx))
s($,"xa","hq",()=>A.bf(B.bN))
s($,"xb","qs",()=>A.ix(B.bG))
s($,"xd","eQ",()=>A.bf(B.br))
s($,"xe","qt",()=>{var q,p=A.i([],t.t)
for(q=0;q<=31;++q)p.push(B.a.q(1,q))
return A.ix(p)})
s($,"xf","qu",()=>{var q,p=A.i([],t.t)
for(q=0;q<=31;++q)p.push(q)
return A.bf(p)})
s($,"xj","nC",()=>A.i([$.qr(),$.qt(),$.qs()],A.aW("u<e1>")))
s($,"xk","nD",()=>A.i([$.hq(),$.qu(),$.eQ()],t.a))
s($,"x6","nz",()=>A.tB())
s($,"xg","m5",()=>A.mo(B.bT))
s($,"xh","m6",()=>A.mo(B.bU))
s($,"xi","m7",()=>A.mo(B.bB))
s($,"x9","nA",()=>A.bf(B.bo))
s($,"xc","nB",()=>A.bf(B.bE))
s($,"wY","ny",()=>A.dQ(B.bJ))
s($,"x1","m1",()=>A.oY(!0))
s($,"x2","m2",()=>A.oY(!1))
s($,"x_","qo",()=>A.oX(!0))
s($,"x0","qp",()=>A.oX(!1))
s($,"wB","ho",()=>A.te(0,0))
s($,"x4","m3",()=>A.pB(A.p8(A.pK(),"crypto"),"subtle",t.K)!=null&&A.rf(A.pB(A.p8(A.pK(),"window"),"isSecureContext",t.y)))
s($,"w9","pT",()=>A.qQ()?new A.i_(null):A.r0(null))
s($,"wb","pV",()=>$.pT())
r($,"wa","pU",()=>$.pV())
s($,"wo","q0",()=>$.q1())
s($,"wp","q1",()=>A.ru())
s($,"wW","nx",()=>A.an("(sk-[A-Za-z0-9_-]{20,}|Bearer\\s+[A-Za-z0-9_-]{16,})",!0))
s($,"wD","nq",()=>B.aC.lm("YUZHE"))
s($,"wC","qc",()=>$.pU().e5(12,32))})();(function nativeSupport(){!function(){var s=function(a){var m={}
m[a]=1
return Object.keys(hunkHelpers.convertToFastObject(m))[0]}
v.getIsolateTag=function(a){return s("___dart_"+a+v.isolateTag)}
var r="___dart_isolate_tags_"
var q=Object[r]||(Object[r]=Object.create(null))
var p="_ZxYxX"
for(var o=0;;o++){var n=s(p+"_"+o+"_")
if(!(n in q)){q[n]=1
v.isolateTag=n
break}}v.dispatchPropertyName=v.getIsolateTag("dispatch_record")}()
hunkHelpers.setOrUpdateInterceptorsByTag({SharedArrayBuffer:A.bK,ArrayBuffer:A.cL,ArrayBufferView:A.dO,DataView:A.dM,Float32Array:A.fq,Float64Array:A.fr,Int16Array:A.fs,Int32Array:A.dN,Int8Array:A.ft,Uint16Array:A.dP,Uint32Array:A.dR,Uint8ClampedArray:A.dS,CanvasPixelArray:A.dS,Uint8Array:A.c9})
hunkHelpers.setOrUpdateLeafTags({SharedArrayBuffer:true,ArrayBuffer:true,ArrayBufferView:false,DataView:true,Float32Array:true,Float64Array:true,Int16Array:true,Int32Array:true,Int8Array:true,Uint16Array:true,Uint32Array:true,Uint8ClampedArray:true,CanvasPixelArray:true,Uint8Array:false})
A.ad.$nativeSuperclassTag="ArrayBufferView"
A.er.$nativeSuperclassTag="ArrayBufferView"
A.es.$nativeSuperclassTag="ArrayBufferView"
A.bL.$nativeSuperclassTag="ArrayBufferView"
A.et.$nativeSuperclassTag="ArrayBufferView"
A.eu.$nativeSuperclassTag="ArrayBufferView"
A.aH.$nativeSuperclassTag="ArrayBufferView"})()
Function.prototype.$1=function(a){return this(a)}
Function.prototype.$2=function(a,b){return this(a,b)}
Function.prototype.$0=function(){return this()}
Function.prototype.$3=function(a,b,c){return this(a,b,c)}
Function.prototype.$4=function(a,b,c,d){return this(a,b,c,d)}
Function.prototype.$5=function(a,b,c,d,e){return this(a,b,c,d,e)}
Function.prototype.$6=function(a,b,c,d,e,f){return this(a,b,c,d,e,f)}
Function.prototype.$1$1=function(a){return this(a)}
Function.prototype.$2$0=function(){return this()}
convertAllToFastObject(w)
convertToFastObject($);(function(a){if(typeof document==="undefined"){a(null)
return}if(typeof document.currentScript!="undefined"){a(document.currentScript)
return}var s=document.scripts
function onLoad(b){for(var q=0;q<s.length;++q){s[q].removeEventListener("load",onLoad,false)}a(b.target)}for(var r=0;r<s.length;++r){s[r].addEventListener("load",onLoad,false)}})(function(a){v.currentScript=a
var s=A.vL
if(typeof dartMainRunner==="function"){dartMainRunner(s,[])}else{s([])}})})()