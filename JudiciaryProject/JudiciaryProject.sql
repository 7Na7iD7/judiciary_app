USE master;
GO

-- حذف دیتابیس قبلی در صورت وجود
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'JudiciaryProject')
BEGIN
    ALTER DATABASE JudiciaryProject SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE JudiciaryProject;
END
GO

-- ایجاد پایگاه داده دادگستری
CREATE DATABASE JudiciaryProject;
GO

USE JudiciaryProject;
GO

-- جدول دادستان‌ها
CREATE TABLE Prosecutors (
    ProsecutorID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    NationalCode VARCHAR(10) NOT NULL UNIQUE,
    Phone VARCHAR(11),
    Email VARCHAR(50),
    Specialty NVARCHAR(100), -- تخصص (کیفری، حقوقی، خانواده و غیره)
    LicenseNumber VARCHAR(20) UNIQUE
);
GO

-- جدول دادگاه‌ها
CREATE TABLE Courts (
    CourtID INT IDENTITY(1,1) PRIMARY KEY,
    CourtName NVARCHAR(100) NOT NULL,
    CourtType NVARCHAR(50), -- نوع دادگاه (کیفری، حقوقی، انقلاب و غیره)
    Address NVARCHAR(200),
    Phone VARCHAR(11)
);
GO

-- جدول پرونده‌ها
CREATE TABLE Cases (
    CaseID INT IDENTITY(1,1) PRIMARY KEY,
    CaseNumber VARCHAR(50) NOT NULL UNIQUE,
    CaseTitle NVARCHAR(200) NOT NULL,
    CourtID INT NOT NULL,
    ProsecutorID INT NOT NULL,
    CaseType NVARCHAR(50), -- نوع پرونده (کیفری، حقوقی، خانواده و غیره)
    RegisterDate DATETIME DEFAULT GETDATE(),
    CaseStatus NVARCHAR(50) DEFAULT N'در جریان', -- وضعیت (در جریان، بسته شده، معلق و غیره)
    Description NVARCHAR(500),

    CONSTRAINT FK_Cases_Courts
    FOREIGN KEY (CourtID) REFERENCES Courts(CourtID),

    CONSTRAINT FK_Cases_Prosecutors
    FOREIGN KEY (ProsecutorID) REFERENCES Prosecutors(ProsecutorID)
);
GO

-- جدول متهمان/شاکیان
CREATE TABLE Persons (
    PersonID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    NationalCode VARCHAR(10) NOT NULL UNIQUE,
    Phone VARCHAR(11),
    Address NVARCHAR(200),
    PersonType NVARCHAR(50) -- نوع شخص (متهم، شاکی، شاهد و غیره)
);
GO

-- جدول ارتباط اشخاص با پرونده‌ها
CREATE TABLE CasePersons (
    CasePersonID INT IDENTITY(1,1) PRIMARY KEY,
    CaseID INT NOT NULL,
    PersonID INT NOT NULL,
    Role NVARCHAR(50), -- نقش در پرونده (متهم، شاکی، شاهد، وکیل و غیره)
    JoinDate DATETIME DEFAULT GETDATE(),
    Notes NVARCHAR(500),

    CONSTRAINT FK_CasePersons_Cases
    FOREIGN KEY (CaseID) REFERENCES Cases(CaseID),

    CONSTRAINT FK_CasePersons_Persons
    FOREIGN KEY (PersonID) REFERENCES Persons(PersonID),

    CONSTRAINT UQ_Case_Person_Role
    UNIQUE (CaseID, PersonID, Role)
);
GO

-- جدول جلسات دادرسی
CREATE TABLE Hearings (
    HearingID INT IDENTITY(1,1) PRIMARY KEY,
    CaseID INT NOT NULL,
    HearingDate DATETIME NOT NULL,
    HearingType NVARCHAR(50), -- نوع جلسه (رسیدگی، صدور حکم، استماع شهود و غیره)
    Result NVARCHAR(500), -- نتیجه جلسه
    NextHearingDate DATETIME,

    CONSTRAINT FK_Hearings_Cases
    FOREIGN KEY (CaseID) REFERENCES Cases(CaseID)
);
GO

-- درج داده‌های نمونه - دادگاه‌ها
INSERT INTO Courts (CourtName, CourtType, Address, Phone) VALUES
(N'دادگاه کیفری یک تهران', N'کیفری', N'تهران، خیابان آزادی', '02112345678'),
(N'دادگاه حقوقی شعبه ۵', N'حقوقی', N'تهران، میدان ونک', '02112345679'),
(N'دادگاه خانواده شعبه ۲', N'خانواده', N'تهران، خیابان ولیعصر', '02112345680'),
(N'دادگاه انقلاب اسلامی', N'انقلاب', N'تهران، خیابان پاسداران', '02112345681'),
(N'دادگاه عمومی کرج', N'عمومی', N'کرج، بلوار شهید بهشتی', '02634567890');
GO

