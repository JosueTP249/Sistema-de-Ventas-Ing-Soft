// Seleccionamos los elementos por su ID
const nombre = document.getElementById("nombre");
const apellidoP = document.getElementById("apellidoP");
const apellidoM = document.getElementById("apellidoM");
const correo = document.getElementById("correo");
const password = document.getElementById("password");
const password2 = document.getElementById("password2");
const rol = document.getElementById("rol");
const btnRegistrar = document.getElementById("btnRegistrar");

// Evento al hacer clic en Registrar
btnRegistrar.addEventListener("click", (event) => {
  event.preventDefault(); // Evita que se recargue la página

  // Obtenemos los valores
  const datos = {
    nombre: nombre.value,
    apellidoP: apellidoP.value,
    apellidoM: apellidoM.value,
    correo: correo.value,
    
    password: password.value,
    password2: password2.value,
    rol: rol.value
  };

  // Mostramos en consola
  console.log("Datos capturados:", datos);

  // Ejemplo: validación simple
  if (datos.password !== datos.password2) {
    alert("Las contraseñas no coinciden");
  } else {
    alert("Registro exitoso de " + datos.nombre + " como " + datos.rol);
  }
});
