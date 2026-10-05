IF DB_ID(N'NhaGiaKimDb') IS NULL
    CREATE DATABASE NhaGiaKimDb COLLATE Vietnamese_CI_AS;
GO
 
USE NhaGiaKimDb;
GO
 
/* ---------------------------- BẢNG ---------------------------- */
 
IF OBJECT_ID(N'dbo.Books', N'U') IS NULL
CREATE TABLE dbo.Books (
    Id          INT IDENTITY(1,1) PRIMARY KEY,
    Title       NVARCHAR(200)  NOT NULL,
    Author      NVARCHAR(200)  NOT NULL,
    Translator  NVARCHAR(200)  NULL,
    Publisher   NVARCHAR(200)  NULL,
    Pages       INT            NOT NULL DEFAULT 0,
    Price       DECIMAL(18,0)  NOT NULL,
    OldPrice    DECIMAL(18,0)  NULL,
    Description NVARCHAR(MAX)  NOT NULL DEFAULT N'',
    Quote       NVARCHAR(MAX)  NOT NULL DEFAULT N'',
    CoverImage  NVARCHAR(300)  NOT NULL DEFAULT N'',
    BackImage   NVARCHAR(300)  NULL
);
GO
 
IF OBJECT_ID(N'dbo.JourneyStops', N'U') IS NULL
CREATE TABLE dbo.JourneyStops (
    Id          INT IDENTITY(1,1) PRIMARY KEY,
    SortOrder   INT            NOT NULL,
    Name        NVARCHAR(200)  NOT NULL,
    Description NVARCHAR(500)  NOT NULL
);
GO
 
IF OBJECT_ID(N'dbo.BlogPosts', N'U') IS NULL
CREATE TABLE dbo.BlogPosts (
    Id            INT IDENTITY(1,1) PRIMARY KEY,
    Tag           NVARCHAR(50)   NOT NULL,
    Title         NVARCHAR(300)  NOT NULL,
    Excerpt       NVARCHAR(600)  NOT NULL,
    Content       NVARCHAR(MAX)  NOT NULL DEFAULT N'',
    Image         NVARCHAR(300)  NOT NULL DEFAULT N'',
    ReadMinutes   INT            NOT NULL DEFAULT 3,
    PublishedAt   DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME(),
    IsFeatured    BIT            NOT NULL DEFAULT 0,
    Author        NVARCHAR(100)  NOT NULL DEFAULT N'',
    ScoreInspire  FLOAT NULL,
    ScoreStyle    FLOAT NULL,
    ScoreDepth    FLOAT NULL,
    ScoreReadable FLOAT NULL
);
GO
 
IF OBJECT_ID(N'dbo.Orders', N'U') IS NULL
CREATE TABLE dbo.Orders (
    Id           INT IDENTITY(1,1) PRIMARY KEY,
    BookId       INT            NOT NULL REFERENCES dbo.Books(Id),
    CustomerName NVARCHAR(200)  NOT NULL,
    Phone        NVARCHAR(20)   NOT NULL,
    Address      NVARCHAR(500)  NOT NULL,
    Quantity     INT            NOT NULL DEFAULT 1 CHECK (Quantity > 0),
    Total        DECIMAL(18,0)  NOT NULL,
    Status       NVARCHAR(30)   NOT NULL DEFAULT N'Mới',
    CreatedAt    DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME()
);
GO
 
/* ------------------------ DỮ LIỆU MẪU ------------------------- */
 
-- 1 cuốn sách
IF NOT EXISTS (SELECT 1 FROM dbo.Books)
INSERT INTO dbo.Books (Title, Author, Translator, Publisher, Pages, Price, OldPrice, Description, Quote, CoverImage, BackImage)
VALUES (
    N'Nhà Giả Kim',
    N'Paulo Coelho',
    N'Lê Chu Cầu',
    N'NXB Văn Học',
    228,
    79000,
    99000,
    N'Hành trình của cậu bé chăn cừu Santiago băng qua sa mạc để tìm kho báu, và tìm ra điều quan trọng hơn: lắng nghe trái tim mình.',
    N'Hãy lắng nghe trái tim của bạn. Nó biết mọi thứ, vì nó đến từ Tâm hồn thế giới, và một ngày nào đó nó sẽ trở lại đó.',
    N'/img/nha-gia-kim.jpg',
    N'/img/nha-gia-kim-back.jpg'
);
GO
 
-- 4 chặng đường
IF NOT EXISTS (SELECT 1 FROM dbo.JourneyStops)
INSERT INTO dbo.JourneyStops (SortOrder, Name, Description) VALUES
(1, N'Andalusia',     N'Cánh đồng cừu và giấc mơ lặp đi lặp lại về kho báu bên kim tự tháp.'),
(2, N'Tangier',       N'Mất sạch tiền bạc, và học cách bắt đầu lại từ con số không.'),
(3, N'Sa mạc Sahara', N'Gặp nhà giả kim, học cách đọc những dấu hiệu và ngôn ngữ của thế giới.'),
(4, N'Kim tự tháp',   N'Điểm đến cuối cùng, nơi câu hỏi “kho báu là gì” có lời đáp.');
GO
 
