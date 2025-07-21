// src/store.js
import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    user: null,
    debeCambiarPassword: false,
    snackbar: {
      mostrar: false,
      mensaje: "",
      color: "error"
    }
  },
  mutations: {
    setUser(state, user) {
      state.user = user;
    },
    setDebeCambiarPassword(state, valor) {
      state.debeCambiarPassword = valor;
    },
    logout(state) {
      state.user = null;
      state.debeCambiarPassword = false;
    },
    mostrarSnackbar(state, payload) {
      state.snackbar.mostrar = true;
      state.snackbar.mensaje = payload.mensaje;
      state.snackbar.color = payload.color || "error";
    },
    ocultarSnackbar(state) {
      state.snackbar.mostrar = false;
    }
  },
  getters: {
    isLoggedIn: state => !!state.user,
    userRole: state => (state.user ? state.user.rol.toLowerCase() : null),
    debeCambiarPassword: state => state.debeCambiarPassword
  }
});