-- درج داده‌های نمونه - دادستان‌ها
INSERT INTO Prosecutors (FullName, NationalCode, Phone, Email, Specialty, LicenseNumber) VALUES
(N'دکتر محمد رضایی', '0012345678', '09121234567', 'rezaei@judiciary.ir', N'کیفری', 'P-12345'),
(N'دکتر فاطمه احمدی', '0012345679', '09121234568', 'ahmadi@judiciary.ir', N'حقوقی', 'P-12346'),
(N'دکتر علی کریمی', '0012345680', '09121234569', 'karimi@judiciary.ir', N'خانواده', 'P-12347'),
(N'دکتر سارا محمدی', '0012345681', '09121234570', 'mohammadi@judiciary.ir', N'اقتصادی', 'P-12348'),
(N'دکتر حسین صادقی', '0012345682', '09121234571', 'sadeghi@judiciary.ir', N'کیفری', 'P-12349');
GO

-- درج داده‌های نمونه - پرونده‌ها
INSERT INTO Cases (CaseNumber, CaseTitle, CourtID, ProsecutorID, CaseType, RegisterDate, CaseStatus, Description) VALUES
('1403-1234', N'پرونده سرقت مسلحانه', 1, 1, N'کیفری', GETDATE(), N'در جریان', N'سرقت از یک فروشگاه طلا'),
('1403-1235', N'پرونده اختلاس مالی', 1, 5, N'کیفری', GETDATE(), N'در جریان', N'اختلاس از حساب شرکت'),
('1403-1236', N'پرونده طلاق توافقی', 3, 3, N'خانواده', GETDATE(), N'در حال بررسی', N'درخواست طلاق با رضایت طرفین'),
('1403-1237', N'پرونده دعوای ملکی', 2, 2, N'حقوقی', GETDATE(), N'در جریان', N'اختلاف بر سر مالکیت زمین'),
('1403-1238', N'پرونده تصادف رانندگی', 1, 1, N'کیفری', GETDATE(), N'معلق', N'تصادف منجر به فوت'),
('1403-1239', N'پرونده کلاهبرداری اینترنتی', 1, 5, N'کیفری', GETDATE(), N'در جریان', N'کلاهبرداری از طریق سایت'),
('1403-1240', N'پرونده چک بلامحل', 2, 2, N'حقوقی', GETDATE(), N'بسته شده', N'عدم پرداخت چک'),
('1403-1241', N'پرونده حضانت فرزند', 3, 3, N'خانواده', GETDATE(), N'در حال بررسی', N'اختلاف بر سر حضانت کودک');
GO

-- درج داده‌های نمونه - اشخاص
INSERT INTO Persons (FullName, NationalCode, Phone, Address, PersonType) VALUES
(N'رضا احمدزاده', '1234567890', '09131234567', N'تهران، خیابان انقلاب', N'متهم'),
(N'مریم کاظمی', '1234567891', '09131234568', N'تهران، خیابان شریعتی', N'شاکی'),
(N'امیر حسینی', '1234567892', '09131234569', N'تهران، میدان تجریش', N'متهم'),
(N'نرگس مرادی', '1234567893', '09131234570', N'کرج، بلوار طالقانی', N'شاکی'),
(N'حسن رضوی', '1234567894', '09131234571', N'تهران، خیابان فردوسی', N'شاهد'),
(N'زهرا صفری', '1234567895', '09131234572', N'تهران، میدان آزادی', N'شاکی'),
(N'علی نوری', '1234567896', '09131234573', N'تهران، خیابان ولیعصر', N'متهم'),
(N'فاطمه جعفری', '1234567897', '09131234574', N'تهران، خیابان پاسداران', N'وکیل'),
(N'محمد عباسی', '1234567898', '09131234575', N'تهران، میدان ونک', N'متهم'),
(N'سمیرا قاسمی', '1234567899', '09131234576', N'کرج، خیابان شهید بهشتی', N'شاکی');
GO

-- درج داده‌های نمونه - ارتباط اشخاص با پرونده‌ها
INSERT INTO CasePersons (CaseID, PersonID, Role, JoinDate, Notes) VALUES
(1, 1, N'متهم اصلی', GETDATE(), N'متهم ردیف اول'),
(1, 2, N'شاکی', GETDATE(), N'مالک فروشگاه'),
(1, 5, N'شاهد', GETDATE(), N'شاهد عینی واقعه'),
(2, 3, N'متهم', GETDATE(), N'کارمند سابق شرکت'),
(2, 4, N'شاکی', GETDATE(), N'مدیر شرکت'),
(3, 6, N'شاکی', GETDATE(), N'همسر درخواست کننده طلاق'),
(3, 7, N'متهم', GETDATE(), N'طرف مقابل دعوا'),
(4, 8, N'وکیل', GETDATE(), N'وکیل خواهان'),
(5, 9, N'متهم', GETDATE(), N'راننده مقصر'),
(5, 10, N'شاکی', GETDATE(), N'خانواده متوفی');
GO

