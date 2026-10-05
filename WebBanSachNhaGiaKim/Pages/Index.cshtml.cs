using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using WebBanSachNhaGiaKim.Models;

namespace WebBanSachNhaGiaKim.Pages;

public class IndexModel : PageModel
{
    private readonly AppDbContext _db;
    public IndexModel(AppDbContext db) => _db = db;

    public Book Book { get; private set; } = new();
    public List<JourneyStop> Stops { get; private set; } = new();
    public BlogPost? Featured { get; private set; }
    public List<BlogPost> Notes { get; private set; } = new();

    // Thống kê bán hàng hiển thị cho khách
    public int TotalSold { get; private set; }
    public int TotalOrders { get; private set; }
    public int RecentOrders { get; private set; }

    public async Task OnGetAsync()
    {
        Book = await _db.Books.AsNoTracking().FirstOrDefaultAsync() ?? new Book();

        Stops = await _db.JourneyStops.AsNoTracking()
            .OrderBy(s => s.SortOrder).ToListAsync();

        Featured = await _db.BlogPosts.AsNoTracking()
            .Where(p => p.IsFeatured)
            .OrderByDescending(p => p.PublishedAt)
            .FirstOrDefaultAsync();

        Notes = await _db.BlogPosts.AsNoTracking()
            .Where(p => !p.IsFeatured)
            .OrderByDescending(p => p.PublishedAt)
            .Take(3).ToListAsync();

        // Không tính đơn đã hủy
        var valid = _db.Orders.AsNoTracking().Where(o => o.Status != "Đã hủy");
        TotalOrders = await valid.CountAsync();
        TotalSold = await valid.SumAsync(o => (int?)o.Quantity) ?? 0;
        var since = DateTime.UtcNow.AddDays(-7);
        RecentOrders = await valid.CountAsync(o => o.CreatedAt >= since);
    }
}
