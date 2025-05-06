import Vue from "vue";
import Router from "vue-router";
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

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: "/",
      name: "InicioComponent",
      component: InicioComponent
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
      component: Usuarios
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
      component: Pagos
    },
    {
      path: "/registrar-visita",
      name: "RegistrarVisita",
      component: RegistrarVisita
    },
    {
      path: "/visitas",
      name: "Visitas",
      component: Visitas
    },
    {
      path: "/configurar",
      name: "Configurar",
      component: ConfiguracionComponent
    },
    {
      path: "/perfil",
      name: "MiPerfil",
      component: MiPerfil
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
      component: ReporteVentas
    }
  ]
});