-- درج داده‌های نمونه - جلسات دادرسی
INSERT INTO Hearings (CaseID, HearingDate, HearingType, Result, NextHearingDate) VALUES
(1, DATEADD(DAY, -10, GETDATE()), N'رسیدگی اولیه', N'احضار شهود', DATEADD(DAY, 15, GETDATE())),
(1, DATEADD(DAY, -5, GETDATE()), N'استماع شهود', N'تکمیل پرونده', DATEADD(DAY, 20, GETDATE())),
(2, DATEADD(DAY, -7, GETDATE()), N'رسیدگی', N'درخواست کارشناسی', DATEADD(DAY, 30, GETDATE())),
(3, DATEADD(DAY, -3, GETDATE()), N'جلسه صلح', N'عدم توافق طرفین', DATEADD(DAY, 25, GETDATE())),
(4, DATEADD(DAY, -12, GETDATE()), N'رسیدگی', N'ارجاع به کارشناس', DATEADD(DAY, 40, GETDATE())),
(7, DATEADD(DAY, -20, GETDATE()), N'صدور حکم', N'محکومیت متهم', NULL);
GO

-- ویو جزئیات پرونده‌ها
CREATE VIEW vw_CaseDetails AS
SELECT 
    C.CaseID,
    C.CaseNumber,
    C.CaseTitle,
    C.CaseType,
    C.CaseStatus,
    C.RegisterDate,
    Co.CourtName,
    Co.CourtType,
    P.FullName AS ProsecutorName,
    P.Specialty AS ProsecutorSpecialty,
    C.Description
FROM Cases C
INNER JOIN Courts Co ON C.CourtID = Co.CourtID
INNER JOIN Prosecutors P ON C.ProsecutorID = P.ProsecutorID;
GO

-- ویو جزئیات اشخاص در پرونده‌ها
CREATE VIEW vw_CasePersonsDetails AS
SELECT 
    CP.CasePersonID,
    C.CaseNumber,
    C.CaseTitle,
    P.FullName AS PersonName,
    P.NationalCode,
    P.Phone,
    CP.Role,
    CP.JoinDate,
    CP.Notes
FROM CasePersons CP
INNER JOIN Cases C ON CP.CaseID = C.CaseID
INNER JOIN Persons P ON CP.PersonID = P.PersonID;
GO

-- ویو جزئیات جلسات دادرسی
CREATE VIEW vw_HearingDetails AS
SELECT 
    H.HearingID,
    C.CaseNumber,
    C.CaseTitle,
    H.HearingDate,
    H.HearingType,
    H.Result,
    H.NextHearingDate,
    Co.CourtName,
    P.FullName AS ProsecutorName
FROM Hearings H
INNER JOIN Cases C ON H.CaseID = C.CaseID
INNER JOIN Courts Co ON C.CourtID = Co.CourtID
INNER JOIN Prosecutors P ON C.ProsecutorID = P.ProsecutorID;
GO

