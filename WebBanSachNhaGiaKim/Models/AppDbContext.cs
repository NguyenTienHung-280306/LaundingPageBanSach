using Microsoft.EntityFrameworkCore;

namespace WebBanSachNhaGiaKim.Models;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<Book> Books => Set<Book>();
    public DbSet<JourneyStop> JourneyStops => Set<JourneyStop>();
    public DbSet<BlogPost> BlogPosts => Set<BlogPost>();
    public DbSet<Order> Orders => Set<Order>();

    protected override void OnModelCreating(ModelBuilder b)
    {
        // Khớp kiểu DECIMAL(18,0) đã tạo bằng SQL. Không dùng HasData vì dữ liệu đã có sẵn trong SQL Server.
        b.Entity<Book>().Property(x => x.Price).HasColumnType("decimal(18,0)");
        b.Entity<Book>().Property(x => x.OldPrice).HasColumnType("decimal(18,0)");
        b.Entity<Order>().Property(x => x.Total).HasColumnType("decimal(18,0)");
    }
}
