// Trang thanh toán: tăng giảm số lượng, tính lại tổng tiền, chống bấm đặt hàng hai lần
(() => {
  const form = document.getElementById('coForm');
  if (form) {
    const price = +document.getElementById('receipt').dataset.price;
    const qtyInput = document.getElementById('Input_Quantity');
    const qVal = document.getElementById('qVal');
    const total = document.getElementById('total');
    const fmt = n => new Intl.NumberFormat('vi-VN').format(n) + '₫';
    const set = q => {
      q = Math.max(1, Math.min(20, q));
      qtyInput.value = q; qVal.textContent = q; total.textContent = fmt(price * q);
    };
    document.getElementById('qMinus').onclick = () => set(+qtyInput.value - 1);
    document.getElementById('qPlus').onclick = () => set(+qtyInput.value + 1);
    set(+qtyInput.value || 1);

    form.addEventListener('submit', () => {
      const btn = document.getElementById('submitBtn');
      btn.disabled = true; btn.textContent = 'Đang xử lý…';
    });
  }

  // Bụi vàng bay trên trang thành công
  const ok = document.querySelector('.ok');
  if (ok && !matchMedia('(prefers-reduced-motion: reduce)').matches) {
    const box = ok.closest('.co');
    for (let i = 0; i < 18; i++) {
      const d = document.createElement('span'); d.className = 'dust';
      d.style.cssText = `left:${Math.random()*100}%;animation-duration:${7+Math.random()*9}s;animation-delay:${-Math.random()*12}s;transform:scale(${.5+Math.random()})`;
      box.appendChild(d);
    }
  }
})();
