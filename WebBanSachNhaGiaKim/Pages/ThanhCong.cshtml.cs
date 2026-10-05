using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using WebBanSachNhaGiaKim.Models;

namespace WebBanSachNhaGiaKim.Pages;

public class ThanhCongModel : PageModel
{
    private readonly AppDbContext _db;
    public ThanhCongModel(AppDbContext db) => _db = db;

    public Order? Order { get; private set; }
    public string OrderCode => Order is null ? "" : $"NGK{Order.Id:D5}";
    public DateTime CreatedLocal => Order is null ? default : Order.CreatedAt.AddHours(7);   // giờ Việt Nam
    public string MaskedPhone => Order is null || Order.Phone.Length < 4 ? "" : new string('•', Order.Phone.Length - 3) + Order.Phone[^3..];

    public async Task<IActionResult> OnGetAsync()
    {
        // Chỉ người vừa đặt hàng (cùng trình duyệt) mới xem được trang này, người khác không đoán được mã đơn
        if (!int.TryParse(TempData.Peek("OrderId") as string, out var id))
            return RedirectToPage("Index");

        Order = await _db.Orders.AsNoTracking().Include(o => o.Book).FirstOrDefaultAsync(o => o.Id == id);
        if (Order is null) return RedirectToPage("Index");
        return Page();
    }
}
