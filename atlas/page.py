"""The atlas page: `render(D)` turns the model's data into one HTML file.

Inline CSS and JS, no network, no external font. The colour tokens sit on
`:root` and are redefined for dark mode; the canvas reads them at every
paint, so a change of scheme repaints in place. The data rides in a
`<script type="application/json">` block with `<`, `>`, `&`, U+2028 and
U+2029 escaped, keys sorted, so the same data gives the same bytes.

ZOOM LEVELS, by scale: far (below 0.55) panels, the strip and the points;
middle names of roots and of the selected declaration's neighbours; near
(from 1.6) every name, and arrows on the roads.
"""

import html
import json


def _e(t):
    return html.escape(str(t), quote=True)


def _json_script(data):
    text = json.dumps(data, sort_keys=True, ensure_ascii=False, separators=(",", ":"))
    return (text.replace("&", "\\u0026").replace("<", "\\u003c").replace(">", "\\u003e")
            .replace("\u2028", "\\u2028").replace("\u2029", "\\u2029"))


CSS = r"""
:root{--bg:#fbfaf7;--card:#ffffff;--fg:#1d1d1f;--muted:#6b6b70;--line:#dedcd6;
--c0:#d6333a;--c5:#d9951a;--c1:#2f9e55;--pt:#5b5b62;--road:#8a7a5c;--up:#3b7dd8;
--down:#c93a78;--root:#1d1d1f;--crit:#c93a78;--stripfill:#3b7dd8;--strip-a:.07;
--unit:#8a5cc7;--comm:#1f8f84;--sel:#1d1d1f;--lane:#f3f1ec}
@media (prefers-color-scheme: dark){:root:not([data-theme="light"]){--bg:#141416;--card:#1c1c1f;
--fg:#ececef;--muted:#9c9ca3;--line:#34343a;--c0:#ef5a60;--c5:#e6a73a;--c1:#46b86b;
--pt:#a0a0a8;--road:#b8a57e;--up:#5b95e6;--down:#e56a9c;--root:#ececef;--crit:#e56a9c;
--stripfill:#5b95e6;--strip-a:.10;--unit:#a47ce0;--comm:#46c1b3;--sel:#ececef;--lane:#202024}}
:root[data-theme="dark"]{--bg:#141416;--card:#1c1c1f;--fg:#ececef;--muted:#9c9ca3;--line:#34343a;
--c0:#ef5a60;--c5:#e6a73a;--c1:#46b86b;--pt:#a0a0a8;--road:#b8a57e;--up:#5b95e6;--down:#e56a9c;
--root:#ececef;--crit:#e56a9c;--stripfill:#5b95e6;--strip-a:.10;--unit:#a47ce0;--comm:#46c1b3;
--sel:#ececef;--lane:#202024}
*{box-sizing:border-box}
html,body{margin:0;background:var(--bg);color:var(--fg);
font:14px/1.45 -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,sans-serif}
main{max-width:1320px;margin:0 auto;padding:16px}
h1{font-size:20px;margin:4px 0 2px}h2{font-size:16px;margin:0 0 8px}
.muted{color:var(--muted)}.note{color:var(--muted);font-size:12px;margin:2px 0 10px}
.card{background:var(--card);border:1px solid var(--line);border-radius:8px;padding:12px 14px;margin:12px 0}
.counts{display:flex;flex-wrap:wrap;gap:6px 18px;font-size:12px;color:var(--muted);margin:6px 0 10px}
.counts b{color:var(--fg);font-weight:600}
.bar{display:flex;flex-wrap:wrap;gap:6px 16px;align-items:center;font-size:12px;margin:0 0 8px}
.bar label{white-space:nowrap;cursor:pointer}
.bar .grp{font-weight:600;color:var(--muted)}
.bar input[type=text]{font:inherit;font-size:13px;padding:4px 8px;border-radius:6px;border:1px solid var(--line);
background:var(--bg);color:var(--fg);min-width:0;width:240px;max-width:100%}
.bar button{font:inherit;font-size:12px;padding:4px 10px;border-radius:6px;border:1px solid var(--line);
background:var(--bg);color:var(--fg);cursor:pointer}
.time{display:flex;gap:10px;align-items:center;font-size:12px;margin:0 0 8px;flex-wrap:wrap}
.time input[type=range]{flex:1 1 260px;min-width:160px}
#found{font-size:12px;color:var(--muted);overflow-wrap:anywhere}
.stage{position:relative;height:min(76vh,780px);min-height:360px;border:1px solid var(--line);
border-radius:8px;overflow:hidden;background:var(--card);touch-action:none}
.stage canvas#map{width:100%;height:100%;display:block}
#minimap{position:absolute;right:8px;bottom:8px;width:200px;height:150px;border:1px solid var(--line);
border-radius:6px;background:var(--bg);cursor:crosshair;box-shadow:0 1px 6px rgba(0,0,0,.12)}
#zoombox{position:absolute;right:8px;bottom:166px;display:flex;flex-direction:column;gap:4px}
#zoombox button{width:32px;height:32px;font-size:18px;line-height:1;padding:0;border-radius:6px;
border:1px solid var(--line);background:var(--card);color:var(--fg);cursor:pointer}
#level{position:absolute;left:8px;bottom:8px;font-size:11px;color:var(--muted);background:var(--card);
border:1px solid var(--line);border-radius:5px;padding:2px 7px;max-width:60%}
#tip{position:absolute;display:none;pointer-events:none;background:var(--card);color:var(--fg);
border:1px solid var(--line);border-radius:6px;padding:6px 8px;font-size:12px;white-space:pre-wrap;
max-width:420px;box-shadow:0 2px 10px rgba(0,0,0,.15);z-index:2}
.legend{display:grid;grid-template-columns:repeat(auto-fill,minmax(250px,1fr));gap:4px 16px;font-size:12px}
.legend div{display:flex;align-items:center;gap:8px}
.sw{display:inline-block;flex:0 0 auto}
.sw-grad{width:46px;height:10px;border-radius:3px;background:linear-gradient(90deg,var(--c0),var(--c5),var(--c1))}
.sw-dot{width:10px;height:10px;border-radius:50%;background:var(--c1)}
.sw-sq{width:9px;height:9px;background:var(--c1)}
.sw-dia{width:9px;height:9px;border:1.5px solid var(--root);transform:rotate(45deg)}
.sw-x{width:12px;height:12px;position:relative}
.sw-x:before,.sw-x:after{content:"";position:absolute;left:5px;top:-1px;width:2px;height:14px;background:var(--c0)}
.sw-x:before{transform:rotate(45deg)}.sw-x:after{transform:rotate(-45deg)}
.sw-ln{width:28px;height:0;border-top:2px solid var(--road);opacity:.7}
.sw-up{width:28px;height:0;border-top:2.5px solid var(--up)}
.sw-down{width:28px;height:0;border-top:2.5px solid var(--down)}
.sw-crit{width:0;height:16px;border-left:2px dashed var(--crit)}
.sw-strip{width:28px;height:12px;background:var(--stripfill);opacity:.25}
.sw-flag{width:0;height:0;border-left:9px solid var(--unit);border-top:5px solid transparent;border-bottom:5px solid transparent}
.sw-cm{width:8px;height:8px;background:var(--comm)}
.sw-cmo{width:9px;height:9px;border:1.5px solid var(--comm)}
.sw-lane{width:28px;height:12px;background:var(--lane);border:1px solid var(--line)}
#detail pre{white-space:pre-wrap;overflow-wrap:anywhere;background:var(--bg);border:1px solid var(--line);
border-radius:6px;padding:8px;font:12px/1.4 ui-monospace,SFMono-Regular,Menlo,monospace;margin:6px 0}
#detail ul{margin:4px 0 8px;padding-left:20px}#detail li{margin:1px 0}
#detail a{color:var(--up);cursor:pointer;text-decoration:none}#detail a:hover{text-decoration:underline}
#detail .kv{display:grid;grid-template-columns:max-content 1fr;gap:2px 12px;font-size:13px}
#detail .kv span:nth-child(odd){color:var(--muted)}
code{font:12px ui-monospace,SFMono-Regular,Menlo,monospace}
table.gaps{border-collapse:collapse;font-size:12px;width:100%}
table.gaps td,table.gaps th{border-top:1px solid var(--line);padding:4px 6px;text-align:left;vertical-align:top;
overflow-wrap:anywhere}
@media (max-width:640px){main{padding:10px 16px}.stage{height:70vh}#minimap{width:130px;height:100px}
#zoombox{bottom:116px}}
"""

