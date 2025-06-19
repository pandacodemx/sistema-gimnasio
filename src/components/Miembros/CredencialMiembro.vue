<template>
  <div id="credencial-wrapper">
    <!-- Frente -->
    <div class="credencial credencial-frontal" :class="colorTheme">
      <div class="header">
        <img :src="urlImagen(logoGimnasio)" alt="Logo" class="logo" />
        <div class="info-gimnasio">
          <p class="nombre-gimnasio">{{ nombreGimnasio }}</p>
          <p class="contacto-gimnasio">
            Tel: {{ telefonoGimnasio }}<br />
            {{ direccionGimnasio }}
          </p>
        </div>
      </div>

      <img :src="urlImagen(miembro.imagen)" alt="Foto" class="foto-miembro" />
      <h2 class="nombre-miembro">{{ miembro.nombre }}</h2>
      <p class="matricula">Matrícula: <b>{{ miembro.matricula }}</b></p>
      <div class="qr-container">
        <img :src="qrCodeUrl" alt="QR de asistencia" width="120">
      </div>
    </div>

    <!-- Reverso -->
    <div class="credencial credencial-reverso" :class="colorTheme">
      <div class="info-miembro">
        <p><b>Teléfono:</b> {{ miembro.telefono }}</p>
        <p><b>Dirección:</b> {{ miembro.direccion }}</p>
        <p><b>Miembro desde:</b> {{ miembro.fechaRegistro }}</p>
      </div>

      <hr>
      <h3>En caso de emergencia</h3>
      <p><b>Nombre:</b> {{ miembro.nombreContacto }}</p>
      <p><b>Teléfono:</b> {{ miembro.telefonoContacto }}</p>
      <p><b>Enfermedad(es):</b> {{ miembro.enfermedad }}</p>
      <p><b>Seguro en:</b> {{ miembro.institucion }}</p>
    </div>


  </div>
</template>

<script>
import Printd from "printd";
import Utiles from '../../Servicios/Utiles'
import QRCode from 'qrcode';
const d = new Printd();
export default {
  name: "CredencialMiembro",
  props: ["matricula", "miembro"],

  data: () => ({
    qrCodeUrl: '',
    colorTheme: 'rojo',
    colorThemes: {
      rojo: {
        background: 'linear-gradient(145deg, #961c36, #ff6190)',
        texto: '#fff'
      },
      azul: {
        background: 'linear-gradient(145deg, #1c3b96, #619dff)',
        texto: '#fff'
      },
      verde: {
        background: 'linear-gradient(145deg, #1c9636, #61ff90)',
        texto: '#fff'
      }
    },
    nombreGimnasio: "",
    logoGimnasio: "",
    telefonoGimnasio: "",
    direccionGimnasio: "",
    cssText: `
        .rojo {
          background: linear-gradient(145deg, #961c36, #ff6190) !important;
          color: #fff !important;
        }

        .azul {
          background: linear-gradient(145deg, #1c3b96, #619dff) !important;
          color: #fff !important;
        }

        .verde {
          background: linear-gradient(145deg, #1c9636, #61ff90) !important;
          color: #fff !important;
        }
        #credencial-wrapper {
        display: flex;
        gap: 20px;
        padding: 20px;      
        flex-wrap: wrap;
        }

        .credencial {
        width: 320px;
        height: 420px;
        border-radius: 16px;
        border: 1px solid #ccc;
        background: linear-gradient(145deg, #e0ecf9, #f3f9fd);
        box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
        padding: 16px;
        box-sizing: border-box;
        font-family: 'Segoe UI', sans-serif;
        position: relative;
        }

        .credencial-frontal .header {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12px;
        margin-bottom: 16px;
        }

        .logo {
        width: 50px;
        height: 50px;
        object-fit: contain;
        }

        .info-gimnasio {
        font-size: 12px;
        color: #333;
        }

        .nombre-gimnasio {
        font-weight: bold;
        font-size: 14px;
        margin-bottom: 2px;
        }

        .contacto-gimnasio {
        line-height: 1.2;
        }

        .foto-miembro {
        display: flex;
        justify-content: center;
        width: 90px;
        height: 90px;
        border-radius: 50%;
        object-fit: cover;
        margin: 0 auto;
        border: 3px solid #fff;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
        }

        .nombre-miembro {
        text-align: center;
        font-size: 20px;
        margin-top: 10px;
        font-weight: 700;
        color: #222;
        }

        .matricula {
        text-align: center;
        font-size: 14px;
        color: #666;
        margin-top: 4px;
        }

        .info-miembro {
        margin-top: 16px;
        font-size: 13px;
        color: #333;
        line-height: 1.4;
        }

        .credencial-reverso h3 {
        font-size: 16px;
        color: #d00000;
        margin-bottom: 10px;
        }

        .credencial-reverso p {
        font-size: 13px;
        margin: 4px 0;
        color: #333;
        }

        .pie {
        position: absolute;
        bottom: 16px;
        left: 0;
        right: 0;
        text-align: center;
        }

        .logo-sistema {
        width: 120px;
        margin-top: 6px;
        opacity: 0.7;
        }    
        `
  }),

  beforeMount() {
    this.nombreGimnasio = localStorage.getItem("nombreGimnasio")
    this.logoGimnasio = localStorage.getItem("logoGimnasio")
    this.telefonoGimnasio = localStorage.getItem("telefonoGimnasio")
    this.direccionGimnasio = localStorage.getItem("direccionGimnasio")
  },

  async mounted() {

    await this.generarQR();

    this.d = new Printd()
    const { contentWindow } = this.d.getIFrame();
    contentWindow.addEventListener("beforeprint", () =>
      console.log("before print event!")
    );
    contentWindow.addEventListener("afterprint", () =>
      console.log("after print event!")
    );

    this.imprimir();
  },

  methods: {
    async generarQR() {
      try {
        const datosQR = {
          miembroId: this.miembro.id,
          gimnasioId: localStorage.getItem("idGimnasio"),
          timestamp: Date.now() // Opcional: evita reutilización
        };
        this.qrCodeUrl = await QRCode.toDataURL(JSON.stringify(datosQR));
      } catch (error) {
        console.error("Error al generar QR:", error);
      }
    },
    urlImagen(imagen) {
      return Utiles.generarURL(imagen);
    },

    imprimir() {
      let zona = document.getElementById("credencial-wrapper");
      setTimeout(() => this.d.print(zona, [this.cssText]), 10);
      this.$emit("impreso", false);
    },
  }
}
</script>
<style>
.qr-container {
  margin: 15px auto;
  text-align: center;
  padding: 10px;
  background: white;
  border-radius: 8px;
  width: 140px;
}

