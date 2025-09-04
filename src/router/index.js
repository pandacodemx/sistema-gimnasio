import Vue from "vue";
import Router from "vue-router";
import store from "../store";
import Membresias from "../components/Membresias/Membresias";
import Miembros from "../components/Miembros/Miembros";
import EditarMiembro from "../components/Miembros/EditarMiembro";
import Usuarios from "../components/Usuarios/Usuarios";
import NuevoMiembro from "../components/Miembros/NuevoMiembro";
import NuevoUsuario from "../components/Usuarios/NuevoUsuario";
import EditarUsuario from "../components/Usuarios/EditarUsuario";
import CambiarPassword from "../components/Usuarios/CambiarPassword";
import Pagos from "../components/Pagos/Pagos";
import RegistrarVisita from "../components/Visitas/RegistrarVisita";
import Visitas from "../components/Visitas/Visitas";
import ConfiguracionComponent from "../components/Configuracion/ConfiguracionComponent";
import InicioComponent from "../components/InicioComponent";
import MiPerfil from "../components/Usuarios/MiPerfil";
import ProductosComponente from "../components/Productos/ProductosComponente.vue";
import Ventas from "../components/Productos/Ventas.vue";
import ReporteVentas from "../components/Productos/ReporteVentas.vue";
import ScannerQE from "../components/Miembros/ScannerQR.vue";
import Login from "../components/Usuarios/Login.vue";
import GestionClases from "../components/Clases/GestionClases.vue";
import Ejercicio from "../components/Planes/Ejercicio.vue";
import CategoriasEjercicios from "../components/Planes/CategoriasEjercicios.vue";
import Rutinas from "../components/Planes/Rutinas.vue";
import ListaRutinas from "../components/Planes/ListaRutinas.vue";
import AsignarRutina from "../components/Planes/AsignarRutina.vue";
import GestionAsignaciones from "../components/Planes/GestionAsignaciones.vue";

Vue.use(Router);

const router = new Router({
  routes: [
    {
      path: "/login",
      name: "Login",
      component: Login
    },
    {
      path: "/",
      name: "InicioComponent",
      component: InicioComponent,
      meta: { requiresAuth: true, roles: ["admin"] }
    },
    {
      path: "/dashboard",
      name: "Dashboard",
      component: InicioComponent,
      meta: { requiresAuth: true, roles: ["admin"] }
    },
    {
      path: "/membresias",
      name: "Membresias",
      component: Membresias
    },
    {
      path: "/miembros",
      name: "Miembros",
      component: Miembros
    },
    {
      path: "/scanner",
      name: "ScannerQE",
      component: ScannerQE
    },
    {
      path: "/nuevo-miembro",
      name: "NuevoMiembro",
      component: NuevoMiembro
    },
    {
      path: "/editar-miembro/:id",
      name: "EditarMiembro",
      component: EditarMiembro
    },
    {
      path: "/usuarios",
      name: "Usuarios",
      component: Usuarios,
      meta: { requiresAuth: true, roles: ["admin"] }
    },
    {
      path: "/nuevo-usuario",
      name: "NuevoUsuario",
      component: NuevoUsuario
    },
    {
      path: "/editar-usuario/:id",
      name: "EditarUsuario",
      component: EditarUsuario
    },
    {
      path: "/cambiar-password",
      name: "CambiarPassword",
      component: CambiarPassword
    },
    {
      path: "/pagos",
      name: "Pagos",
      component: Pagos,
      meta: { requiresAuth: true, roles: ["admin"] }
    },
    {
      path: "/registrar-visita",
      name: "RegistrarVisita",
      component: RegistrarVisita
    },
    {
      path: "/visitas",
      name: "Visitas",
      component: Visitas,
      meta: { requiresAuth: true, roles: ["admin"] }
    },
    {
      path: "/configurar",
      name: "Configurar",
      component: ConfiguracionComponent,
      meta: { requiresAuth: true, roles: ["admin"] }
    },
    {
      path: "/perfil",
      name: "MiPerfil",
      component: MiPerfil,
      meta: { requiresAuth: true, roles: ["admin"] }
    },
    {
      path: "/productos",
      name: "ProductosComponente",
      component: ProductosComponente
    },
    {
      path: "/ventas",
      name: "Ventas",
      component: Ventas
    },
    {
      path: "/reporte-ventas",
      name: "ReporteVentas",
      component: ReporteVentas,
      meta: { requiresAuth: true, roles: ["admin"] }
    },
    {
      path: "/gestion-clases",
      name: "GestionClases",
      component: GestionClases
    },
    {
      path: "/ejercicios",
      name: "Ejercicio",
      component: Ejercicio
    },
    {
      path: "/categoria-ejercicio",
      name: "CategoriaEjercicios",
      component: CategoriasEjercicios
    },
    {
      path: "/rutinas/crear",
      name: "CrearRutina",
      component: Rutinas
    },
    {
      path: "/rutinas/editar/:id",
      name: "EditarRutina",
      component: Rutinas
    },
    {
      path: "/lista-rutinas",
      name: "ListaRutinas",
      component: ListaRutinas
    },
    {
      path: "/asignar-rutina",
      name: "AsignarRutina",
      component: AsignarRutina
    },
    {
      path: "/gestion-asignaciones",
      name: "GestionAsignaciones",
      component: GestionAsignaciones
    },
    {
      path: "*",
      redirect: "/login"
    }
  ]
});

router.beforeEach((to, from, next) => {
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth);
  const isAuthenticated = store.getters.isLoggedIn;
  const userRole = store.getters.userRole; // ejemplo: 'admin' o 'empleado'

  if (requiresAuth && !isAuthenticated) {
    next("/login");
  } else if (to.path === "/login" && isAuthenticated) {
    next("/dashboard");
  } else if (requiresAuth) {
    const allowedRoles = to.meta.roles; // ejemplo: ['admin']

    if (allowedRoles && !allowedRoles.includes(userRole)) {
      store.commit("mostrarSnackbar", {
        mensaje: "No tienes permiso para acceder a este modulo.",
        color: "error"
      });
      next("/");
    } else {
      next();
    }
  } else {
    next();
  }
});

export default router;
