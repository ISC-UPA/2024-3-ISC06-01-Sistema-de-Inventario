SELECT TOP (1000) [IdUser]
      ,[UserName]
      ,[UserDisplayName]
      ,[Role]
      ,[Email]
      ,[Password]
      ,[Created]
      ,[CreatedBy]
      ,[Updated]
      ,[UpdatedBy]
  FROM [SMIS-DB].[dbo].[Users];


INSERT INTO [SMIS-DB].[dbo].[Users] 
(
    [IdUser],
    [UserName],
    [UserDisplayName],
    [Role],
    [Email],
    [Password],
    [Created],
    [CreatedBy],
    [Updated],
    [UpdatedBy]
)
VALUES
(
    '8c2495da-acbf-4deb-9d13-859c72566705',
    'Admin',
    'Administrator',
    0,
    'admin@stockmaster',
    'admin',
    GETDATE(),
    NULL,
    NULL,
    NULL
);


DELETE FROM [SMIS-DB].[dbo].[Users]
WHERE [IdUser] = 'C4E3A7DE-8858-4DE1-1D90-08DD0C311C6A';