.qr-container img {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-left: 15px;
}

#credencial-wrapper {
  display: flex;
  gap: 20px;
  padding: 20px;
  flex-wrap: wrap;
}

.credencial {
  width: 320px;
  height: 420px;
  border-radius: 16px;
  border: 1px solid #ccc;
  background: linear-gradient(145deg, #961c36, #ff6190);
  box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
  padding: 16px;
  box-sizing: border-box;
  font-family: 'Segoe UI', sans-serif;
  position: relative;
}

.credencial-frontal .header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
  justify-content: center;
}

.logo {
  width: 50px;
  height: 50px;
  object-fit: contain;
}

.info-gimnasio {
  font-size: 12px;
  color: #333;
}

.nombre-gimnasio {
  font-weight: bold;
  font-size: 14px;
  margin-bottom: 2px;
}

.contacto-gimnasio {
  line-height: 1.2;
}

.foto-miembro {
  width: 90px;
  height: 90px;
  border-radius: 50%;
  object-fit: cover;
  margin: 0 auto;
  border: 3px solid #fff;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
}

.nombre-miembro {
  text-align: center;
  font-size: 20px;
  margin-top: 10px;
  font-weight: 700;
  color: #222;
}

.matricula {
  text-align: center;
  font-size: 14px;
  color: #666;
  margin-top: 4px;
}

.info-miembro {
  margin-top: 16px;
  font-size: 13px;
  color: #333;
  line-height: 1.4;
}

.credencial-reverso h3 {
  font-size: 16px;
  color: #d00000;
  margin-bottom: 10px;
}

.credencial-reverso p {
  font-size: 13px;
  margin: 4px 0;
  color: #333;
}

.pie {
  position: absolute;
  bottom: 16px;
  left: 0;
  right: 0;
  text-align: center;
}

.logo-sistema {
  width: 120px;
  margin-top: 6px;
  opacity: 0.7;
}
</style>