const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });
  const page = await browser.newPage();
  await page.setViewport({ width: 1920, height: 1080 });
  await page.goto('http://localhost:8080/', { waitUntil: 'networkidle0' });
  
  await page.screenshot({ path: 'screenshot-fullpage.png', fullPage: true });
  
  await browser.close();
})();
