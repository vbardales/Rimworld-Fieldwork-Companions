// Run with Node, playwright and sharp available (NODE_PATH may point to bundled packages).
const fs=require('fs'), path=require('path'), http=require('http');
const {chromium}=require('playwright'), sharp=require('sharp');
const root=path.resolve(__dirname,'..');
const palette=JSON.parse(fs.readFileSync(path.join(__dirname,'preview-palette.json')));
const rgb=h=>h.match(/\w\w/g).map(v=>parseInt(v,16));
const luminance=c=>c.map(v=>{v/=255;return v<=.04045?v/12.92:((v+.055)/1.055)**2.4}).reduce((s,v,i)=>s+v*[.2126,.7152,.0722][i],0);
const contrast=(a,b)=>{a=luminance(a);b=luminance(b);return (Math.max(a,b)+.05)/(Math.min(a,b)+.05)};
(async()=>{
 const server=http.createServer((req,res)=>{
  const file=path.resolve(root,'.'+decodeURIComponent(req.url.split('?')[0]));
  if(!file.startsWith(root+path.sep)){res.writeHead(403).end();return;}
  fs.readFile(file,(err,data)=>{if(err){res.writeHead(404).end();return;}res.setHeader('Content-Type',({'.html':'text/html','.json':'application/json','.png':'image/png','.xml':'text/xml'})[path.extname(file)]||'text/plain');res.end(data);});
 });
 await new Promise(r=>server.listen(0,'127.0.0.1',r));
 let browser;
 try {
  browser=await chromium.launch({executablePath:process.env.CHROME_PATH||'C:/Program Files/Google/Chrome/Application/chrome.exe',headless:true});
  const page=await browser.newPage({viewport:{width:896,height:504},deviceScaleFactor:1});
  await page.goto(`http://127.0.0.1:${server.address().port}/Art/preview.html`);
  await page.evaluate(()=>window.ready);
  const cdp=await page.context().newCDPSession(page);await cdp.send('DOM.enable');await cdp.send('CSS.enable');
  const {root:doc}=await cdp.send('DOM.getDocument');
  const report={dimensions:[896,504],fonts:{},boxes:{},contrast:{},tag:'not applicable: original public mod'};
  for(const sel of ['h1','.summary','.version']){
   const {nodeId}=await cdp.send('DOM.querySelector',{nodeId:doc.nodeId,selector:sel});
   report.fonts[sel]=(await cdp.send('CSS.getPlatformFontsForNode',{nodeId})).fonts;
   report.boxes[sel]=await page.locator(sel).boundingBox();
  }
  report.version=await page.locator('.version').innerText();
  const final=await page.screenshot();
  await sharp(final).png({compressionLevel:9}).toFile(path.join(root,'Mod/About/Preview.png'));
  await sharp(final).resize(268).png().toFile(path.join(__dirname,'preview-268.png'));
  await page.evaluate(()=>document.body.classList.add('background-only'));
  const background=await page.screenshot();
  await sharp(background).png().toFile(path.join(__dirname,'preview-background.png'));
  const {data,info}=await sharp(background).removeAlpha().raw().toBuffer({resolveWithObject:true});
  for(const sel of ['h1','.summary']){
   const b=report.boxes[sel];let min=Infinity,point;
   for(let y=Math.floor(b.y);y<Math.ceil(b.y+b.height);y++)for(let x=Math.floor(b.x);x<Math.ceil(b.x+b.width);x++){
    const i=(y*info.width+x)*3,c=contrast(rgb(palette.inkPrimary),[data[i],data[i+1],data[i+2]]);
    if(c<min){min=c;point=[x,y];}
   }
   report.contrast[sel]={minimum:min,point,method:'all pixels across text bounding rectangle on rendered background without text'};
   if(min<4.5)throw Error(sel+' contrast below 4.5: '+min);
  }
  report.contrast.badge=contrast(rgb(palette.badgeInk),rgb(palette.accent));
  if(report.contrast.badge<4.5)throw Error('Badge contrast below 4.5');
  report.bytes=fs.statSync(path.join(root,'Mod/About/Preview.png')).size;
  if(report.bytes>=900000)throw Error('Preview exceeds 900 kB');
  fs.writeFileSync(path.join(__dirname,'preview-qa.json'),JSON.stringify(report,null,2)+'\n');
  console.log(JSON.stringify(report,null,2));
 } finally {if(browser)await browser.close();server.close();}
})().catch(e=>{console.error(e);process.exitCode=1});
