using System.ComponentModel.DataAnnotations;
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using WebBanSachNhaGiaKim.Models;

namespace WebBanSachNhaGiaKim.Pages;

public class CheckoutModel : PageModel
{
    private readonly AppDbContext _db;
    public CheckoutModel(AppDbContext db) => _db = db;

    public Book Book { get; private set; } = new();

    [BindProperty]
    public InputModel Input { get; set; } = new();

    public class InputModel
    {
        [Required(ErrorMessage = "Vui lòng nhập họ và tên")]
        [StringLength(100, MinimumLength = 2, ErrorMessage = "Họ tên từ 2 đến 100 ký tự")]
        public string CustomerName { get; set; } = "";

        [Required(ErrorMessage = "Vui lòng nhập số điện thoại")]
        [RegularExpression(@"^(\+84|0)[0-9 .-]{9,13}$", ErrorMessage = "Số điện thoại chưa đúng, ví dụ 0901234567")]
        public string Phone { get; set; } = "";

        [Required(ErrorMessage = "Vui lòng nhập địa chỉ giao hàng")]
        [StringLength(300, MinimumLength = 10, ErrorMessage = "Hãy ghi rõ số nhà, đường, phường/xã, tỉnh/thành")]
        public string Address { get; set; } = "";

        [Range(1, 20, ErrorMessage = "Số lượng từ 1 đến 20")]
        public int Quantity { get; set; } = 1;
    }

    public async Task<IActionResult> OnGetAsync(int qty = 1)
    {
        var book = await _db.Books.AsNoTracking().FirstOrDefaultAsync();
        if (book is null) return NotFound();
        Book = book;
        Input.Quantity = Math.Clamp(qty, 1, 20);
        return Page();
    }

    public async Task<IActionResult> OnPostAsync()
    {
        var book = await _db.Books.AsNoTracking().FirstOrDefaultAsync();
        if (book is null) return NotFound();
        Book = book;

        if (!ModelState.IsValid) return Page();

        var order = new Order
        {
            BookId = book.Id,
            CustomerName = Input.CustomerName.Trim(),
            Phone = Regex.Replace(Input.Phone, @"[^\d+]", ""),
            Address = Input.Address.Trim(),
            Quantity = Input.Quantity,
            Total = book.Price * Input.Quantity,   // giá luôn tính ở server, không tin dữ liệu từ trình duyệt
            Status = "Mới",
            CreatedAt = DateTime.UtcNow
        };
        _db.Orders.Add(order);
        await _db.SaveChangesAsync();

        TempData["OrderId"] = order.Id.ToString();
        return RedirectToPage("ThanhCong");
    }
}
