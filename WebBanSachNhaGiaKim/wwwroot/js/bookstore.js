// Biểu tượng chiêm tinh quanh bánh xe
const g = document.getElementById('glyphs');
[...'♈♉♊♋♌♍♎♏♐♑♒♓'].forEach((s, i) => {
  const a = i * Math.PI / 6, x = 300 + 253 * Math.sin(a), y = 300 - 253 * Math.cos(a) + 9;
  g.insertAdjacentHTML('beforeend', `<text x="${x}" y="${y}">${s}\uFE0E</text>`);
});

// Bụi vàng bay lên (dùng cho hero và phần review)
function dust(box, n) {
  for (let i = 0; i < n; i++) {
    const d = document.createElement('span'); d.className = 'dust';
    d.style.cssText = `left:${Math.random()*100}%;animation-duration:${8+Math.random()*10}s;animation-delay:${-Math.random()*14}s;transform:scale(${.5+Math.random()})`;
    box.appendChild(d);
  }
}
dust(document.getElementById('hero'), 22);
dust(document.querySelector('.blog'), 16);

// Sách 3D: kéo để xoay 360°, thả ra có quán tính, tự xoay khi không ai chạm
const stage = document.getElementById('stage'), book = document.getElementById('book'), shadow = document.querySelector('.shadow');
const autoBtn = document.getElementById('autoBtn');
const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches;
let ry = -28, rx = -8, vy = 0, targetY = null, dragging = false, lastX = 0, lastY = 0, idleAt = 0, auto = !reduce;
autoBtn.setAttribute('aria-pressed', auto);

stage.addEventListener('pointerdown', e => {
  if (e.target.closest('.ctrl')) return;
  dragging = true; targetY = null; lastX = e.clientX; lastY = e.clientY;
  stage.setPointerCapture(e.pointerId); stage.classList.add('grab');
});
stage.addEventListener('pointermove', e => {
  if (!dragging) return;
  const dx = e.clientX - lastX, dy = e.clientY - lastY; lastX = e.clientX; lastY = e.clientY;
  ry += dx * .6; vy = dx * .6;
  if (e.pointerType === 'mouse') rx = Math.max(-40, Math.min(25, rx - dy * .4));
});
const end = () => { dragging = false; idleAt = performance.now(); stage.classList.remove('grab'); };
stage.addEventListener('pointerup', end); stage.addEventListener('pointercancel', end);

// Nút xem nhanh: quay đến bìa trước / gáy / bìa sau theo đường ngắn nhất
document.querySelectorAll('.ctrl [data-ry]').forEach(btn => btn.addEventListener('click', () => {
  const want = +btn.dataset.ry, d = ((want - ry) % 360 + 540) % 360 - 180;
  targetY = ry + d; vy = 0; idleAt = performance.now() + 2000;
}));
autoBtn.addEventListener('click', () => { auto = !auto; autoBtn.setAttribute('aria-pressed', auto); });

stage.tabIndex = 0;
stage.addEventListener('keydown', e => {
  if (e.key === 'ArrowLeft') { targetY = ry - 45; idleAt = performance.now(); }
  if (e.key === 'ArrowRight') { targetY = ry + 45; idleAt = performance.now(); }
});

function tick(now) {
  if (!dragging) {
    if (targetY !== null) { ry += (targetY - ry) * .1; if (Math.abs(targetY - ry) < .2) { ry = targetY; targetY = null; } }
    else if (Math.abs(vy) > .02) { ry += vy; vy *= .95; }
    else if (auto && now - idleAt > 1500) ry += .25;
    rx += (-8 - rx) * .03;
  }
  const rad = ry * Math.PI / 180;
  book.style.setProperty('--ry', ry + 'deg'); book.style.setProperty('--rx', rx + 'deg');
  book.style.setProperty('--mx', (50 + Math.sin(rad) * 55) + '%');
  shadow.style.width = (150 + 100 * Math.abs(Math.cos(rad))) + 'px';
  requestAnimationFrame(tick);
}
requestAnimationFrame(tick);

// Các chặng hiện lần lượt khi cuộn
const io = new IntersectionObserver(es => es.forEach(e => e.isIntersecting && e.target.classList.add('in')), {threshold:.2});
document.querySelectorAll('.stop,.rv').forEach(el => io.observe(el));

// Nghiêng 3D cho ảnh review và các thẻ ghi chú
const tilt = (el, max, base = '') => {
  el.addEventListener('pointermove', e => {
    if (e.pointerType === 'touch') return;
    const r = el.getBoundingClientRect(), x = (e.clientX - r.left) / r.width - .5, y = (e.clientY - r.top) / r.height - .5;
    el.style.transform = `perspective(1000px) rotateX(${-y * max}deg) rotateY(${x * max}deg)${base}`;
  });
  el.addEventListener('pointerleave', () => el.style.transform = '');
};
tilt(document.getElementById('shot'), 9);
document.querySelectorAll('.tl').forEach(el => tilt(el, 12, ' rotate(var(--rot))'));

// Số liệu bán hàng chạy từ 0 đến giá trị thật khi cuộn tới
const counters = document.querySelectorAll('[data-count]');
const countIO = new IntersectionObserver(es => es.forEach(e => {
  if (!e.isIntersecting) return;
  countIO.unobserve(e.target);
  const el = e.target, end = +el.dataset.count, t0 = performance.now(), dur = 1600;
  if (reduce || end === 0) return;
  const step = now => {
    const k = Math.min((now - t0) / dur, 1), v = Math.round(end * (1 - Math.pow(1 - k, 3)));
    el.textContent = v.toLocaleString('vi-VN');
    if (k < 1) requestAnimationFrame(step);
  };
  requestAnimationFrame(step);
}), { threshold: .6 });
counters.forEach(el => countIO.observe(el));
