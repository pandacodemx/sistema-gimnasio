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
    <v-navigation-drawer
      app
      v-model="drawer"
      class="fondo"
      transition="slide-x-transition"
    >
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
        <v-list-item
          v-for="item in items"
          :key="item.title"
          link
          :to="item.link"
          class="white--text drawer-item"
        >
          <v-list-item-icon >
            <v-icon class="white--text mr-2" :class="{ 'mdi-spin': item.title === 'Configurar' }">
              {{ item.icon }}
            </v-icon>
          </v-list-item-icon>

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
    items: [
      { title: "Inicio", icon: "mdi-view-dashboard", link: "/" },
      { title: "Registrar visita", icon: "mdi-home-account", link: "/registrar-visita" },
      { title: "Usuarios", icon: "mdi-account-box", link: "/usuarios" },
      { title: "Miembros", icon: "mdi-weight-lifter", link: "/miembros" },
      {
        title: "Membresías",
        icon: "mdi-wallet-membership",
        link: "/membresias",
      },
      { title: "Pagos", icon: "mdi-account-cash", link: "/pagos" },
      { title: "Visitas", icon: "mdi-calendar-star", link: "/visitas" },
      { title: "Configurar", icon: "mdi-cog", link: "/configurar" },
      { title: "Mi perfil", icon: "mdi-account-key", link: "/perfil" },
    ],
  }),

  mounted(){
    this.nombreUsuario = localStorage.getItem("nombreUsuario")
    this.nombreGimnasio = localStorage.getItem("nombreGimnasio")
    this.logo = localStorage.getItem("logoGimnasio")

  },

  methods:{ 
    salir(){
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
background-image: url("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUzTU-z2QrfVu5VJdJFv29vQsUtiUJuJwgVoJemKs2tg&s&ec=72940544");
background-attachment: fixed;
background-size: cover;
backdrop-filter: blur(50px);
} 

.drawer-item {
  transition: background-color 0.3s ease;
  border-radius: 8px;
}
.drawer-item:hover {
  background-color: rgba(255, 255, 255, 0.1);
}
</style>
