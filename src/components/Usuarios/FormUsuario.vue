<template>
  <div>
    <v-form ref="form" v-model="formValido">
      <v-card elevation="5" class="mx-auto">
        <v-card-text>
          <v-text-field class="mb-10" label="Nombre de usuario" v-model="usuario.usuario" :rules="reglas" required
            hide-details="auto"></v-text-field>
          <v-text-field class="mb-10" label="Nombre completo" v-model="usuario.nombre" :rules="reglas" required
            hide-details="auto"></v-text-field>
          <v-text-field label="Teléfono" class="mb-10" v-model="usuario.telefono" :rules="reglas" required
            hide-details="auto"></v-text-field>
          <v-select label="Rol" :items="rolesDisponibles" item-text="label" item-value="value" v-model="usuario.rol"
            outlined dense color="teal" />

        </v-card-text>
        <v-card-actions>
          <v-btn text @click="$router.push({ name: 'Usuarios' })"> Cancelar </v-btn>
          <v-spacer></v-spacer>
          <v-btn color="primary" text @click="registrar" :disabled="!formValido">
            Registrar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-form>
  </div>
</template>
<script>
export default {
  name: "FormUsuario",
  props: ["usuario"],
  data: () => ({
    formValido: false,
    formHasErrors: false,
    reglas: [(value) => !!value || "Campo obligatorio."],
    rolesDisponibles: [
      { label: "Administrador", value: "admin" },
      { label: "Empleado", value: "empleado" }
      //{ label: "Instructor", value: "instructor" },
      //{ label: "Ventas", value: "ventas" }
    ],
  }),

  mounted() {
    this.formValido = false;
    if (this.usuario && !this.usuario.rol) {
      this.$set(this.usuario, 'rol', '');
    }
  },

  methods: {
    registrar() {
      this.formHasErrors = false;

      if (!this.usuario) {
        console.error("🚨 this.usuario no está definido");
        return;
      }

      const campos = this.form;
      for (const campo in campos) {
        if (!campos[campo]) {
          this.formHasErrors = true;
        }
      }

      if (!this.formHasErrors) {
        console.log("✅ Usuario a registrar:", this.usuario);
        this.$emit("registrado", this.usuario);
        this.formValido = false;
      } else {
        console.warn("❌ Formulario con errores:", campos);
      }
    }
    ,
  },
  computed: {
    form() {
      return {
        usuario: this.usuario && this.usuario.usuario ? this.usuario.usuario : '',
        nombre: this.usuario && this.usuario.nombre ? this.usuario.nombre : '',
        telefono: this.usuario && this.usuario.telefono ? this.usuario.telefono : '',
        rol: this.usuario && this.usuario.rol ? this.usuario.rol : ''
      }
    }

  }
};
</script>
<style>
.miembros {
  padding: 30px;
  background-color: #1e1e1e;
  border-radius: 12px;
  min-height: 100vh;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
}
</style>