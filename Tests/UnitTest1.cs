using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using ProyectoRazorProductos.Models;
using Xunit;

namespace Tests;

public class UnitTest1
{
    [Fact]
    public void ProductoSinNombreDebeSerInvalido()
    {
        // Arrange
        var producto = new Producto
        {
            Nombre = "",
            Precio = 1000,
            Activo = true
        };

        var contexto = new ValidationContext(producto);
        var resultados = new List<ValidationResult>();

        // Act
        bool esValido = Validator.TryValidateObject(
            producto,
            contexto,
            resultados,
            true);

        // Assert
        Assert.False(esValido);
        Assert.Contains(resultados,
            r => r.MemberNames.Contains(nameof(Producto.Nombre)));
    }

    [Fact]
    public void ProductoConPrecioMenorACeroDebeSerInvalido()
    {
        // Arrange
        var producto = new Producto
        {
            Nombre = "Laptop",
            Precio = -100,
            Activo = true
        };

        var contexto = new ValidationContext(producto);
        var resultados = new List<ValidationResult>();

        // Act
        bool esValido = Validator.TryValidateObject(
            producto,
            contexto,
            resultados,
            true);

        // Assert
        Assert.False(esValido);
        Assert.Contains(resultados,
            r => r.MemberNames.Contains(nameof(Producto.Precio)));
    }

    [Fact]
    public void ProductoValidoDebePasarLasValidaciones()
    {
        // Arrange
        var producto = new Producto
        {
            Nombre = "Laptop Dell",
            Precio = 850000,
            Descripcion = "Laptop empresarial",
            Activo = true
        };

        var contexto = new ValidationContext(producto);
        var resultados = new List<ValidationResult>();

        // Act
        bool esValido = Validator.TryValidateObject(
            producto,
            contexto,
            resultados,
            true);

        // Assert
        Assert.True(esValido);
    }
}