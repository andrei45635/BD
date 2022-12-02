USE [Port]
GO

CREATE PROCEDURE select_view
	@viewName VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	IF @viewName = 'View1'
	BEGIN
	   SELECT * FROM View1;
	END

	IF @viewName = 'View2'
	BEGIN
	   SELECT * FROM View2;
	END

	IF @viewName = 'View3'
	BEGIN
	   SELECT * FROM View3;
	END
END