JS = r"""
(function(){
'use strict';
var D=JSON.parse(document.getElementById('atlas-data').textContent);
var P=D.decls,R=D.roads,U=D.units,CM=D.comm,E=D.extent,ST=D.strip,PN=D.panels;
var cv=document.getElementById('map'),ctx=cv.getContext('2d'),stage=cv.parentNode,tip=document.getElementById('tip'),
mm=document.getElementById('minimap'),mctx=mm.getContext('2d'),lvlEl=document.getElementById('level'),
detail=document.getElementById('detail'),found=document.getElementById('found'),slider=document.getElementById('cut'),
dayEl=document.getElementById('day');
var W=300,H=300,s=1,tx=0,ty=0,minS=0.05,maxS=8,FAR=0.55,NEAR=1.6;
var layer={territory:true,commentary:false,roads:true,units:true,strip:true,closure:true,labels:true};
var cut=D.days.length-1,sel=-1,selKind='',lit=null,hov=null;
var C={};
function col(n){return getComputedStyle(document.documentElement).getPropertyValue(n).trim();}
function colours(){['--bg','--card','--fg','--muted','--line','--c0','--c5','--c1','--pt','--road','--up','--down',
'--root','--crit','--stripfill','--strip-a','--unit','--comm','--sel','--lane'].forEach(function(n){C[n]=col(n);});}
function level(){return s<FAR?0:(s<NEAR?1:2);}
var LVN=['far: the strip, the lane and the points','middle: names of roots and of the selection','near: every name, arrows on the roads'];
function X(x){return x*s+tx;}function Y(y){return y*s+ty;}function wx(px){return (px-tx)/s;}function wy(py){return (py-ty)/s;}
var raf=0;function draw(){if(!raf)raf=requestAnimationFrame(paint);}
function size(){var dpr=window.devicePixelRatio||1;W=stage.clientWidth||300;H=stage.clientHeight||300;
cv.width=Math.round(W*dpr);cv.height=Math.round(H*dpr);ctx.setTransform(dpr,0,0,dpr,0,0);
var mw=mm.clientWidth||200,mh=mm.clientHeight||150;mm.width=Math.round(mw*dpr);mm.height=Math.round(mh*dpr);
mctx.setTransform(dpr,0,0,dpr,0,0);draw();}
function fitBox(x0,y0,x1,y1,pad,cap){var k=Math.min((W-2*pad)/Math.max(x1-x0,1),(H-2*pad)/Math.max(y1-y0,1));
if(cap)k=Math.min(k,cap);s=Math.max(minS,Math.min(maxS,k));tx=W/2-s*(x0+x1)/2;ty=H/2-s*(y0+y1)/2;draw();}
function bottom(){var p=panel(layer.commentary?'margin':'units');return p?p.y1+10:E[3];}
function fitAll(){fitBox(E[0],E[1],E[2],bottom(),10);minS=Math.min(s*0.6,0.05);}
function fitWidth(){var k=(W-20)/(E[2]-E[0]);s=Math.max(minS,Math.min(maxS,k));tx=10-s*E[0];ty=10-s*E[1];draw();}
// ── colour by closure
function hex(c){c=c.replace('#','');if(c.length===3)c=c.split('').map(function(h){return h+h;}).join('');
return [parseInt(c.slice(0,2),16),parseInt(c.slice(2,4),16),parseInt(c.slice(4,6),16)];}
function mix(a,b,t){var p=hex(a),q=hex(b);return 'rgb('+[0,1,2].map(function(i){return Math.round(p[i]+(q[i]-p[i])*t);}).join(',')+')';}
function ccol(c){if(!layer.closure)return C['--pt'];if(c>=1)return C['--c1'];return c<0.5?mix(C['--c0'],C['--c5'],c/0.5):mix(C['--c5'],C['--c1'],(c-0.5)/0.5);}
function vis(i){return P[i].d<=cut;}
function uvis(u){return u.d<=cut;}
function cvis(c){return c.d<=cut;}
function pr(){var lv=level();return lv===0?2.4:(lv===1?3.6:5);}
var placed=[];
function free(x0,y0,x1,y1){for(var i=0;i<placed.length;i++){var p=placed[i];if(x0<p[2]&&x1>p[0]&&y0<p[3]&&y1>p[1])return false;}return true;}
function text(t,x,y,font,colour,opts){ctx.font=font;var w=ctx.measureText(t).width,h=parseInt(font.match(/(\d+)px/)[1],10);
var x0=opts&&opts.center?x-w/2:(opts&&opts.right?x-w:x),y0=y-h;if(x0>W||x0+w<0||y<0||y0>H)return false;
if(!(opts&&opts.force)&&!free(x0-2,y0-2,x0+w+2,y+3))return false;placed.push([x0-2,y0-2,x0+w+2,y+3]);
if(opts&&opts.halo!==false){ctx.lineWidth=3;ctx.strokeStyle=C['--card'];ctx.lineJoin='round';ctx.strokeText(t,x0,y);}
ctx.fillStyle=colour;ctx.fillText(t,x0,y);return true;}
var F='-apple-system,Segoe UI,Roboto,sans-serif';
function short(n){var k=n.lastIndexOf('.');return k<0?n:n.slice(k+1);}
function panel(k){for(var i=0;i<PN.length;i++)if(PN[i].key===k)return PN[i];return null;}
var nbr=null;
function paint(){raf=0;colours();placed=[];var lv=level(),r=pr();
lvlEl.textContent='zoom '+s.toFixed(2)+' \u00b7 '+LVN[lv];
ctx.setLineDash([]);ctx.globalAlpha=1;ctx.fillStyle=C['--card'];ctx.fillRect(0,0,W,H);
// panels
PN.forEach(function(p){if(p.key==='margin'&&!layer.commentary)return;if(p.key==='units'&&!(layer.territory&&layer.units))return;
var x0=X(E[0]+10),x1=X(E[2]-10),y0=Y(p.y0),y1=Y(p.y1);if(y1<0||y0>H)return;
if(p.key!=='strip'){ctx.fillStyle=C['--lane'];ctx.fillRect(x0,y0,x1-x0,y1-y0);}
ctx.strokeStyle=C['--line'];ctx.lineWidth=1;ctx.strokeRect(x0+.5,y0+.5,x1-x0,y1-y0);});
/*G:terrain*/var sp=panel('strip');
if(layer.strip){var y0=Y(sp.y0),y1=Y(sp.y1);
ctx.globalAlpha=parseFloat(C['--strip-a'])||.07;ctx.fillStyle=C['--stripfill'];ctx.fillRect(X(ST.x0),y0,X(ST.x1)-X(ST.x0),y1-y0);ctx.globalAlpha=1;
ctx.strokeStyle=C['--muted'];ctx.lineWidth=1;[ST.x0,ST.x1].forEach(function(x){ctx.beginPath();ctx.moveTo(X(x)+.5,y0);ctx.lineTo(X(x)+.5,y1);ctx.stroke();});
ctx.setLineDash([7,5]);ctx.strokeStyle=C['--crit'];ctx.lineWidth=2;ctx.beginPath();ctx.moveTo(X(ST.xh),y0);ctx.lineTo(X(ST.xh),y1);ctx.stroke();ctx.setLineDash([]);
// t axis
ctx.strokeStyle=C['--line'];ctx.lineWidth=1;ctx.beginPath();ctx.moveTo(X(ST.xl),Y(sp.t_zero)+.5);ctx.lineTo(X(ST.xr),Y(sp.t_zero)+.5);ctx.stroke();
ctx.beginPath();ctx.moveTo(X(ST.xl),Y(sp.band_top)-10.5);ctx.lineTo(X(ST.xr),Y(sp.band_top)-10.5);ctx.stroke();
// ticks
for(var q=Math.ceil(ST.rmin*4)/4;q<=ST.rmax+1e-9;q+=0.25){var xx=X((q-ST.rmin)*ST.K);var lab=q===0.5?'Re s = 1/2':(Math.abs(q-Math.round(q))<1e-9?'Re s = '+Math.round(q):'');
ctx.strokeStyle=C['--muted'];ctx.beginPath();ctx.moveTo(xx+.5,Y(sp.y0)+30);ctx.lineTo(xx+.5,Y(sp.y0)+38);ctx.stroke();
if(lab&&(lv>=1||q===0.5||q===0||q===1))text(lab,xx,Y(sp.y0)+26,(q===0.5?'600 ':'')+'12px '+F,q===0.5?C['--crit']:C['--muted'],{center:true,force:q===0.5});}
if(lv>=1){text('t = 0',X(ST.xl)+8,Y(sp.t_zero)-4,'11px '+F,C['--muted'],{});
[-1,1].forEach(function(g){var ty2=Y(sp.t_zero-g*sp.tmax*sp.tscale);ctx.strokeStyle=C['--line'];ctx.setLineDash([2,4]);ctx.beginPath();ctx.moveTo(X(ST.xl),ty2+.5);ctx.lineTo(X(ST.xr),ty2+.5);ctx.stroke();ctx.setLineDash([]);
text('t = '+(g*sp.tmax).toFixed(2).replace(/\.?0+$/,''),X(ST.xl)+8,ty2-4,'11px '+F,C['--muted'],{});});
text(sp.t_label,X(ST.xl)+8,Y(sp.t_top)+4,'11px '+F,C['--muted'],{});
text('no bound on Im s, an equality on Re s: stacked on its line by first appearance',X(ST.xl)+8,Y(sp.sub_tops[0])+14,'11px '+F,C['--muted'],{});
ctx.strokeStyle=C['--line'];ctx.setLineDash([2,4]);ctx.beginPath();ctx.moveTo(X(ST.xl),Y(sp.sub_tops[1])+.5);ctx.lineTo(X(ST.xr),Y(sp.sub_tops[1])+.5);ctx.stroke();ctx.setLineDash([]);
text('no bound on Im s, an interval on Re s: stacked at its middle, cut to the strip',X(ST.xl)+8,Y(sp.sub_tops[1])+14,'11px '+F,C['--muted'],{});}}
text(sp.label,X(E[0]+10)+8,Y(sp.y0)+14,'600 13px '+F,C['--fg'],{force:true});
var ln=panel('lane');
ln.bands.forEach(function(b){ctx.strokeStyle=C['--line'];ctx.beginPath();ctx.moveTo(X(E[0]+10),Y(b.y0)+.5);ctx.lineTo(X(E[2]-10),Y(b.y0)+.5);ctx.stroke();});
text(ln.label,X(E[0]+10)+8,Y(ln.y0)+18,'600 13px '+F,C['--fg'],{force:true});
ln.bands.forEach(function(b){text(b.label,X(E[0]+10)+8,Y(b.y0)+16,'12px '+F,C['--muted'],{});});
var step=ln.maxdep>40?10:5;for(var dp=0;dp<=ln.maxdep;dp+=step){var gx=X(ln.x0+dp*ln.dx+2);ctx.strokeStyle=C['--line'];
ctx.beginPath();ctx.moveTo(gx+.5,Y(ln.y0)+24);ctx.lineTo(gx+.5,Y(ln.y1));ctx.stroke();
if(lv>=1||dp===0)text(dp===0?'depth 0: the roots':'depth '+dp,gx+3,Y(ln.y0)+36,'11px '+F,C['--muted'],{});}
// origin
var ox=X(ln.x0),oy=Y(ln.bands.length?ln.bands[0].y0:ln.y0)-8;ctx.fillStyle=C['--root'];ctx.beginPath();ctx.arc(ox,oy,4,0,7);ctx.fill();
if(lv>=1){text('origin (Re s = 0): the roots, where Primebeat begins, at 0 and 1 and the first primes',ox+8,oy+4,'italic 11px '+F,C['--fg'],{});}
if(layer.territory&&layer.units){var up=panel('units');text(up.label,X(E[0]+10)+8,Y(up.y0)+18,'600 13px '+F,C['--fg'],{force:true});}
if(layer.commentary){var mp=panel('margin');text(mp.label,X(E[0]+10)+8,Y(mp.y0)+18,'600 13px '+F,C['--fg'],{force:true});}
// roads
if(layer.territory&&layer.roads){ctx.lineWidth=lv===0?0.6:1;ctx.strokeStyle=C['--road'];ctx.globalAlpha=lit||sel>=0?0.08:(lv===0?0.16:0.22);
ctx.beginPath();R.forEach(function(rd){if(!vis(rd[0])||!vis(rd[1]))return;var a=P[rd[0]],b=P[rd[1]];
var ax=X(a.x),ay=Y(a.y),bx=X(b.x),by=Y(b.y);if((ax<0&&bx<0)||(ax>W&&bx>W)||(ay<0&&by<0)||(ay>H&&by>H))return;
ctx.moveTo(ax,ay);ctx.lineTo(bx,by);});ctx.stroke();ctx.globalAlpha=1;
if(lv===2&&!(lit||sel>=0)){ctx.fillStyle=C['--road'];ctx.globalAlpha=.5;R.forEach(function(rd){if(!vis(rd[0])||!vis(rd[1]))return;
var a=P[rd[0]],b=P[rd[1]];arrowHead(X(a.x),Y(a.y),X(b.x),Y(b.y),r+1,5);});ctx.globalAlpha=1;}
if(sel>=0&&selKind==='d'){var sd=P[sel];ctx.lineWidth=2;
sd.u.forEach(function(j){if(!vis(j))return;line(P[j],sd,C['--up']);});
sd.ub.forEach(function(j){if(!vis(j))return;line(sd,P[j],C['--down']);});}}
// points
if(layer.territory){P.forEach(function(p,i){if(!vis(i))return;var x=X(p.x),y=Y(p.y);if(x<-10||x>W+10||y<-10||y>H+10)return;
ctx.globalAlpha=(lit&&!lit[i])||(nbr&&!nbr[i])?.2:1;ctx.fillStyle=ccol(p.c);
if(p.k==='theorem'){ctx.beginPath();ctx.arc(x,y,r,0,7);ctx.fill();}else{ctx.fillRect(x-r*.9,y-r*.9,r*1.8,r*1.8);}
if(p.r){ctx.strokeStyle=C['--root'];ctx.lineWidth=lv===0?1:1.4;var q=r+2.2;ctx.beginPath();ctx.moveTo(x,y-q);ctx.lineTo(x+q,y);ctx.lineTo(x,y+q);ctx.lineTo(x-q,y);ctx.closePath();ctx.stroke();}
if(p.s){ctx.strokeStyle=C['--c0'];ctx.lineWidth=2;var z=r+3;ctx.beginPath();ctx.moveTo(x-z,y-z);ctx.lineTo(x+z,y+z);ctx.moveTo(x+z,y-z);ctx.lineTo(x-z,y+z);ctx.stroke();}
if(p.p&&!p.tp&&p.p[3]==='between'&&(lv===2||sel===i)&&layer.strip){var a0=p.p[1]===null?ST.rmin:Math.max(ST.rmin,p.p[1]),a1=p.p[2]===null?ST.rmax:Math.min(ST.rmax,p.p[2]);
ctx.strokeStyle=C['--muted'];ctx.lineWidth=1;ctx.globalAlpha*=.35;ctx.beginPath();ctx.moveTo(X((a0-ST.rmin)*ST.K),y);ctx.lineTo(X((a1-ST.rmin)*ST.K),y);ctx.stroke();ctx.globalAlpha=1;}
if(p.p&&p.tp&&lv>=1&&layer.strip){ctx.strokeStyle=C['--muted'];ctx.lineWidth=1;ctx.globalAlpha*=.6;var lo=p.tp[1],hi=p.tp[2];
var sp2=panel('strip');var ya=lo===null?Y(sp2.t_top):Y(sp2.t_zero-lo*sp2.tscale),yb=hi===null?Y(sp2.t_top+sp2.t_h):Y(sp2.t_zero-hi*sp2.tscale);
ctx.beginPath();ctx.moveTo(x,ya);ctx.lineTo(x,yb);ctx.stroke();}
ctx.globalAlpha=1;});
// unit flags
if(layer.units){var fl=lv===0?5:(lv===1?7:9);
P.forEach(function(p,i){if(!vis(i)||!p.un.length)return;var k=0;p.un.forEach(function(ui){if(!uvis(U[ui]))return;
flag(X(p.x)+k*3,Y(p.y)-r,fl,(lit&&!lit[i])?.25:1);k++;});});
U.forEach(function(u,ui){if(u.x===null||!uvis(u))return;flag(X(u.x),Y(u.y)+fl,fl,1);
if(lv>=1)text(u.id,X(u.x)+fl+3,Y(u.y)+4,'10px '+F,C['--muted'],{});});}}
// commentary
if(layer.commentary){var cs=lv===0?2.5:(lv===1?3.5:4.5);
P.forEach(function(p,i){if(!vis(i))return;var n=0;p.cm.forEach(function(c){if(cvis(CM[c]))n++;});if(!n)return;
var z=cs+Math.min(5,Math.sqrt(n));ctx.globalAlpha=(lit&&!lit[i])?.25:.9;ctx.fillStyle=C['--comm'];ctx.fillRect(X(p.x)+r+1,Y(p.y)+r-1,z,z);ctx.globalAlpha=1;});
Object.keys(D.file_cm).forEach(function(f){var i=D.file_anchor[f];if(i===undefined||!vis(i))return;var n=0;D.file_cm[f].forEach(function(c){if(cvis(CM[c]))n++;});if(!n)return;
var p=P[i],z=cs+1+Math.min(5,Math.sqrt(n));ctx.strokeStyle=C['--comm'];ctx.lineWidth=1.5;ctx.strokeRect(X(p.x)-r-z-2,Y(p.y)-z/2,z,z);});
U.forEach(function(u){var n=0;u.cm.forEach(function(c){if(cvis(CM[c]))n++;});if(!n||!uvis(u))return;var z=cs+Math.min(5,Math.sqrt(n));
ctx.fillStyle=C['--comm'];if(u.x!==null)ctx.fillRect(X(u.x)-z-3,Y(u.y)+3,z,z);else u.pins.forEach(function(i){if(vis(i))ctx.fillRect(X(P[i].x)-z/2,Y(P[i].y)-r-12-z,z,z);});});
CM.forEach(function(c,ci){if(c.x===null||!cvis(c))return;ctx.globalAlpha=lit&&!(litC&&litC[ci])?.25:.85;ctx.fillStyle=C['--comm'];ctx.fillRect(X(c.x)-cs/2,Y(c.y)-cs/2,cs,cs);});ctx.globalAlpha=1;}
// labels
if(layer.territory&&layer.labels){var sf='11px '+F;
function lab(i,force,bold){var p=P[i];return text(lv===2||force?short(p.n):short(p.n),X(p.x)+r+3,Y(p.y)+4,(bold?'600 ':'')+sf,C['--fg'],{force:force});}
if(sel>=0&&selKind==='d')lab(sel,true,true);if(hov&&hov[0]==='d'&&hov[1]!==sel)lab(hov[1],true,false);
if(lit)P.forEach(function(p,i){if(lit[i]&&vis(i)&&i!==sel)lab(i,false,true);});
if(nbr)P.forEach(function(p,i){if(nbr[i]&&vis(i)&&i!==sel)lab(i,false,false);});
if(lv>=1)P.forEach(function(p,i){if(vis(i)&&p.r)lab(i,false,false);});
if(lv===2)P.forEach(function(p,i){if(vis(i)&&!p.r)lab(i,false,false);});}
if(sel>=0&&selKind==='d'&&vis(sel)){var p=P[sel];ctx.strokeStyle=C['--sel'];ctx.lineWidth=2;ctx.beginPath();ctx.arc(X(p.x),Y(p.y),r+5,0,7);ctx.stroke();}
if(lit)P.forEach(function(p,i){if(lit[i]&&vis(i)){ctx.strokeStyle=C['--sel'];ctx.lineWidth=1.5;ctx.beginPath();ctx.arc(X(p.x),Y(p.y),r+3.5,0,7);ctx.stroke();}});
/*G:labels*/mini();}
var litC=null;
/*G:init*/function line(a,b,c){ctx.strokeStyle=c;ctx.globalAlpha=.85;var ax=X(a.x),ay=Y(a.y),bx=X(b.x),by=Y(b.y);ctx.beginPath();ctx.moveTo(ax,ay);ctx.lineTo(bx,by);ctx.stroke();
ctx.fillStyle=c;arrowHead(ax,ay,bx,by,pr()+1,7);ctx.globalAlpha=1;}
function arrowHead(x0,y0,x1,y1,back,len){var a=Math.atan2(y1-y0,x1-x0),ex=x1-Math.cos(a)*back,ey=y1-Math.sin(a)*back;
if(Math.hypot(x1-x0,y1-y0)<back+len)return;ctx.beginPath();ctx.moveTo(ex,ey);ctx.lineTo(ex-Math.cos(a-0.45)*len,ey-Math.sin(a-0.45)*len);
ctx.lineTo(ex-Math.cos(a+0.45)*len,ey-Math.sin(a+0.45)*len);ctx.closePath();ctx.fill();}
function flag(x,y,h,alpha){ctx.globalAlpha=alpha;ctx.strokeStyle=C['--unit'];ctx.fillStyle=C['--unit'];ctx.lineWidth=1.2;
ctx.beginPath();ctx.moveTo(x,y);ctx.lineTo(x,y-h*1.4);ctx.stroke();ctx.beginPath();ctx.moveTo(x,y-h*1.4);ctx.lineTo(x+h,y-h*1.1);ctx.lineTo(x,y-h*0.8);ctx.closePath();ctx.fill();ctx.globalAlpha=1;}
function mini(){var mw=mm.clientWidth||200,mh=mm.clientHeight||150,B=bottom();var k=Math.min((mw-8)/(E[2]-E[0]),(mh-8)/(B-E[1]));
var ox=(mw-k*(E[2]-E[0]))/2-k*E[0],oy=(mh-k*(B-E[1]))/2-k*E[1];mini.k=k;mini.ox=ox;mini.oy=oy;
mctx.fillStyle=C['--bg'];mctx.fillRect(0,0,mw,mh);
mctx.globalAlpha=1;PN.forEach(function(p){if(p.key==='margin'&&!layer.commentary)return;mctx.fillStyle=p.key==='strip'?C['--card']:C['--lane'];mctx.fillRect(ox+k*E[0],oy+k*p.y0,k*(E[2]-E[0]),Math.max(1,k*(p.y1-p.y0)));});
var sp=panel('strip');mctx.fillStyle=C['--stripfill'];mctx.globalAlpha=.2;mctx.fillStyle=C['--stripfill'];mctx.fillRect(ox+k*ST.x0,oy+k*sp.y0,k*(ST.x1-ST.x0),k*(sp.y1-sp.y0));mctx.globalAlpha=1;
mctx.fillStyle=C['--crit'];mctx.fillRect(ox+k*ST.xh-.5,oy+k*sp.y0,1,k*(sp.y1-sp.y0));
P.forEach(function(p,i){if(!vis(i))return;mctx.fillStyle=lit&&lit[i]?C['--sel']:ccol(p.c);mctx.fillRect(ox+k*p.x-.75,oy+k*p.y-.75,1.5,1.5);});
if(layer.commentary)CM.forEach(function(c){if(c.x===null||!cvis(c))return;mctx.fillStyle=C['--comm'];mctx.fillRect(ox+k*c.x-.75,oy+k*c.y-.75,1.5,1.5);});
var vx0=ox+k*wx(0),vy0=oy+k*wy(0),vx1=ox+k*wx(W),vy1=oy+k*wy(H);mctx.strokeStyle=C['--sel'];mctx.lineWidth=1.5;
mctx.strokeRect(Math.max(vx0,1),Math.max(vy0,1),Math.min(vx1,mw-1)-Math.max(vx0,1),Math.min(vy1,mh-1)-Math.max(vy0,1));}
// ── hit testing and tooltips
function hit(x,y){var r=pr(),best=null,bd=Math.max(8,r+4);
if(layer.territory)P.forEach(function(p,i){if(!vis(i))return;var d=Math.hypot(X(p.x)-x,Y(p.y)-y);if(d<bd){bd=d;best=['d',i];}});
if(layer.territory&&layer.units)U.forEach(function(u,i){if(u.x===null||!uvis(u))return;var d=Math.hypot(X(u.x)-x,Y(u.y)-y);if(d<bd){bd=d;best=['u',i];}});
if(layer.commentary)CM.forEach(function(c,i){if(c.x===null||!cvis(c))return;var d=Math.hypot(X(c.x)-x,Y(c.y)-y);if(d<bd){bd=d;best=['c',i];}});
/*G:hit*/return best;}
function clo(c){return c>=1?'1':c.toFixed(3);}
function placeText(p){if(!p.p)return 'lane: no bound on Re s';var q=p.p;var v=function(z){return z===null?'\u2013':(+z.toFixed(4)).toString();};
return q[3]==='on'?'on Re s = '+v(q[0]):(q[3]==='between'?'Re s in ['+v(q[1])+', '+v(q[2])+'], drawn at '+v(q[0]):q[3]+': drawn at '+v(q[0])+' (bounds '+v(q[1])+', '+v(q[2])+')');}
function tipLines(h){/*G:tip*/if(h[0]==='d'){var p=P[h[1]];return [p.n,p.k+'  \u00b7  '+D.files[p.f]+':'+p.l,'closure '+clo(p.c)+(p.s?'  \u00b7  sorry':'')+(p.r?'  \u00b7  root':'  \u00b7  depth '+p.dp),
placeText(p),'first appears '+(D.days[p.d]||'?'),'uses '+p.u.length+'  \u00b7  used by '+p.ub.length+(p.un.length?'  \u00b7  units '+p.un.map(function(u){return U[u].id;}).join(', '):'')+(p.cm.length?'  \u00b7  commentary '+p.cm.length:''),'click to open its section'];}
if(h[0]==='u'){var u=U[h[1]];return ['unit '+u.id+'  \u00b7  '+u.date+'  \u00b7  '+u.type,u.t,u.unres.length?'refs not found: '+u.unres.join(', '):'no Lean ref'];}
var c=CM[h[1]];return [c.p,c.k+'  \u00b7  added '+(D.days[c.d]||'?'),'names no declaration, .lean file or unit'];}
function show(lines,px,py){tip.textContent=lines.filter(function(t){return t;}).join('\n');tip.style.display='block';
var w=tip.offsetWidth,h=tip.offsetHeight,x=px+14,y=py+14;if(x+w>W)x=Math.max(0,px-w-14);if(y+h>H)y=Math.max(0,py-h-10);tip.style.left=x+'px';tip.style.top=y+'px';}
function hide(){tip.style.display='none';}
// ── the section below the map
function el(tag,t,cls){var e=document.createElement(tag);if(t!==undefined&&t!==null)e.textContent=t;if(cls)e.className=cls;return e;}
function dlink(i){var a=el('a',P[i].n);a.title=D.files[P[i].f]+':'+P[i].l;a.onclick=function(){pick(i,true);};return a;}
function ulink(ui){var a=el('a','unit '+U[ui].id);a.onclick=function(){pickUnit(ui,true);};return a;}
function clink(ci){var a=el('a',CM[ci].p);a.onclick=function(){pickComm(ci);};return a;}
function list(title,items,mk){var box=el('div');box.appendChild(el('strong',title+' ('+items.length+')'));if(!items.length){box.appendChild(el('div','none','muted'));return box;}
var ul=el('ul');items.forEach(function(x){var li=el('li');li.appendChild(mk(x));ul.appendChild(li);});box.appendChild(ul);return box;}
function kv(pairs){var g=el('div',null,'kv');pairs.forEach(function(p){g.appendChild(el('span',p[0]));g.appendChild(el('span',p[1]));});return g;}
function pick(i,center){sel=i;selKind='d';lit=null;litC=null;var p=P[i];nbr={};nbr[i]=1;p.u.forEach(function(j){nbr[j]=1;});p.ub.forEach(function(j){nbr[j]=1;});
detail.textContent='';detail.appendChild(el('h2',p.n));
detail.appendChild(kv([['kind',p.k+(p.pv?' (private)':'')],['file',D.files[p.f]+':'+p.l],['project',D.scopes[p.sc].label],
['closure',clo(p.c)+(p.c<1?' of its cone is free of direct sorry':' (its cone is free of direct sorry)')],['direct sorry',p.s?'yes':'no'],
['root',p.r?'yes: it uses no other Primebeat declaration':'no, depth '+p.dp+' from the roots'],['on the strip',placeText(p)],
['Re s bounds read',p.re.length?p.re.join('  \u00b7  '):'none'],['Im s bounds read',p.im.length?p.im.join('  \u00b7  '):'none'],
['first appears',(D.days[p.d]||'?')+' (git, the oldest version of its file naming it)']]));
detail.appendChild(el('strong','statement'));detail.appendChild(el('pre',p.ty));
detail.appendChild(list('uses (upstream)',p.u,dlink));detail.appendChild(list('used by (downstream)',p.ub,dlink));
detail.appendChild(list('units pinned to it by refs:',p.un,function(ui){var s=el('span');s.appendChild(ulink(ui));s.appendChild(document.createTextNode('  '+U[ui].date+'  '+U[ui].t));return s;}));
detail.appendChild(list('commentary naming it',p.cm,clink));
var fc=D.file_cm[String(p.f)]||[];detail.appendChild(list('commentary naming its file '+D.files[p.f].split('/').pop(),fc,clink));
/*G:pick*/if(center)focus(p.x,p.y);draw();}
function pickUnit(ui,center){var u=U[ui];sel=ui;selKind='u';nbr=null;litC=null;lit={};u.pins.forEach(function(i){lit[i]=1;});if(!u.pins.length)lit=null;
detail.textContent='';detail.appendChild(el('h2','unit '+u.id+': '+u.t));
detail.appendChild(kv([['date',u.date],['type',u.type],['directory','units/'+u.dir],['refs',u.refs.join(', ')||'none'],['refs not found',u.unres.join(', ')||'none']]));
detail.appendChild(list('declarations it is pinned to',u.pins,dlink));detail.appendChild(list('commentary naming it',u.cm,clink));
if(center){if(u.pins.length)fitHits(u.pins);else if(u.x!==null)focus(u.x,u.y);}draw();}
function pickComm(ci){var c=CM[ci];sel=ci;selKind='c';nbr=null;lit={};litC={};litC[ci]=1;c.ds.forEach(function(i){lit[i]=1;});
if(!layer.commentary){layer.commentary=true;sync();}
detail.textContent='';detail.appendChild(el('h2',c.p));detail.appendChild(kv([['kind',c.k],['added',D.days[c.d]||'?']]));
detail.appendChild(list('declarations it names',c.ds,dlink));
detail.appendChild(list('.lean files it names',c.fs,function(f){return el('code',D.files[f]);}));
detail.appendChild(list('units it names',c.us,function(id){var ui=-1;U.forEach(function(u,k){if(u.id===id)ui=k;});return ui>=0?ulink(ui):el('span',id);}));
if(c.ds.length)fitHits(c.ds);else if(c.x!==null)focus(c.x,c.y);draw();}
function focus(x,y){var k=Math.max(s,1.2);s=Math.min(maxS,k);tx=W/2-s*x;ty=H/2-s*y;draw();}
function fitHits(hs){var x0=1e9,y0=1e9,x1=-1e9,y1=-1e9;hs.forEach(function(i){x0=Math.min(x0,P[i].x);x1=Math.max(x1,P[i].x);y0=Math.min(y0,P[i].y);y1=Math.max(y1,P[i].y);});
fitBox(x0-60,y0-50,x1+60,y1+50,30,2.2);}
// ── search
function search(q){var key=(q||'').trim().toLowerCase();nbr=null;if(!key){lit=null;found.textContent='';draw();return [];}
var exact=[],part=[];P.forEach(function(p,i){var n=p.n.toLowerCase();if(n===key||short(n)===key)exact.push(i);else if(n.indexOf(key)>=0)part.push(i);});
var hits=exact.length?exact:part;if(!hits.length){lit=null;found.textContent='no declaration matches';draw();return hits;}
lit={};hits.forEach(function(i){lit[i]=1;});
found.textContent=hits.length+' declaration(s)'+(hits.length<=12?': '+hits.map(function(i){return P[i].n;}).join(', '):'');
if(hits.length===1)pick(hits[0],true);else fitHits(hits);if(hits.length>1){lit={};hits.forEach(function(i){lit[i]=1;});draw();}return hits;}
// ── pointer
var ptrs={},down=null,moved=false,pinch=null;
function pos(e){var r=cv.getBoundingClientRect();return [e.clientX-r.left,e.clientY-r.top];}
function zoomAt(px,py,k){var ns=Math.max(minS,Math.min(maxS,s*k));k=ns/s;tx=px-(px-tx)*k;ty=py-(py-ty)*k;s=ns;hide();draw();}
cv.addEventListener('pointerdown',function(e){cv.setPointerCapture(e.pointerId);var p=pos(e);ptrs[e.pointerId]=p;var ids=Object.keys(ptrs);
if(ids.length===2){var a=ptrs[ids[0]],b=ptrs[ids[1]];pinch={d:Math.hypot(a[0]-b[0],a[1]-b[1])||1,s:s};}down={x:p[0],y:p[1],tx:tx,ty:ty};moved=false;});
cv.addEventListener('pointermove',function(e){var p=pos(e);if(ptrs[e.pointerId])ptrs[e.pointerId]=p;var ids=Object.keys(ptrs);
if(pinch&&ids.length===2){var a=ptrs[ids[0]],b=ptrs[ids[1]],d=Math.hypot(a[0]-b[0],a[1]-b[1])||1;zoomAt((a[0]+b[0])/2,(a[1]+b[1])/2,pinch.s*d/pinch.d/s);moved=true;return;}
if(down&&ids.length===1){var dx=p[0]-down.x,dy=p[1]-down.y;if(Math.abs(dx)+Math.abs(dy)>4)moved=true;if(moved){tx=down.tx+dx;ty=down.ty+dy;hide();draw();return;}}
if(!down){var h=hit(p[0],p[1]);var same=(h&&hov&&h[0]===hov[0]&&h[1]===hov[1])||(!h&&!hov);hov=h;if(!same)draw();cv.style.cursor=h?'pointer':'grab';if(h)show(tipLines(h),p[0],p[1]);else hide();}});
function up(e){var p=pos(e);delete ptrs[e.pointerId];if(Object.keys(ptrs).length<2)pinch=null;
if(down&&!moved){var h=hit(p[0],p[1]);if(h){/*G:click*/if(h[0]==='d')pick(h[1],false);else if(h[0]==='u')pickUnit(h[1],false);else pickComm(h[1]);
document.getElementById('detail').scrollIntoView({block:'nearest'});}}if(!Object.keys(ptrs).length)down=null;}
cv.addEventListener('pointerup',up);cv.addEventListener('pointercancel',up);
cv.addEventListener('pointerleave',function(){if(!down){hide();if(hov){hov=null;draw();}}});
cv.addEventListener('wheel',function(e){e.preventDefault();var p=pos(e);zoomAt(p[0],p[1],Math.exp(-(e.deltaY||0)*0.0015));},{passive:false});
function mmMove(e){var r=mm.getBoundingClientRect(),mx=e.clientX-r.left,my=e.clientY-r.top;tx=W/2-s*(mx-mini.ox)/mini.k;ty=H/2-s*(my-mini.oy)/mini.k;hide();draw();}
var mmDown=false;mm.addEventListener('pointerdown',function(e){mmDown=true;mm.setPointerCapture(e.pointerId);mmMove(e);e.stopPropagation();});
mm.addEventListener('pointermove',function(e){if(mmDown)mmMove(e);});mm.addEventListener('pointerup',function(){mmDown=false;});
document.getElementById('zin').onclick=function(){zoomAt(W/2,H/2,1.6);};document.getElementById('zout').onclick=function(){zoomAt(W/2,H/2,1/1.6);};
document.getElementById('zfit').onclick=fitAll;
function sync(){Array.prototype.forEach.call(document.querySelectorAll('input[data-layer]'),function(b){b.checked=!!layer[b.getAttribute('data-layer')];});}
Array.prototype.forEach.call(document.querySelectorAll('input[data-layer]'),function(b){b.onchange=function(){layer[b.getAttribute('data-layer')]=b.checked;draw();};});
document.getElementById('find').onsubmit=function(e){e.preventDefault();search(document.getElementById('q').value);};
document.getElementById('qclear').onclick=function(){document.getElementById('q').value='';sel=-1;nbr=null;search('');};
// ── time
function setCut(k){cut=k;slider.value=k;var n=0;P.forEach(function(p,i){if(vis(i))n++;});dayEl.textContent=(D.days[k]||'')+' \u00b7 '+n+' of '+P.length+' declarations';draw();}
slider.max=Math.max(0,D.days.length-1);slider.oninput=function(){setCut(+slider.value);};
var timer=null;document.getElementById('play').onclick=function(){var b=this;if(timer){clearInterval(timer);timer=null;b.textContent='replay';return;}
b.textContent='pause';setCut(0);timer=setInterval(function(){if(cut>=D.days.length-1){clearInterval(timer);timer=null;b.textContent='replay';return;}setCut(cut+1);},160);};
window.addEventListener('resize',size);
if(window.matchMedia){var mq=window.matchMedia('(prefers-color-scheme: dark)');if(mq.addEventListener)mq.addEventListener('change',draw);}
window.pbAtlas={search:search,pick:pick,pickUnit:pickUnit,pickComm:pickComm,level:level,layer:layer,sync:sync,draw:draw,
view:function(k,cx,cy){s=Math.max(minS,Math.min(maxS,k));tx=W/2-s*cx;ty=H/2-s*cy;draw();},fitAll:fitAll,fitWidth:fitWidth,
decls:P.length,roads:R.length,paintNow:function(){raf=0;paint();}};
/*G:api*/size();fitAll();setCut(D.days.length-1);
// state from the address: #comm=1&terr=0&q=name&zoom=2.5&at=name&theme=dark
(function(){var h=(location.hash||'').replace(/^#/,'');if(!h)return;var o={};h.split('&').forEach(function(kv){var i=kv.indexOf('=');if(i>0)o[kv.slice(0,i)]=decodeURIComponent(kv.slice(i+1));});
if(o.theme)document.documentElement.setAttribute('data-theme',o.theme);
if(o.comm)layer.commentary=o.comm==='1';if(o.terr)layer.territory=o.terr!=='0';sync();fitAll();
if(o.q){document.getElementById('q').value=o.q;search(o.q);}
if(o.at){var hits=[];P.forEach(function(p,i){if(p.n===o.at||short(p.n)===o.at)hits.push(i);});if(hits.length){pick(hits[0],true);if(o.zoom){s=+o.zoom;tx=W/2-s*P[hits[0]].x;ty=H/2-s*P[hits[0]].y;}}}
else if(o.zoom){var z=+o.zoom;var cx=o.cx!==undefined?+o.cx:(E[0]+E[2])/2,cy=o.cy!==undefined?+o.cy:(E[1]+E[3])/2;s=z;tx=W/2-s*cx;ty=H/2-s*cy;}
/*G:hash*/draw();})();
paint();
})();
"""


