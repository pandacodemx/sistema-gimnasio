<template>
  <div id="credencial-wrapper">
    <!-- Frente -->
    <div class="credencial credencial-frontal" :class="colorTheme">
      <div class="header">
        <div class="logo-container">
          <img :src="urlImagen(logoGimnasio)" alt="Logo" class="logo" />
        </div>
        <div class="info-gimnasio">
          <p class="nombre-gimnasio">{{ nombreGimnasio }}</p>
          <p class="contacto-gimnasio">
            <v-icon small>mdi-phone</v-icon> {{ telefonoGimnasio }}<br />
            <v-icon small>mdi-map-marker</v-icon> {{ direccionGimnasio }}
          </p>
        </div>
      </div>

      <div class="photo-section">
        <div class="photo-frame">
          <img :src="urlImagen(miembro.imagen)" alt="Foto" class="foto-miembro" />
        </div>
        <div class="member-status" :class="miembro.estado ? 'active' : 'inactive'">
          {{ miembro.estado || 'INACTIVO' }}
        </div>
      </div>

      <h2 class="nombre-miembro">{{ miembro.nombre }}</h2>

      <div class="member-details">
        <p class="matricula">
          <v-icon small>mdi-identifier</v-icon>
          <span class="label">Matrícula:</span> <b>{{ miembro.matricula }}</b>
        </p>
      </div>

      <div class="qr-container">
        <div class="qr-frame">
          <img :src="qrCodeUrl" alt="QR de asistencia" class="qr-code">
        </div>
        <p class="qr-label">Escanear para registro de asistencia</p>
      </div>

      <div class="credencial-footer">
        <p>© {{ new Date().getFullYear() }} {{ nombreGimnasio }}</p>
      </div>
    </div>

    <!-- Reverso -->
    <div class="credencial credencial-reverso" :class="colorTheme">
      <div class="reverso-header">
        <h3>INFORMACIÓN DEL MIEMBRO</h3>
      </div>

      <div class="info-section">
        <div class="info-item">
          <v-icon small>mdi-phone</v-icon>
          <div class="info-content">
            <span class="info-label">Teléfono</span>
            <span class="info-value">{{ miembro.telefono }}</span>
          </div>
        </div>

        <div class="info-item">
          <v-icon small>mdi-map-marker</v-icon>
          <div class="info-content">
            <span class="info-label">Dirección</span>
            <span class="info-value">{{ miembro.direccion }}</span>
          </div>
        </div>

        <div class="info-item">
          <v-icon small>mdi-calendar</v-icon>
          <div class="info-content">
            <span class="info-label">Miembro desde</span>
            <span class="info-value">{{ formatearFecha(miembro.fechaRegistro) }}</span>
          </div>
        </div>
      </div>

      <div class="emergency-section">
        <h4><v-icon small>mdi-alert-circle</v-icon> EN CASO DE EMERGENCIA</h4>

        <div class="info-item">
          <v-icon small>mdi-account</v-icon>
          <div class="info-content">
            <span class="info-label">Contacto</span>
            <span class="info-value">{{ miembro.nombreContacto }}</span>
          </div>
        </div>

        <div class="info-item">
          <v-icon small>mdi-phone</v-icon>
          <div class="info-content">
            <span class="info-label">Teléfono</span>
            <span class="info-value">{{ miembro.telefonoContacto }}</span>
          </div>
        </div>

        <div class="info-item" v-if="miembro.enfermedad">
          <v-icon small>mdi-hospital</v-icon>
          <div class="info-content">
            <span class="info-label">Condición médica</span>
            <span class="info-value">{{ miembro.enfermedad }}</span>
          </div>
        </div>

        <div class="info-item" v-if="miembro.institucion">
          <v-icon small>mdi-hospital-building</v-icon>
          <div class="info-content">
            <span class="info-label">Seguro médico</span>
            <span class="info-value">{{ miembro.institucion }}</span>
          </div>
        </div>
      </div>

      <div class="reverso-footer">
        <p>En caso de extravío, devolver a: {{ direccionGimnasio }}</p>
      </div>
    </div>
  </div>
</template>

<script>
import Printd from "printd";
import Utiles from '../../Servicios/Utiles'
import QRCode from 'qrcode';