-- پروسیجر ثبت پرونده جدید
CREATE PROCEDURE sp_RegisterNewCase
    @CaseNumber VARCHAR(50),
    @CaseTitle NVARCHAR(200),
    @CourtID INT,
    @ProsecutorID INT,
    @CaseType NVARCHAR(50),
    @Description NVARCHAR(500),
    @Result NVARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT 1 FROM Cases WHERE CaseNumber = @CaseNumber)
    BEGIN
        SET @Result = N'شماره پرونده تکراری است';
        RETURN;
    END
    
    IF NOT EXISTS (SELECT 1 FROM Courts WHERE CourtID = @CourtID)
    BEGIN
        SET @Result = N'دادگاه یافت نشد';
        RETURN;
    END
    
    IF NOT EXISTS (SELECT 1 FROM Prosecutors WHERE ProsecutorID = @ProsecutorID)
    BEGIN
        SET @Result = N'دادستان یافت نشد';
        RETURN;
    END
    
    BEGIN TRAN;
    
    BEGIN TRY
        INSERT INTO Cases (CaseNumber, CaseTitle, CourtID, ProsecutorID, CaseType, RegisterDate, CaseStatus, Description)
        VALUES (@CaseNumber, @CaseTitle, @CourtID, @ProsecutorID, @CaseType, GETDATE(), N'در جریان', @Description);
        
        COMMIT TRAN;
        SET @Result = N'پرونده با موفقیت ثبت شد';
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        SET @Result = N'خطا در ثبت پرونده: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- پروسیجر افزودن شخص به پرونده
CREATE PROCEDURE sp_AddPersonToCase
    @CaseID INT,
    @PersonID INT,
    @Role NVARCHAR(50),
    @Notes NVARCHAR(500),
    @Result NVARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF NOT EXISTS (SELECT 1 FROM Cases WHERE CaseID = @CaseID)
    BEGIN
        SET @Result = N'پرونده یافت نشد';
        RETURN;
    END
    
    IF NOT EXISTS (SELECT 1 FROM Persons WHERE PersonID = @PersonID)
    BEGIN
        SET @Result = N'شخص یافت نشد';
        RETURN;
    END
    
    IF EXISTS (SELECT 1 FROM CasePersons WHERE CaseID = @CaseID AND PersonID = @PersonID AND Role = @Role)
    BEGIN
        SET @Result = N'این شخص قبلاً با همین نقش در پرونده ثبت شده است';
        RETURN;
    END
    
    BEGIN TRAN;
    
    BEGIN TRY
        INSERT INTO CasePersons (CaseID, PersonID, Role, JoinDate, Notes)
        VALUES (@CaseID, @PersonID, @Role, GETDATE(), @Notes);
        
        COMMIT TRAN;
        SET @Result = N'شخص با موفقیت به پرونده اضافه شد';
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        SET @Result = N'خطا در افزودن شخص: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- پروسیجر ثبت جلسه دادرسی
CREATE PROCEDURE sp_ScheduleHearing
    @CaseID INT,
    @HearingDate DATETIME,
    @HearingType NVARCHAR(50),
    @Result NVARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF NOT EXISTS (SELECT 1 FROM Cases WHERE CaseID = @CaseID)
    BEGIN
        SET @Result = N'پرونده یافت نشد';
        RETURN;
    END
    
    IF @HearingDate < GETDATE()
    BEGIN
        SET @Result = N'تاریخ جلسه نمی‌تواند در گذشته باشد';
        RETURN;
    END
    
    BEGIN TRAN;
    
    BEGIN TRY
        INSERT INTO Hearings (CaseID, HearingDate, HearingType)
        VALUES (@CaseID, @HearingDate, @HearingType);
        
        COMMIT TRAN;
        SET @Result = N'جلسه دادرسی با موفقیت ثبت شد';
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        SET @Result = N'خطا در ثبت جلسه: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- پروسیجر بستن پرونده
CREATE PROCEDURE sp_CloseCase
    @CaseID INT,
    @Result NVARCHAR(200) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF NOT EXISTS (SELECT 1 FROM Cases WHERE CaseID = @CaseID)
    BEGIN
        SET @Result = N'پرونده یافت نشد';
        RETURN;
    END
    
    DECLARE @CurrentStatus NVARCHAR(50);
    SELECT @CurrentStatus = CaseStatus FROM Cases WHERE CaseID = @CaseID;
    
    IF @CurrentStatus = N'بسته شده'
    BEGIN
        SET @Result = N'این پرونده قبلاً بسته شده است';
        RETURN;
    END
    
    BEGIN TRAN;
    
    BEGIN TRY
        UPDATE Cases 
        SET CaseStatus = N'بسته شده'
        WHERE CaseID = @CaseID;
        
        COMMIT TRAN;
        SET @Result = N'پرونده با موفقیت بسته شد';
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        SET @Result = N'خطا در بستن پرونده: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

PRINT N'پایگاه داده JudiciaryProject با موفقیت ایجاد شد!';
PRINT N' تمام جداول، داده‌های نمونه، ویوها و Stored Procedureها آماده هستند.';
PRINT N'';
PRINT N' جداول ایجاد شده:';
PRINT N'   - Prosecutors (دادستان‌ها)';
PRINT N'   - Courts (دادگاه‌ها)';
PRINT N'   - Cases (پرونده‌ها)';
PRINT N'   - Persons (اشخاص)';
PRINT N'   - CasePersons (ارتباط اشخاص با پرونده‌ها)';
PRINT N'   - Hearings (جلسات دادرسی)';
PRINT N'';
PRINT N' ویوها:';
PRINT N'   - vw_CaseDetails';
PRINT N'   - vw_CasePersonsDetails';
PRINT N'   - vw_HearingDetails';
PRINT N'';
PRINT N' Stored Procedures:';
PRINT N'   - sp_RegisterNewCase';
PRINT N'   - sp_AddPersonToCase';
PRINT N'   - sp_ScheduleHearing';
PRINT N'   - sp_CloseCase';
GO