GCSS = r"""
:root{--mgr:#b07d2a;--pgr:#00b8f0;--mgt:#6e4a0e;--pgt:#006e99}
@media (prefers-color-scheme: dark){:root:not([data-theme="light"]){--mgr:#d6a24e;--pgr:#2fd8ff;--mgt:#ecc27d;--pgt:#9eeeff}}
:root[data-theme="dark"]{--mgr:#d6a24e;--pgr:#2fd8ff;--mgt:#ecc27d;--pgt:#9eeeff}
.sw-mg{width:28px;height:12px;border-radius:6px;background:var(--mgr);opacity:.5;box-shadow:inset 0 0 0 1.5px var(--mgt)}
.sw-pg{width:28px;height:12px;border-radius:6px;background:var(--pgr);opacity:.5;box-shadow:inset 0 0 0 1.5px var(--pgt)}
table.ground{border-collapse:collapse;font-size:12px;width:100%}
table.ground td,table.ground th{border-top:1px solid var(--line);padding:4px 6px;text-align:left;vertical-align:top;
overflow-wrap:anywhere}
table.ground a{color:var(--up);cursor:pointer;text-decoration:none}table.ground a:hover{text-decoration:underline}
table.ground .n{white-space:nowrap}table.ground td.i{min-width:180px}
.tscroll{overflow-x:auto}
"""

