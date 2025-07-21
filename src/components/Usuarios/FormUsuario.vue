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
          <v-select v-model="usuario.rol" :items="rolesDisponibles" label="Rol" required item-text="label"
            item-value="value" outlined dense></v-select>
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
      { label: "Recepción", value: "empleado" },
      { label: "Instructor", value: "instructor" },
      { label: "Ventas", value: "ventas" }
    ],
  }),

  mounted() {
    this.formValido = false;
  },

  methods: {
    registrar() {
      this.formHasErrors = false

      Object.keys(this.form).forEach(f => {
        if (!this.form[f]) this.formHasErrors = true

        //this.$refs[f].validate(true)
      })
      this.$emit("registrado", this.usuario);
      this.formValido = false
    },
  },

  computed: {
    form() {
      return {
        usuario: this.usuario.usuario,
        nombre: this.usuario.nombre,
        telefono: this.usuario.telefono,
        rol: this.usuario.rol
      }
    },
  },
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