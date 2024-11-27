SELECT TOP (1000) 
    [IdUser],
    [UserName],
    [UserDisplayName],
    [Role],
    [Email],
    [IsActive],  -- Se ha a�adido el nuevo campo 'IsActive'
    [Created],
    [CreatedBy],
    [Updated],
    [UpdatedBy]
FROM 
    [SMIS-DB].[dbo].[Users];

INSERT INTO [SMIS-DB].[dbo].[Users] 
(
    [IdUser],
    [UserName],
    [UserDisplayName],
    [Role],
    [Email],
    [IsActive],  -- Se ha a�adido el campo 'IsActive'
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
    0,  -- Rol: 0, puedes cambiar esto seg�n los roles definidos
    'admin@stockmaster',
    1,  -- 'IsActive' = 1 para indicar que el usuario est� activo
    GETDATE(),
    NULL,  -- CreatedBy puede ser un valor de usuario si se necesita
    NULL,  -- Updated es NULL porque es un nuevo registro
    NULL   -- UpdatedBy es NULL porque es un nuevo registro
);