# The ground layers' JS, spliced at the markers of JS. With no ground data
# every marker is removed and JS is the atlas's page script as it was.
GJS = {
    "init": r"""var G=D.ground,GL=['mground','pground'],GA=G.areas,GC=G.consts,GI=G.islands,terr=[null,null],GMAX=[0,0];
layer.mground=false;layer.pground=false;
GA.forEach(function(a){if(a.h>GMAX[a.l])GMAX[a.l]=a.h;});
function gOn(l){return !!layer[GL[l]];}
function stands(a,i){return a.bg.indexOf(P[i].sc)<0;}
function aname(k){var n=GA[k].n;return n.slice(n.indexOf('.')+1);}
function scname(si){return D.scopes[si].key+'/';}
function ilabel(k){var t=GI[k];return 'island of '+short(P[t.top].n)+' ('+t.m.length+')';}
function wOf(k,si){var n=GA[k].k[si],N=G.counts[D.scopes[si].key].islands;return n?Math.log(N/n):0;}
function cIsl(c){return GC[c][2].reduce(function(x,y){return x+y;},0);}
function bgText(mask){var o=[];D.scopes.forEach(function(sc,si){if(mask&(1<<si))o.push(scname(si));});return o.join(', ');}
function pinsOf(k){var t=GI[k];return 'Mathlib '+(t.pin||'?')+(t.pnt?' · PrimeNumberTheoremAnd '+t.pnt:'')+' (the pins of '+t.host+'/)';}
function field(l){var c=C[l?'--pgr':'--mgr'],key=cut+'|'+c,t=terr[l];if(t&&t.key===key)return t;
var res=G.res,x0=E[0],y0=E[1],fw=Math.ceil((E[2]-E[0])/res)+1,fh=Math.ceil((E[3]-E[1])/res)+1,n=fw*fh;
var f=new Float32Array(n),tmp=new Float32Array(n),stamp=new Int32Array(n).fill(-1),rad=G.rad/res,R=Math.ceil(rad);
GA.forEach(function(a,ai){if(a.l!==l||!GMAX[l]||!a.h)return;var hgt=a.h/GMAX[l],touched=[];
a.d.forEach(function(i){if(!vis(i)||!stands(a,i))return;var cx=(P[i].x-x0)/res,cy=(P[i].y-y0)/res;
var ix0=Math.max(0,Math.floor(cx-R)),ix1=Math.min(fw-1,Math.ceil(cx+R)),iy0=Math.max(0,Math.floor(cy-R)),iy1=Math.min(fh-1,Math.ceil(cy+R));
for(var yy=iy0;yy<=iy1;yy++)for(var xx=ix0;xx<=ix1;xx++){var dd=((xx-cx)*(xx-cx)+(yy-cy)*(yy-cy))/(rad*rad);if(dd>=1)continue;
var v=(1-dd)*(1-dd),k=yy*fw+xx;if(stamp[k]!==ai){stamp[k]=ai;tmp[k]=v;touched.push(k);}else if(v>tmp[k])tmp[k]=v;}});
touched.forEach(function(k){f[k]+=hgt*tmp[k];});});
var tv=new Float32Array(n),rgb=hex(c),cv2=document.createElement('canvas');cv2.width=fw;cv2.height=fh;
var g2=cv2.getContext('2d'),img=g2.createImageData(fw,fh),px=img.data;
for(var k=0;k<n;k++){var tt=f[k]>0?1-Math.exp(-f[k]/G.f0[l]):0;tv[k]=tt;if(!tt)continue;var q=k*4;px[q]=rgb[0];px[q+1]=rgb[1];px[q+2]=rgb[2];px[q+3]=Math.round(255*(l?Math.min(.8,Math.sqrt(tt)*.95):Math.min(.5,tt*.55)));}
g2.putImageData(img,0,0);
// contour lines by marching squares, one list of world segments per level
var LV=[0.03,1/7,2/7,3/7,4/7,5/7,6/7],segs=LV.map(function(){return [];}),o=null;
function sg(x1,y1,x2,y2){o.push(x0+x1*res,y0+y1*res,x0+x2*res,y0+y2*res);}
for(var yy=0;yy<fh-1;yy++)for(var xx=0;xx<fw-1;xx++){var k=yy*fw+xx,a=tv[k],b=tv[k+1],cc=tv[k+fw+1],d=tv[k+fw];
if(a===0&&b===0&&cc===0&&d===0)continue;var hi=Math.max(a,b,cc,d),lo=Math.min(a,b,cc,d);
for(var li=0;li<LV.length;li++){var lev=LV[li];if(lev<=lo||lev>hi)continue;
var m=(a>lev?8:0)|(b>lev?4:0)|(cc>lev?2:0)|(d>lev?1:0);if(m===0||m===15)continue;
var Tx=xx+(lev-a)/(b-a),Ry=yy+(lev-b)/(cc-b),Bx=xx+(lev-d)/(cc-d),Ly=yy+(lev-a)/(d-a);o=segs[li];
switch(m){case 1:case 14:sg(xx,Ly,Bx,yy+1);break;case 2:case 13:sg(Bx,yy+1,xx+1,Ry);break;
case 3:case 12:sg(xx,Ly,xx+1,Ry);break;case 4:case 11:sg(Tx,yy,xx+1,Ry);break;
case 5:sg(xx,Ly,Tx,yy);sg(Bx,yy+1,xx+1,Ry);break;case 6:case 9:sg(Tx,yy,Bx,yy+1);break;
case 7:case 8:sg(xx,Ly,Tx,yy);break;case 10:sg(Tx,yy,xx+1,Ry);sg(xx,Ly,Bx,yy+1);break;}}}
t={key:key,c:cv2,fw:fw,fh:fh,segs:segs};terr[l]=t;return t;}
function gpaint(){C['--mgr']=col('--mgr');C['--pgr']=col('--pgr');C['--mgt']=col('--mgt');C['--pgt']=col('--pgt');
[0,1].forEach(function(l){if(!gOn(l))return;var t=field(l);ctx.imageSmoothingEnabled=true;
ctx.drawImage(t.c,X(E[0]-G.res/2),Y(E[1]-G.res/2),t.fw*G.res*s,t.fh*G.res*s);
ctx.strokeStyle=C[l?'--pgt':'--mgt'];ctx.lineWidth=s<FAR?0.6:1;t.segs.forEach(function(sg,li){ctx.globalAlpha=l?Math.min(.95,.45+li*.08):Math.min(.75,.22+li*.08);ctx.beginPath();
for(var j=0;j<sg.length;j+=4){var ax=X(sg[j]),ay=Y(sg[j+1]),bx=X(sg[j+2]),by=Y(sg[j+3]);if((ax<0&&bx<0)||(ax>W&&bx>W)||(ay<0&&by<0)||(ay>H&&by>H))continue;ctx.moveTo(ax,ay);ctx.lineTo(bx,by);}
ctx.stroke();});ctx.globalAlpha=1;});
[[sel>=0&&selKind==='a'?sel:-1,.22],[hov&&hov[0]==='a'?hov[1]:-1,.14]].forEach(function(q){var k=q[0];if(k<0||!gOn(GA[k].l))return;var a=GA[k];
ctx.globalAlpha=q[1];ctx.fillStyle=C[a.l?'--pgt':'--mgt'];ctx.beginPath();a.d.forEach(function(i){if(!vis(i))return;var x=X(P[i].x),y=Y(P[i].y),rr=G.rad*0.8*s;
if(x<-rr||x>W+rr||y<-rr||y>H+rr)return;ctx.moveTo(x+rr,y);ctx.arc(x,y,rr,0,7);});ctx.fill();ctx.globalAlpha=1;});}
function glabels(lv){if(lv<1)return;[0,1].forEach(function(l){if(!gOn(l))return;
var ks=[];GA.forEach(function(a,k){if(a.l===l&&a.at&&a.h)ks.push(k);});ks.sort(function(p,q){return GA[q].h-GA[p].h||p-q;});
ks.forEach(function(k){var a=GA[k];if(!a.d.some(function(i){return vis(i)&&stands(a,i);}))return;
text(aname(k)+' · '+a.h,X(a.at[0]),Y(a.at[1])-G.rad*0.8*s-3,'600 11px '+F,C[l?'--pgt':'--mgt'],{center:true,force:k===sel&&selKind==='a'});});});}
function areasAt(x,y){var out=[],px_=wx(x),py_=wy(y),r2=G.rad*G.rad*0.64;
GA.forEach(function(a,k){if(!gOn(a.l)||!a.h)return;for(var n=0;n<a.d.length;n++){var i=a.d[n];if(!vis(i)||!stands(a,i))continue;
var dx=P[i].x-px_,dy=P[i].y-py_;if(dx*dx+dy*dy<r2){out.push(k);break;}}});
out.sort(function(p,q){return GA[q].h-GA[p].h||p-q;});return out;}
function areaHit(x,y){var o=areasAt(x,y);return o.length?['a',o[0],o]:null;}
function byIsl(cs){return cs.slice().sort(function(p,q){return cIsl(q)-cIsl(p)||(GC[p][1]<GC[q][1]?-1:(GC[p][1]>GC[q][1]?1:0));});}
function cText(c){var q=GC[c],n=cIsl(c);return q[1]+'  ('+n+' island'+(n===1?'':'s')+(q[3]?'; background in '+bgText(q[3]):'')+')';}
function areaTip(k,also){var a=GA[k],cs=byIsl(a.c);
var lines=[a.n,G.libs[a.l]+'  ·  rises with '+a.h+' island(s)'+(a.bg.length?'  ·  background in '+a.bg.map(scname).join(', '):''),
'constants used from it ('+cs.length+'):'];cs.slice(0,12).forEach(function(c){lines.push('  '+cText(c));});
if(cs.length>12)lines.push('  + '+(cs.length-12)+' more in its section');
if(also&&also.length>1)lines.push('also under this point: '+also.slice(1,7).map(aname).join(', ')+(also.length>7?' …':''));
lines.push('click to open its section');return lines;}
function alink(k){var a=el('a',GA[k].n);a.onclick=function(){pickArea(k,true);};return a;}
function ilink(k){var a=el('a',ilabel(k));a.title=D.scopes[GI[k].sc].label;a.onclick=function(){pickIsland(k,true);};return a;}
function span(parts){var s2=el('span');parts.forEach(function(x){s2.appendChild(typeof x==='string'?document.createTextNode(x):x);});return s2;}
function pickArea(k,center,also){var a=GA[k];if(!gOn(a.l)){layer[GL[a.l]]=true;sync();}sel=k;selKind='a';nbr=null;litC=null;lit={};a.d.forEach(function(i){lit[i]=1;});
detail.textContent='';detail.appendChild(el('h2',a.n));
detail.appendChild(kv([['library',G.libs[a.l]],['area','a module path cut to three components (four under PrimeNumberTheoremAnd.Mathlib)'],
['islands holding it',D.scopes.map(function(sc,si){return scname(si)+' '+a.k[si]+' of '+G.counts[sc.key].islands;}).join('  ·  ')],
['background in',a.bg.length?a.bg.map(scname).join(', ')+' (held by '+G.share+' of that project’s islands; no terrain there)':'no project'],
['terrain height',a.h+' island(s) stand on it where it is not background'],
['versions','lean/ and lean_stage3/ pin different Mathlib versions: across them this is the same area name, two versions']]));
detail.appendChild(list('islands standing on it',a.i,function(k2){var on=GI[k2].m.filter(function(i){return lit[i];}),parts=[ilink(k2),'  '+scname(GI[k2].sc)+(a.bg.indexOf(GI[k2].sc)>=0?' (background there)':'')+' · '+on.length+' of its '+GI[k2].m.length+' declarations: '];
on.slice(0,8).forEach(function(i,n){if(n)parts.push(', ');parts.push(dlink(i));});if(on.length>8)parts.push(', + '+(on.length-8)+' more below');return span(parts);}));
if(also&&also.length>1)detail.appendChild(list('the other areas under the point clicked, highest first',also.slice(1),alink));
detail.appendChild(list('constants used from it',byIsl(a.c),function(c){return el('code',cText(c));}));
detail.appendChild(list('declarations standing on it',a.d,dlink));
if(center){var hs=a.d.filter(vis);if(hs.length)fitHits(hs);}draw();}
function pickIsland(k,center){var t=GI[k];sel=k;selKind='i';nbr=null;litC=null;lit={};t.m.forEach(function(i){lit[i]=1;});
detail.textContent='';detail.appendChild(el('h2',ilabel(k)));
detail.appendChild(kv([['project',D.scopes[t.sc].label],['declarations',String(t.m.length)],['named for',P[t.top].n+': the member whose cone holds most of the island'],['stands on',pinsOf(k)]]));
[0,1].forEach(function(l){var ks=t.a.filter(function(a){return GA[a].l===l;});ks.sort(function(p,q){return wOf(q,t.sc)-wOf(p,t.sc)||p-q;});
detail.appendChild(list(G.libs[l]+' ground, rarest first (rarity weight in '+scname(t.sc)+')',ks,function(a){return span([alink(a),'  '+wOf(a,t.sc).toFixed(2)+(GA[a].bg.indexOf(t.sc)>=0?' (background)':'')]);}));});
detail.appendChild(list('islands sharing the most ground with it',t.pp,function(q){return span([ilink(q[0]),'  shared '+q[1].toFixed(2)+(q[2]?'  ·  a name match across Mathlib '+t.pin+' and '+GI[q[0]].pin:'')]);}));
detail.appendChild(list('declarations',t.m,dlink));
if(center){var hs=t.m.filter(vis);if(hs.length)fitHits(hs);}draw();}
function groundLists(i){var k=G.di[i],box=el('div');box.appendChild(el('strong','island  '));box.appendChild(ilink(k));detail.appendChild(box);
[0,1].forEach(function(l){var by={},n=0;G.dc[i].forEach(function(c){var q=GC[c];if(GA[q[0]].l!==l)return;(by[q[0]]=by[q[0]]||[]).push(q[1]);n++;});
var ks=Object.keys(by).map(Number).sort(function(p,q){return p-q;});
detail.appendChild(list(G.libs[l]+' ground: '+n+' constant'+(n===1?'':'s')+' named directly, by area',ks,function(a){
return span([alink(a),GA[a].bg.indexOf(P[i].sc)>=0?' (background in '+scname(P[i].sc)+')':'',': ',el('code',by[a].join(', '))]);}));});}
Array.prototype.forEach.call(document.querySelectorAll('[data-isl]'),function(b){b.onclick=function(){pickIsland(+b.getAttribute('data-isl'),true);stage.scrollIntoView({block:'nearest'});};});
Array.prototype.forEach.call(document.querySelectorAll('[data-area]'),function(b){b.onclick=function(){pickArea(+b.getAttribute('data-area'),true);stage.scrollIntoView({block:'nearest'});};});
""",
    "terrain": "if(layer.mground||layer.pground)gpaint();",
    "labels": "glabels(lv);",
    "hit": "if(!best)best=areaHit(x,y);",
    "tip": "if(h[0]==='a')return areaTip(h[1],h[2]);",
    "pick": "groundLists(i);",
    "click": "if(h[0]==='a')pickArea(h[1],false,h[2]);else ",
    "api": "window.pbAtlas.pickArea=pickArea;window.pbAtlas.pickIsland=pickIsland;window.pbAtlas.ground=G;\n",
    "hash": ("if(o.mg)layer.mground=o.mg==='1';if(o.pg)layer.pground=o.pg==='1';sync();"
             "if(o.area)GA.forEach(function(a,k){if(a.n===o.area)pickArea(k,true);});"
             "if(o.island)pickIsland(+o.island,true);"
             "if(o.zoom&&(o.area||o.island)){s=+o.zoom;var cx=o.cx!==undefined?+o.cx:wx(W/2),cy=o.cy!==undefined?+o.cy:wy(H/2);tx=W/2-s*cx;ty=H/2-s*cy;}\n"),
}


