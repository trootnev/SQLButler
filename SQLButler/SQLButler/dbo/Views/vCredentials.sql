CREATE VIEW [dbo].[vCredentials]
AS
SELECT        CrId, CredName, Login, Description, CAST(N'******' as NVARCHAR(50)) AS Password
FROM            dbo.Credentials (NOLOCK)
GO


;
CREATE TRIGGER [dbo].[tAddCredential] 
	on [dbo].[vCredentials]
	INSTEAD OF INSERT 
	AS
	BEGIN 
		SET NOCOUNT ON
		INSERT dbo.Credentials
					(CredName
					,Login
					,Description,
					Password
					)
		(
		SELECT CredName
					,Login
					,Description,
					Password
		FROM inserted
		)
	END
GO

CREATE TRIGGER [dbo].[tDeleteCredential]
	ON [dbo].[vCredentials]
	INSTEAD OF DELETE
	AS
	BEGIN
	SET NOCOUNT ON
	DELETE dbo.Credentials
	WHERE CrId in (SELECT I.CrID from deleted I)
	
	END
GO

CREATE TRIGGER [dbo].[tUpdateCredential] 
	on [dbo].[vCredentials]
	INSTEAD OF UPDATE 
	AS
	BEGIN 
		SET NOCOUNT ON
		DECLARE @CrId int
				,@CredName nvarchar(255)
				,@Login nvarchar(50)
				,@Description nvarchar(4000)
				,@Password nvarchar(50)

		IF UPDATE(Password)
		BEGIN 
			SELECT @CrId = i.CrId
					,@CredName = i.CredName
					,@Login = i.Login
					,@Description = i.Description
					,@Password = i.Password
			FROM inserted i 
		END
		ELSE
		BEGIN
		SELECT @CrId = i.CrId
					,@CredName = i.CredName
					,@Login = i.Login
					,@Description = i.Description
					
			FROM inserted i 
			SELECT @Password = Password
			FROM dbo.Credentials
			WHERE CrId = @CrId
		END
		
		
		IF UPDATE(CrID)
		BEGIN
			RAISERROR('CustomerId cannot be updated.', 16 ,1)
              ROLLBACK
		END
		ELSE
		BEGIN
		UPDATE dbo.Credentials
				SET CredName = @CredName
					,Login = @Login
					,Description = @Description
					,Password = @Password
				WHERE CriD = @CrId
		END
	END;
GO



