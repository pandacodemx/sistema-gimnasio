<template>
    <div class="miembros">
        <v-card class="scanner-wrapper">
            <v-card-title class="headline">
                <v-icon left>mdi-qrcode-scan</v-icon>
                Escáner de Asistencias
            </v-card-title>

            <div class="scanner-container">
                <video ref="video" width="100%" autoplay playsinline></video>
                <canvas ref="canvas" style="display:none;"></canvas>
            </div>

            <v-card-actions>
                <v-btn @click="startScanner" color="primary" :loading="loading" :disabled="isScanning">
                    <v-icon left>mdi-camera</v-icon>
                    {{ isScanning ? 'Escaneando...' : 'Iniciar Escáner' }}
                </v-btn>
                <v-btn @click="stopScanner" color="error" :disabled="!isScanning">
                    <v-icon left>mdi-stop</v-icon>
                    Detener
                </v-btn>
            </v-card-actions>

            <v-snackbar v-model="showAlert" :color="alertType" top>
                {{ alertMessage }}
                <template v-slot:action="{ attrs }">
                    <v-btn text v-bind="attrs" @click="showAlert = false">Cerrar</v-btn>
                </template>
            </v-snackbar>
        </v-card>
    </div>
</template>

<script>
import jsQR from 'jsqr';
import HttpService from '../../Servicios/HttpService';

export default {
    data: () => ({
        isScanning: false,
        showAlert: false,
        alertMessage: '',
        alertType: 'info',
        loading: false,
        stream: null,
        scanInterval: null
    }),

    methods: {
        async startScanner() {
            try {
                this.loading = true;
                this.stream = await navigator.mediaDevices.getUserMedia({
                    video: { facingMode: "environment" }
                });
                this.$refs.video.srcObject = this.stream;
                this.isScanning = true;

                this.scanInterval = setInterval(this.processFrame, 200);

            } catch (error) {
                this.showError('No se pudo acceder a la cámara: ' + error.message);
            } finally {
                this.loading = false;
            }
        },

        processFrame() {
            try {
                const video = this.$refs.video;
                const canvas = this.$refs.canvas;

                if (video.readyState !== 4) return;

                canvas.width = video.videoWidth;
                canvas.height = video.videoHeight;

                const ctx = canvas.getContext('2d');
                ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

                const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
                const code = jsQR(imageData.data, imageData.width, imageData.height);

                if (code) {
                    this.handleQRCode(code.data);
                }
            } catch (error) {
                console.error("Error en processFrame:", error);
            }
        },

        async handleQRCode(data) {
            try {
                const qrData = JSON.parse(data);
                if (!qrData.miembroId) throw new Error('QR no válido');

                this.alertMessage = 'Registrando visita...';
                this.alertType = 'info';
                this.showAlert = true;

                const payload = {
                    metodo: "registrar",
                    visita: {
                        idMiembro: qrData.miembroId,
                        idUsuario: localStorage.getItem("idUsuario"),
                        // idMembresia: Opcional (puede omitirse si la función lo obtiene de la BD)
                    }
                };

                const resultado = await HttpService.registrar(payload, "visitas.php");

                if (resultado) {
                    this.alertType = 'success';
                    this.alertMessage = `Visita registrada para ID: ${qrData.miembroId}`;
                    this.stopScanner();

                    // Opcional: reproducir sonido de éxito
                    this.playSound('success');
                }

            } catch (error) {
                this.showError(error.message);
                this.playSound('error');
            }
        },

        stopScanner() {
            if (this.stream) {
                this.stream.getTracks().forEach(track => track.stop());
            }
            if (this.scanInterval) {
                clearInterval(this.scanInterval);
            }
            this.isScanning = false;
            this.$refs.video.srcObject = null;
        },

        showError(message) {
            this.alertType = 'error';
            this.alertMessage = message;
            this.showAlert = true;
            this.stopScanner();
        },

        playSound(type) {
            const sounds = {
                success: 'https://assets.mixkit.co/sfx/preview/mixkit-achievement-bell-600.mp3',
                error: 'https://assets.mixkit.co/sfx/preview/mixkit-alarm-digital-clock-beep-989.mp3'
            };
            new Audio(sounds[type]).play();
        }
    },

    beforeDestroy() {
        this.stopScanner();
    }
};
</script>

<style scoped>
.miembros {
    padding: 30px;
    background-color: #1e1e1e;
    border-radius: 12px;
    min-height: 100vh;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
}

.scanner-wrapper {
    max-width: 800px;
    margin: 20px auto;
    padding: 20px;
}

.scanner-container {
    position: relative;
    margin: 20px 0;
    border: 2px solid #eee;
    border-radius: 8px;
    overflow: hidden;
    background: #000;
    min-height: 300px;
    display: flex;
    align-items: center;
    justify-content: center;
}

video {
    width: 100%;
    max-height: 500px;
    display: block;
}
</style>