def _script(G):
    """JS with each marker spliced: the ground code when G, else nothing."""
    import re
    return re.sub(r"/\*G:(\w+)\*/", lambda m: GJS[m.group(1)] if G else "", JS)


def _legend(G=None):
    rows = [
        ("sw sw-grad", "closure, the share of a declaration's cone free of direct sorry: 0 red, 0.5 amber, 1 green"),
        ("sw sw-dot", "a theorem (circle)"),
        ("sw sw-sq", "a definition, instance or structure (square)"),
        ("sw sw-dia", "a root: uses no other Primebeat declaration"),
        ("sw sw-x", "a direct sorry in its type or value"),
        ("sw sw-ln", "a road: one declaration uses another, upstream to downstream (arrow at near zoom)"),
        ("sw sw-up", "on the selection: what it uses (upstream)"),
        ("sw sw-down", "on the selection: what uses it (downstream)"),
        ("sw sw-strip", "the critical strip 0 \u2264 Re s \u2264 1"),
        ("sw sw-crit", "the critical line Re s = 1/2"),
        ("sw sw-ln", "near zoom, faint and level: the Re s interval a statement bounds, its point at the middle"),
        ("sw sw-lane", "a lane: the statements with no bound on Re s, the units with no Lean ref, the margin"),
        ("sw sw-flag", "a unit, pinned by its refs: to a declaration, or in the units lane by date"),
        ("sw sw-cm", "commentary naming it (Commentary on); size grows with the count"),
        ("sw sw-cmo", "commentary naming its .lean file, at the file's first declaration"),
    ]
    if G:
        rows += [
            ("sw sw-mg", "Mathlib ground (toggle): terrain under the declarations naming a Mathlib area "
             "directly; an area rises with the number of islands standing on it; contour lines "
             "mark the levels; areas held by " + G["share"] + " of a project's islands are background "
             "there and drawn nowhere"),
            ("sw sw-pg", "PrimeNumberTheoremAnd ground (toggle): the same for PrimeNumberTheoremAnd"),
        ]
    return "".join(f'<div><span class="{c}"></span><span>{_e(t)}</span></div>' for c, t in rows)