export default {
  name: "CredencialMiembro",
  props: ["matricula", "miembro"],

  data: () => ({
    qrCodeUrl: '',
    colorTheme: 'azul',
    nombreGimnasio: "",
    logoGimnasio: "",
    telefonoGimnasio: "",
    direccionGimnasio: "",
    cssText: `
      @import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap');
      
      #credencial-wrapper {
        display: flex;
        gap: 20px;
        padding: 20px;
        justify-content: center;
        flex-wrap: wrap;
        font-family: 'Montserrat', sans-serif;
      }
      
      .credencial {
        width: 340px;
        height: 540px;
        border-radius: 16px;
        padding: 20px;
        box-sizing: border-box;
        position: relative;
        overflow: hidden;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        display: flex;
        flex-direction: column;
        color: white;
      }
      
      /* Temas de colores */
      .credencial.azul {
        background: linear-gradient(135deg, #1a2980, #26d0ce);
      }
      
      .credencial.rojo {
        background: linear-gradient(135deg, #8E0E00, #1F1C18);
      }
      
      .credencial.verde {
        background: linear-gradient(135deg, #005C97, #363795);
      }
      
      .credencial.purpura {
        background: linear-gradient(135deg, #4776E6, #8E54E9);
      }
      
      .credencial.oro {
        background: linear-gradient(135deg, #BF953F, #FCF6BA, #B38728, #FBF5B7, #AA771C);
      }
      
      .header {
        display: flex;
        align-items: center;
        margin-bottom: 20px;
        position: relative;
        z-index: 2;
      }
      
      .logo-container {
        width: 60px;
        height: 60px;
        border-radius: 50%;
        background: white;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 5px;
        margin-right: 12px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
      }
      
      .logo {
        width: 50px;
        height: 50px;
        object-fit: contain;
      }
      
      .info-gimnasio {
        flex: 1;
      }
      
      .nombre-gimnasio {
        font-weight: 700;
        font-size: 16px;
        margin: 0 0 4px 0;
        text-transform: uppercase;
        letter-spacing: 0.5px;
      }
      
      .contacto-gimnasio {
        font-size: 11px;
        margin: 0;
        line-height: 1.4;
        opacity: 0.9;
      }
      
      .photo-section {
        display: flex;
        flex-direction: column;
        align-items: center;
        margin: 10px 0 20px;
        position: relative;
        z-index: 2;
      }
      
      .photo-frame {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        padding: 5px;
        background: white;
        box-shadow: 0 6px 15px rgba(0, 0, 0, 0.2);
        margin-bottom: 10px;
      }
      
      .foto-miembro {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        object-fit: cover;
        border: 1px solid #f8f9fa;
      }
      
      .member-status {
        padding: 4px 12px;
        border-radius: 20px;
        font-size: 11px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
      }
      
      .member-status.active {
        background: #4CAF50;
        color: white;
      }
      
      .member-status.inactive {
        background: #F44336;
        color: white;
      }
      
      .nombre-miembro {
        text-align: center;
        font-size: 15px;
        font-weight: 700;
        margin: 0 0 15px 0;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        position: relative;
        z-index: 2;
      }
      
      .member-details {
        background: rgba(255, 255, 255, 0.15);
        backdrop-filter: blur(5px);
        border-radius: 12px;
        padding: 15px;
        margin-bottom: 10px;
        position: relative;
        z-index: 2;
      }
      
      .member-details p {
        display: flex;
        align-items: center;
        margin: 8px 0;
        font-size: 13px;
      }
      
      .member-details .label {
        margin-right: 5px;
        opacity: 0.9;
      }
      
      .qr-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        margin-top: auto;
        position: relative;
        z-index: 2;
      }
      
      .qr-frame {
        background: white;
        padding: 10px;
        border-radius: 12px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
      }
      
      .qr-code {
        width: 100px;
        height: 100px;
      }
      
      .qr-label {
        font-size: 10px;
        text-align: center;
        margin: 8px 0 0;
        opacity: 0.9;
        font-weight: 500;
      }
      
      .credencial-footer {
        text-align: center;
        font-size: 9px;
        opacity: 0.7;
        margin-top: 15px;
        position: relative;
        z-index: 2;
      }
      
      /* Estilos para el reverso */
      .credencial-reverso {
        justify-content: flex-start;
      }
      
      .reverso-header {
        text-align: center;
        margin-bottom: 20px;
        position: relative;
        z-index: 2;
      }
      
      .reverso-header h3 {
        font-size: 16px;
        font-weight: 700;
        margin: 0;
        text-transform: uppercase;
        letter-spacing: 1px;
      }
      
      .info-section, .emergency-section {
        margin-bottom: 20px;
        position: relative;
        z-index: 2;
      }
      
      .emergency-section h4 {
        display: flex;
        align-items: center;
        font-size: 14px;
        margin: 0 0 15px 0;
        font-weight: 600;
      }
      
      .info-item {
        display: flex;
        align-items: center;
        margin-bottom: 12px;
        background: rgba(255, 255, 255, 0.1);
        padding: 8px 12px;
        border-radius: 8px;
      }
      
      .info-content {
        display: flex;
        flex-direction: column;
        margin-left: 10px;
      }
      
      .info-label {
        font-size: 10px;
        opacity: 0.8;
        text-transform: uppercase;
        letter-spacing: 0.5px;
      }
      
      .info-value {
        font-size: 12px;
        font-weight: 500;
      }
      
      .reverso-footer {
        margin-top: auto;
        text-align: center;
        font-size: 9px;
        opacity: 0.7;
        padding-top: 10px;
        border-top: 1px solid rgba(255, 255, 255, 0.2);
        position: relative;
        z-index: 2;
      }
      
      /* Patrón de fondo decorativo */
      .credencial::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-image: url("data:image/svg+xml,%3Csvg width='100' height='100' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M11 18c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm48 25c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm-43-7c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm63 31c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM34 90c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm56-76c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM12 86c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm28-65c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm23-11c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-6 60c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm29 22c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zM32 63c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm57-13c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-9-21c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM60 91c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM35 41c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM12 60c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2z' fill='%23ffffff' fill-opacity='0.05' fill-rule='evenodd'/%3E%3C/svg%3E");
        opacity: 0.4;
        z-index: 1;
      }
      
      @media print {
      .credencial {
        -webkit-print-color-adjust: exact;
        print-color-adjust: exact;
        background: #23252e !important; 
        color: white !important;
      }
        body, html {
          height: 100%;
          margin: 0;
          padding: 0;
        }
        
        #credencial-wrapper {
          padding: 0;
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100%;
        }
        
        .credencial {
          box-shadow: none;
          margin: 0;
          page-break-inside: avoid;
        }
      }
    `
  }),

  beforeMount() {
    this.nombreGimnasio = localStorage.getItem("nombreGimnasio")
    this.logoGimnasio = localStorage.getItem("logoGimnasio")
    this.telefonoGimnasio = localStorage.getItem("telefonoGimnasio")
    this.direccionGimnasio = localStorage.getItem("direccionGimnasio")

    // Seleccionar tema aleatorio o basado en tipo de membresía
    const temas = ['azul', 'rojo', 'verde', 'purpura', 'oro'];
    this.colorTheme = temas[Math.floor(Math.random() * temas.length)];

    // O seleccionar por tipo de membresía
    if (this.miembro.membresia) {
      if (this.miembro.membresia.toLowerCase().includes('oro') ||
        this.miembro.membresia.toLowerCase().includes('premium')) {
        this.colorTheme = 'oro';
      } else if (this.miembro.membresia.toLowerCase().includes('platino')) {
        this.colorTheme = 'purpura';
      }
    }
  },

  async mounted() {
    await this.generarQR();
    this.imprimir();
  },

  methods: {
    formatearFecha(fechaString) {
      if (!fechaString) return 'N/A';
      const fecha = new Date(fechaString);
      return fecha.toLocaleDateString('es-MX', {
        day: '2-digit',
        month: 'short',
        year: 'numeric'
      });
    },

    async generarQR() {
      try {
        const datosQR = {
          miembroId: this.miembro.id,
          gimnasioId: localStorage.getItem("idGimnasio"),
          timestamp: Date.now()
        };
        this.qrCodeUrl = await QRCode.toDataURL(JSON.stringify(datosQR), {
          width: 200,
          margin: 1,
          color: {
            dark: "#000000",
            light: "#FFFFFF"
          }
        });
      } catch (error) {
        console.error("Error al generar QR:", error);
      }
    },

    urlImagen(imagen) {
      return Utiles.generarURL(imagen);
    },

    imprimir() {
      setTimeout(() => {
        const d = new Printd();
        const zona = document.getElementById("credencial-wrapper");
        d.print(zona, [this.cssText]);
        this.$emit("impreso", false);
      }, 100);
    }
  }
}
</script>
