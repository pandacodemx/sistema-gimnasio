<template>
  <div>
    <v-app-bar color="primary" class="flex-grow-0" app dark>
      <v-app-bar-nav-icon @click.stop="drawer = !drawer"></v-app-bar-nav-icon>

      <v-spacer></v-spacer>

      <v-tooltip bottom>
        <template v-slot:activator="{ on, attrs }">
          <v-btn icon @click="salir" v-bind="attrs" v-on="on">
            <v-icon>mdi-logout</v-icon>
          </v-btn>
        </template>
        <span>Cerrar sesión</span>
      </v-tooltip>
    </v-app-bar>
    <v-navigation-drawer app v-model="drawer" class="fondo" transition="slide-x-transition">
      <v-list-item class="pa-4">
        <v-list-item-avatar size="56">
          <img :src="urlImagen(logo)" alt="Logo">
        </v-list-item-avatar>
        <v-list-item-content>
          <v-list-item-title class="text-h6 font-weight-bold white--text">
            {{ nombreGimnasio }}
          </v-list-item-title>
          <v-list-item-subtitle class="white--text text-caption mt-1">
            Sesión iniciada: {{ nombreUsuario }}
          </v-list-item-subtitle>
        </v-list-item-content>
      </v-list-item>
      <v-divider></v-divider>

      <v-list dense nav>
        <!-- Sección Principal -->
        <v-subheader class="white--text"><v-icon>mdi-home</v-icon> Principal</v-subheader>
        <v-list-item v-for="item in mainItems" :key="item.title" link :to="item.link" class="white--text drawer-item">
          <v-list-item-content>
            <v-list-item-title>{{ item.title }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>

        <!-- Sección Registros -->
        <v-subheader class="white--text"><v-icon>mdi-account</v-icon> Registros</v-subheader>
        <v-list-item v-for="item in registerItems" :key="item.title" link :to="item.link"
          class="white--text drawer-item">
          <v-list-item-content>
            <v-list-item-title>{{ item.title }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>

        <!-- Sección Productos -->
        <v-subheader class="white--text"><v-icon>mdi mdi-store </v-icon> Tienda</v-subheader>
        <v-list-item v-for="item in pruductosItems" :key="item.title" link :to="item.link"
          class="white--text drawer-item">
          <v-list-item-content>
            <v-list-item-title>{{ item.title }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>

        <!-- Sección Reportes -->
        <v-subheader class="white--text"><v-icon>mdi-table-edit </v-icon> Reportes</v-subheader>
        <v-list-item v-for="item in reportItems" :key="item.title" link :to="item.link" class="white--text drawer-item">
          <v-list-item-content>
            <v-list-item-title>{{ item.title }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>

        <!-- Sección Configuración -->
        <v-subheader class="white--text"><v-icon>mdi-wrench </v-icon> Configuración</v-subheader>
        <v-list-item v-for="item in configItems" :key="item.title" link :to="item.link" class="white--text drawer-item">
          <v-list-item-content>
            <v-list-item-title>{{ item.title }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>


      </v-list>




    </v-navigation-drawer>
  </div>
</template>
<script>
import Utiles from '../Servicios/Utiles'
export default {
  name: "Encabezado",

  data: () => ({
    drawer: false,
    nombreUsuario: "",
    nombreGimnasio: "",
    logo: "",
    mainItems: [
      { title: "Inicio", icon: "mdi-view-dashboard", link: "/" },
      { title: "Registrar visita", icon: "mdi-home-account", link: "/registrar-visita" },
    ],
    registerItems: [
      { title: "Usuarios", icon: "mdi-account-box", link: "/usuarios" },
      { title: "Miembros", icon: "mdi-weight-lifter", link: "/miembros" },
      { title: "Membresías", icon: "mdi-wallet-membership", link: "/membresias" },
    ],
    reportItems: [
      { title: "Pagos", icon: "mdi-account-cash", link: "/pagos" },
      { title: "Visitas", icon: "mdi-calendar-star", link: "/visitas" },
    ],
    configItems: [
      { title: "Informacion", icon: "mdi-cog", link: "/configurar" },
      { title: "Mi perfil", icon: "mdi-account-key", link: "/perfil" },
    ],
    pruductosItems: [
      { title: "Productos", icon: "mdi mdi-store", link: "/productos" },
    ],
  }),

  mounted() {
    this.nombreUsuario = localStorage.getItem("nombreUsuario")
    this.nombreGimnasio = localStorage.getItem("nombreGimnasio")
    this.logo = localStorage.getItem("logoGimnasio")

  },

  methods: {
    salir() {
      localStorage.removeItem('logeado')
      localStorage.removeItem('nombreUsuario')
      localStorage.removeItem('idUsuario')
      window.location.reload()
    },

    urlImagen(imagen) {
      return Utiles.generarURL(imagen);
    },

  }
};
</script>
<style>
.fondo {
  background-color: #000000;
  background-image: url("https://img.freepik.com/foto-gratis/fondo-oscuro-abstracto_1048-1920.jpg");
  background-attachment: fixed;
  background-size: cover;
  background-position: left;
  backdrop-filter: blur(50px);
}

.v-subheader {
  height: 36px;
  margin-top: 16px;
  font-size: 0.75rem;
  font-weight: 600;
  letter-spacing: 0.5px;
  text-transform: uppercase;
  opacity: 0.7;
  background-color: #000000;

}
</style>