def _ground_section(D):
    """The table of the island pairs sharing the most ground."""
    G = D["ground"]
    P, I, A = D["decls"], G["islands"], G["areas"]

    def isl(k):
        t = I[k]
        return (f'<a data-isl="{k}">island of {_e(P[t["top"]]["n"])}</a> '
                f'<span class="muted">{_e(D["scopes"][t["sc"]]["key"])}/, {len(t["m"])}</span>')

    rows = []
    for n, pr in enumerate(G["pairs"], 1):
        ia, ib = I[pr["a"]], I[pr["b"]]
        pins = (f'name match: Mathlib {_e(ia["pin"])} / {_e(ib["pin"])}' if pr["x"]
                else f'same Mathlib {_e(ia["pin"])}')
        shown = pr["ar"][:6]
        areas = ", ".join(f'<a data-area="{a}">{_e(A[a]["n"])}</a> {w:.2f}' for a, w in shown)
        more = f' <span class="muted">+ {len(pr["ar"]) - len(shown)} more</span>' if len(pr["ar"]) > 6 else ""
        rows.append(f'<tr><td class="n">{n}</td><td class="i">{isl(pr["a"])}</td><td class="i">{isl(pr["b"])}</td>'
                    f'<td class="n">{pr["w"]:.2f}</td><td class="n">{len(pr["ar"])}</td><td>{pins}</td><td>{areas}{more}</td></tr>')
    cnt = G["counts"]
    per = " \u00b7 ".join(
        f'{_e(k)}/ <b>{v["islands"]}</b> islands, Mathlib <b>{v["Mathlib"]["constants"]}</b> constants in '
        f'<b>{v["Mathlib"]["areas"]}</b> areas ({v["Mathlib"]["background_areas"]} background), '
        f'PrimeNumberTheoremAnd <b>{v["PrimeNumberTheoremAnd"]["constants"]}</b> in '
        f'<b>{v["PrimeNumberTheoremAnd"]["areas"]}</b> ({v["PrimeNumberTheoremAnd"]["background_areas"]} background)'
        for k, v in sorted(cnt.items()))
    return ('<section class="card"><h2>Shared ground: the island pairs standing on the most rare ground</h2>'
            f'<div class="counts">{per}</div>'
            '<p class="note">An island is a connected component of a project\'s own uses graph. Two islands '
            'share the Mathlib and PrimeNumberTheoremAnd areas both stand on, background in neither project, '
            'each weighted ln(islands / islands holding it). A larger island stands on more ground. lean/ and '
            'lean_stage3/ pin different Mathlib versions: ground shared across them is the same area name in '
            'two versions, marked name match. Click an island or an area to light it on the map.</p>'
            '<div class="tscroll"><table class="ground"><tr><th class="n">#</th><th>island</th><th>island</th>'
            '<th class="n">shared</th><th class="n">areas</th><th>Mathlib</th><th>heaviest shared areas (weight)</th></tr>'
            + "".join(rows) + '</table></div></section>\n')


