<template>
  <div>
    <v-app-bar color="primary" class="flex-grow-0 app-bar" app dark elevation="4">
      <v-app-bar-nav-icon @click.stop="drawer = !drawer" class="nav-icon"></v-app-bar-nav-icon>

      <v-spacer></v-spacer>

      <div class="app-bar-title hidden-sm-and-down">
        <span class="gym-name">{{ nombreGimnasio }}</span>
      </div>

      <v-spacer></v-spacer>

      <v-tooltip bottom>
        <template v-slot:activator="{ on, attrs }">
          <v-btn icon @click="salir" v-bind="attrs" v-on="on" class="logout-btn">
            <v-icon>mdi-logout</v-icon>
          </v-btn>
        </template>
        <span>Cerrar sesión</span>
      </v-tooltip>
    </v-app-bar>

    <v-navigation-drawer app v-model="drawer" class="custom-drawer" transition="slide-x-transition">
      <!-- Header del drawer -->
      <div class="drawer-header">
        <v-list-item class="pa-4 user-info">
          <v-list-item-avatar size="64" class="avatar-border">
            <img :src="urlImagen(logo)" alt="Logo" class="avatar-image">
          </v-list-item-avatar>
          <v-list-item-content>
            <v-list-item-title class="font-weight-bold white--text gym-title">
              {{ nombreGimnasio }}
            </v-list-item-title>
            <v-list-item-subtitle class="white--text mt-1 user-subtitle">
              <v-icon small>mdi-account</v-icon>
              Sesión: {{ nombreUsuario }}
            </v-list-item-subtitle>
          </v-list-item-content>
        </v-list-item>
      </div>

      <v-divider class="divider-custom"></v-divider>

      <v-list dense nav class="nav-list">
        <!-- Sección Principal -->
        <v-list-group :value="true" prepend-icon="mdi-home" class="section-group">
          <template v-slot:activator>
            <v-list-item-title class="section-title">Principal</v-list-item-title>
          </template>
          <v-list-item v-for="item in mainItems" :key="item.title" link :to="item.link" class="drawer-item">
            <v-list-item-icon>
              <v-icon small>{{ item.icon }}</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>{{ item.title }}</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list-group>

        <!-- Sección Registros -->
        <v-list-group :value="true" prepend-icon="mdi-account-multiple" class="section-group">
          <template v-slot:activator>
            <v-list-item-title class="section-title">Registros</v-list-item-title>
          </template>
          <v-list-item v-for="item in registerItems" :key="item.title" link :to="item.link" class="drawer-item">
            <v-list-item-icon>
              <v-icon small>{{ item.icon }}</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>{{ item.title }}</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list-group>

        <!-- Sección Productos -->
        <v-list-group :value="true" prepend-icon="mdi-store" class="section-group">
          <template v-slot:activator>
            <v-list-item-title class="section-title">Tienda</v-list-item-title>
          </template>
          <v-list-item v-for="item in pruductosItems" :key="item.title" link :to="item.link" class="drawer-item">
            <v-list-item-icon>
              <v-icon small>{{ item.icon }}</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>{{ item.title }}</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list-group>

        <!-- Sección Clases -->
        <v-list-group :value="true" prepend-icon="mdi-dumbbell" class="section-group">
          <template v-slot:activator>
            <v-list-item-title class="section-title">Clases</v-list-item-title>
          </template>
          <v-list-item v-for="item in clasesItems" :key="item.title" link :to="item.link" class="drawer-item">
            <v-list-item-icon>
              <v-icon small>{{ item.icon }}</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>{{ item.title }}</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list-group>

        <!-- Sección Reportes -->
        <v-list-group :value="true" prepend-icon="mdi-chart-bar" class="section-group">
          <template v-slot:activator>
            <v-list-item-title class="section-title">Reportes</v-list-item-title>
          </template>
          <v-list-item v-for="item in reportItems" :key="item.title" link :to="item.link" class="drawer-item">
            <v-list-item-icon>
              <v-icon small>{{ item.icon }}</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>{{ item.title }}</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list-group>

        <!-- Sección Configuración -->
        <v-list-group :value="true" prepend-icon="mdi-cog" class="section-group">
          <template v-slot:activator>
            <v-list-item-title class="section-title">Configuración</v-list-item-title>
          </template>
          <v-list-item v-for="item in configItems" :key="item.title" link :to="item.link" class="drawer-item">
            <v-list-item-icon>
              <v-icon small>{{ item.icon }}</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>{{ item.title }}</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list-group>
      </v-list>

      <!-- Footer del drawer -->
      <div class="drawer-footer">
        <v-divider class="divider-custom"></v-divider>
        <div class="pa-3 text-center version-text">
          Bamboo Management Suite v1.5.0
        </div>
      </div>
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
      { title: "Scanner", icon: "mdi-qrcode-scan", link: "/scanner" },
    ],
    registerItems: [
      { title: "Usuarios", icon: "mdi-account-box", link: "/usuarios" },
      { title: "Miembros", icon: "mdi-weight-lifter", link: "/miembros" },
      { title: "Membresías", icon: "mdi-wallet-membership", link: "/membresias" },
    ],
    clasesItems: [
      { title: "Gestion Clases", icon: "mdi-calendar-clock", link: "/gestion-clases" },
    ],
    reportItems: [
      { title: "Pagos", icon: "mdi-account-cash", link: "/pagos" },
      { title: "Visitas", icon: "mdi-calendar-star", link: "/visitas" },
      { title: "Ventas productos", icon: "mdi-cash-register", link: "/reporte-ventas" },
    ],
    configItems: [
      { title: "Informacion", icon: "mdi-information", link: "/configurar" },
      { title: "Mi perfil", icon: "mdi-account-cog", link: "/perfil" },
    ],
    pruductosItems: [
      { title: "Productos", icon: "mdi-package-variant", link: "/productos" },
    ],
  }),

  mounted() {
    this.nombreUsuario = localStorage.getItem("usuario")
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

<style scoped>
/* Barra de aplicación superior */
.app-bar {
  background: linear-gradient(135deg, #1f2024 0%, #35363d 50%, #5d5f6b 100%) !important;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1) !important;
}

.nav-icon {
  transition: transform 0.3s ease;
}

.nav-icon:hover {
  transform: scale(1.1);
}

.gym-name {
  font-weight: 600;
  letter-spacing: 0.5px;
}

.logout-btn {
  transition: all 0.3s ease;
}

.logout-btn:hover {
  color: #ff5252 !important;
  transform: scale(1.1);
}

/* Panel de navegación */
.custom-drawer {
  background: linear-gradient(135deg, #1a1a1a 0%, #2c2c2c 100%) !important;
  box-shadow: 4px 0 10px rgba(0, 0, 0, 0.2) !important;
}

.drawer-header {
  background: rgba(0, 0, 0, 0.2);
  padding: 8px 0;
}

.user-info {
  backdrop-filter: blur(5px);
}

.avatar-border {
  border: 2px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 0 10px rgba(255, 255, 255, 0.1);
}

.avatar-image {
  object-fit: cover;
}

.gym-title {
  font-size: 1.1rem;
  letter-spacing: 0.5px;
}

.user-subtitle {
  opacity: 0.8;
  font-size: 0.8rem;
}

.divider-custom {
  border-color: rgba(255, 255, 255, 0.1) !important;
  margin: 8px 0;
}

/* Grupos de secciones */
.section-group {
  background-color: transparent !important;
}

.section-group>>>.v-list-group__header {
  background: rgba(0, 0, 0, 0.1) !important;
  margin: 4px 8px;
  border-radius: 8px;
  min-height: 40px;
}

.section-group>>>.v-list-group__header:hover {
  background: rgba(255, 255, 255, 0.05) !important;
}

.section-group>>>.v-list-group__items {
  background: rgba(0, 0, 0, 0.15);
  border-radius: 0 0 8px 8px;
  margin: 0 8px 8px 8px;
}

.section-title {
  color: rgba(255, 255, 255, 0.9) !important;
  font-weight: 600;
  font-size: 0.85rem;
  letter-spacing: 0.5px;
}

/* Elementos del menú */
.drawer-item {
  border-radius: 6px;
  margin: 2px 4px;
  min-height: 40px;
}

.drawer-item>>>.v-list-item__icon {
  margin-right: 12px;
}

.drawer-item>>>.v-list-item__title {
  font-size: 0.9rem;
  color: rgba(255, 255, 255, 0.8);
}

.drawer-item:hover {
  background: rgba(255, 255, 255, 0.05) !important;
}

.drawer-item.v-item--active {
  background: linear-gradient(135deg, rgba(57, 73, 171, 0.3) 0%, rgba(48, 63, 159, 0.3) 100%) !important;
  border-left: 3px solid #5c6bc0;
}

.drawer-item.v-item--active>>>.v-list-item__title {
  color: white;
  font-weight: 500;
}

/* Footer del drawer */
.drawer-footer {
  margin-top: auto;
}

.version-text {
  color: rgba(255, 255, 255, 0.4);
  font-size: 0.75rem;
}

/* Efectos de transición */
.v-list-item {
  transition: all 0.2s ease-in-out;
}

/* Scrollbar personalizado para el drawer */
.custom-drawer::-webkit-scrollbar {
  width: 6px;
}

.custom-drawer::-webkit-scrollbar-track {
  background: rgba(0, 0, 0, 0.1);
}

.custom-drawer::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;
}

.custom-drawer::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}
</style>