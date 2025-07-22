// src/mixins/mixinRoles.js
export default {
  computed: {
    rolUsuario() {
      return this.$store.getters.userRole;
    },
    esAdmin() {
      return this.rolUsuario === "admin";
    },
    esEmpleado() {
      return this.rolUsuario === "empleado";
    },
    esRecepcion() {
      return this.rolUsuario === "recepcion";
    }
  }
};