def _ground_read(G):
    pins = "; ".join(f"{_e(k)}/: " + ", ".join(f"{_e(lib)} {_e(rev)}" for lib, rev in v.items())
                     for k, v in G["pins"].items())
    return ('<li>Ground: the Mathlib and PrimeNumberTheoremAnd constants a declaration\'s type and value '
            'name directly (atlas/Extract.lean), by area: the module path cut to three components '
            '(<code>Mathlib.NumberTheory.LSeries</code>), four under '
            '<code>PrimeNumberTheoremAnd.Mathlib</code>. Rarity is counted over a project\'s islands; '
            f'an area or constant held by {_e(G["share"])} of them is background there. '
            f'Pins: {pins}; a scratch file stands on the pins of the project it was built in. '
            'The rule is in atlas/model.py.</li>')


def render(D):
    C = D["counts"]
    per = " \u00b7 ".join(f"{k} <b>{v}</b>" for k, v in sorted(C["per_scope"].items()))
    counts = (
        f'<span>declarations <b>{C["declarations"]}</b> ({per})</span>'
        f'<span>roads <b>{C["roads"]}</b></span><span>roots <b>{C["roots"]}</b></span>'
        f'<span>direct sorry <b>{C["sorry"]}</b></span>'
        f'<span>closure below 1 <b>{C["closure_below_1"]}</b></span>'
        f'<span>on the strip <b>{C["on_strip"]}</b> / in the lane <b>{C["in_lane"]}</b></span>'
        f'<span>with a height bound <b>{C["with_height"]}</b></span>'
        f'<span>units pinned <b>{C["units_pinned"]}</b> / in the units lane <b>{C["units_in_lane"]}</b></span>'
        f'<span>commentary attached <b>{C["commentary_attached"]}</b> / margin <b>{C["commentary_margin"]}</b></span>'
        f'<span>gaps <b>{C["gaps"]}</b></span>')
    gaps = ""
    if D["gaps"]:
        rows = "".join(
            f"<tr><td><code>{_e(g['file'])}</code></td><td>"
            + "<br>".join(f"{_e(e['project'])}: <code>{_e(e['error'])}</code>" for e in g["errors"])
            + "</td></tr>" for g in D["gaps"])
        gaps = ('<section class="card"><h2>Gaps: files that build in neither project</h2>'
                '<p class="note">Each was compiled on its own with lean_stage3\'s toolchain, then lean\'s; '
                'the first error line of each attempt is kept. Its declarations are not on the map.</p>'
                f'<table class="gaps"><tr><th>file</th><th>first error</th></tr>{rows}</table></section>')
    scopes = "".join(f"<li>{_e(s['label'])}</li>" for s in D["scopes"])
    G = D.get("ground")
    style = CSS + (GCSS if G else "")
    toggles = ('\n<span class="grp">ground</span>'
               '\n<label><input type="checkbox" data-layer="mground"> Mathlib ground</label>'
               '\n<label><input type="checkbox" data-layer="pground"> PrimeNumberTheoremAnd ground</label>'
               if G else "")
    gsection = _ground_section(D) if G else ""
    gread = _ground_read(G) if G else ""
    return f"""<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Primebeat atlas</title>
<style>{style}</style></head>
<body><main>
<h1>Primebeat atlas</h1>
<p class="note">Two maps on one ground. The territory: every Lean declaration, read by Lean, on the critical
strip where its statement bounds Re s, else in the lane by its depth from the roots; the roads are its uses;
the flags are the units pinned by their refs. The commentary: every other committed text, on what it names.
An atlas relates; the time slider replays the order the territory was found.</p>
<div class="counts">{counts}</div>
<div class="bar"><span class="grp">maps</span>
<label><input type="checkbox" data-layer="territory" checked> territory</label>
<label><input type="checkbox" data-layer="commentary"> commentary</label>
<span class="grp">overlays</span>
<label><input type="checkbox" data-layer="strip" checked> strip</label>
<label><input type="checkbox" data-layer="closure" checked> closure</label>
<label><input type="checkbox" data-layer="roads" checked> roads</label>
<label><input type="checkbox" data-layer="units" checked> units</label>
<label><input type="checkbox" data-layer="labels" checked> names</label>{toggles}</div>
<form class="bar" id="find"><input type="text" id="q" placeholder="search a declaration name" aria-label="search a declaration name">
<button type="submit">find</button><button type="button" id="qclear">clear</button><span id="found"></span></form>
<div class="time"><button type="button" id="play" class="bar">replay</button>
<input type="range" id="cut" min="0" max="0" value="0" aria-label="first appearance up to"><span id="day"></span></div>
<div class="stage"><canvas id="map" aria-label="the atlas map"></canvas><div id="tip"></div>
<div id="zoombox"><button type="button" id="zin" aria-label="zoom in">+</button>
<button type="button" id="zout" aria-label="zoom out">\u2212</button>
<button type="button" id="zfit" aria-label="fit">\u2922</button></div>
<canvas id="minimap" aria-label="minimap"></canvas><div id="level"></div></div>
<section class="card" id="detail"><h2>Pick a point</h2><p class="muted">Click a declaration, a unit flag or a
margin square to open its section here.</p></section>
<section class="card"><h2>Legend</h2><div class="legend">{_legend(G)}</div></section>
{gsection}{gaps}
<section class="card"><h2>How it is read</h2><ul class="note">
<li>Projects: <ul>{scopes}</ul></li>
<li>Declarations: every constant of the project's own modules with a declaration range, not an internal detail,
recursor or notation parser; its uses are the project constants its type and value name, looking through
auxiliary constants such as <code>foo.proof_1</code> (atlas/Extract.lean).</li>
<li>Placement: literal bounds on <code>s.re</code>, <code>(↑ρ).re</code> or <code>σ</code>, sets
<code>Set.Ioo a b</code> and points <code>1 / 2 + ↑t * Complex.I</code>; the rule is in atlas/model.py.</li>
<li>Closure: the share of the cone (the declaration and all it reaches) free of direct sorry; 1 when none.</li>
<li>First appearance: the oldest committed version of its file containing its last name part.</li>
<li>Commentary: a text names a declaration by its full name or a distinctive unqualified part, a file by
<code>Name.lean</code>, a unit by its four-digit id.</li>{gread}</ul></section>
</main>
<script type="application/json" id="atlas-data">{_json_script(D)}</script>
<script>{_script(G)}</script>
</body></html>
"""
