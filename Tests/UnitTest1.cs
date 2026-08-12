using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using ProyectoRazorProductos.Models;
using Xunit;

namespace Tests;

public class UnitTest1
{
    [Fact]
    //Metodo de prueba para validar que un producto sin nombre es inválido
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
    //Metodo de prueba para validar que un producto con precio menor a cero es inválido
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
    //Metodo de prueba para validar que un producto válido pasa las validaciones
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