-- 4 bài blog: 1 bài nổi bật + 3 ghi chú
IF NOT EXISTS (SELECT 1 FROM dbo.BlogPosts)
INSERT INTO dbo.BlogPosts
    (Tag, Title, Excerpt, Content, Image, ReadMinutes, PublishedAt, IsFeatured, Author,
     ScoreInspire, ScoreStyle, ScoreDepth, ScoreReadable)
VALUES
(
    N'Review dài',
    N'Vì sao câu chuyện về một cậu bé chăn cừu vẫn khiến ta đọc lại?',
    N'Có những cuốn sách đọc một lần rồi cất lên kệ, và có những cuốn mỗi lần mở lại thấy một tầng nghĩa khác. Nhà Giả Kim thuộc nhóm thứ hai.',
    N'Có những cuốn sách đọc một lần rồi cất lên kệ, và có những cuốn mỗi lần mở lại thấy một tầng nghĩa khác. Nhà Giả Kim thuộc nhóm thứ hai. Lần đầu, bạn đọc nó như một chuyến phiêu lưu qua sa mạc. Lần sau, bạn nhận ra mình đang đọc về chính những lần do dự trước một ngã rẽ.
 
Sức hút của cuốn sách nằm ở sự giản dị: câu chữ ngắn, nhịp kể chậm, và mỗi chặng đường đều để lại một câu hỏi thay vì một lời khuyên làm sẵn.
 
Cuốn sách không dạy bạn cách tìm kho báu. Nó nhắc bạn lắng nghe chính mình trước khi lên đường.',
    N'/img/nha-gia-kim-banner.jpg',
    6, '2026-09-28', 1, N'Minh Anh',
    5.0, 4.5, 4.5, 5.0
),
(
    N'Cảm nhận',
    N'Hai mươi tuổi và ba mươi tuổi: hai lần đọc, hai cuốn sách khác nhau',
    N'Ở tuổi hai mươi, ta đọc để tìm can đảm lên đường. Ở tuổi ba mươi, ta đọc để hiểu vì sao mình từng chùn bước.',
    N'Ở tuổi hai mươi, ta đọc để tìm can đảm lên đường. Ở tuổi ba mươi, ta đọc để hiểu vì sao mình từng chùn bước.
 
Cùng một cuốn sách, nhưng điều đọng lại khác nhau tùy vào những gì ta đã đi qua. Có lẽ đó là lý do Nhà Giả Kim nên được đọc lại sau mỗi vài năm.',
    N'/img/dong-ho-cat.jpg',
    4, '2026-09-20', 0, N'Khánh Linh',
    NULL, NULL, NULL, NULL
),
(
    N'Chủ đề',
    N'Điềm báo: điều Santiago học được từ sa mạc',
    N'Từ cánh chim bay ngang đến một người lạ xuất hiện đúng lúc, những dấu hiệu nhỏ xếp thành tấm bản đồ riêng của mỗi người.',
    N'Từ cánh chim bay ngang đến một người lạ xuất hiện đúng lúc, những dấu hiệu nhỏ xếp thành tấm bản đồ riêng của mỗi người.
 
Santiago không có tấm bản đồ nào ngoài những dấu hiệu nhỏ trên đường đi. Học cách nhận ra chúng, và đủ can đảm để tin vào chúng, là một nửa của hành trình.',
    N'/img/ban-do.jpg',
    5, '2026-09-12', 0, N'Hoàng Nam',
    NULL, NULL, NULL, NULL
),
(
    N'Góc nhìn',
    N'Văn phong giản dị vì sao lại ở lại trong trí nhớ lâu đến vậy',
    N'Vài chỗ nên đọc chậm, vài chỗ nên dừng lại, và lý do những câu văn ngắn lại đi xa hơn ta tưởng.',
    N'Vài chỗ nên đọc chậm, vài chỗ nên dừng lại, và lý do những câu văn ngắn lại đi xa hơn ta tưởng.
 
Câu văn ngắn, hình ảnh rõ ràng và nhịp kể chậm khiến cuốn sách dễ đọc với người mới, nhưng vẫn đủ chỗ để người đọc lâu năm dừng lại suy ngẫm.',
    N'/img/qua-cau.jpg',
    3, '2026-09-05', 0, N'Minh Anh',
    NULL, NULL, NULL, NULL
);
GO
 
/* ------------------------- KIỂM TRA --------------------------- */
SELECT * FROM dbo.Books;
SELECT * FROM dbo.JourneyStops ORDER BY SortOrder;
SELECT Id, Tag, Title, IsFeatured, PublishedAt FROM dbo.BlogPosts ORDER BY PublishedAt DESC;

--sửa--
UPDATE dbo.Books
SET CoverImage = REPLACE(REPLACE(CoverImage, N'/images/blog/', N'/img/'), N'/images/', N'/img/'),
    BackImage  = REPLACE(REPLACE(BackImage,  N'/images/blog/', N'/img/'), N'/images/', N'/img/');
 
UPDATE dbo.BlogPosts
SET Image = REPLACE(REPLACE(Image, N'/images/blog/', N'/img/'), N'/images/', N'/img/');
GO
 
SELECT Id, Title, CoverImage, BackImage FROM dbo.Books;
SELECT Id, Title, Image FROM dbo.BlogPosts;
 