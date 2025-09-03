<template>
    <v-card class="mt-4">
        <v-card-title>
            <v-icon left>mdi-calendar-clock</v-icon>
            Clases Programadas - Próximos 7 días
        </v-card-title>

        <v-card-text>
            <v-data-table :headers="encabezados" :items="clasesProgramadas" :loading="cargando" sort-by="fecha"
                :items-per-page="10">
                <template v-slot:[`item.fecha`]="{ item }">
                    {{ formatearFecha(item.fecha_hora_inicio) }}
                </template>

                <template v-slot:[`item.hora`]="{ item }">
                    {{ formatearHora(item.fecha_hora_inicio) }} - {{ formatearHora(item.fecha_hora_fin) }}
                </template>

                <template v-slot:[`item.cupos`]="{ item }">
                    <v-chip small :color="getColorCupos(item.cupos_disponibles)">
                        {{ item.cupos_disponibles }}/{{ item.max_participantes }}
                    </v-chip>
                </template>

                <template v-slot:[`item.acciones`]="{ item }">
                    <v-btn small color="primary" @click="verDetalles(item)">
                        <v-icon small>mdi-eye</v-icon>
                        Ver
                    </v-btn>
                </template>

                <template v-slot:no-data>
                    <v-alert type="info">
                        No hay clases programadas para los próximos días.
                    </v-alert>
                </template>
            </v-data-table>
        </v-card-text>
    </v-card>
</template>

<script>
import HttpService from '../../Servicios/HttpService';

export default {
    name: 'ListaClasesProgramadas',

    data: () => ({
        cargando: false,
        clasesProgramadas: [],
        encabezados: [
            { text: 'Clase', value: 'nombre_clase' },
            { text: 'Instructor', value: 'nombre_instructor' },
            { text: 'Sala', value: 'nombre_sala' },
            { text: 'Fecha', value: 'fecha' },
            { text: 'Horario', value: 'hora' },
            { text: 'Duración', value: 'duracion_min' },
            { text: 'Cupos', value: 'cupos' },
            { text: 'Acciones', value: 'acciones', sortable: false }
        ]
    }),

    mounted() {
        this.cargarClasesProgramadas();
    },

    methods: {
        async cargarClasesProgramadas() {
            this.cargando = true;

            try {
                // Obtener fechas para los próximos 7 días
                const hoy = new Date().toISOString().split('T')[0];
                const en7Dias = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString().split('T')[0];

                const payload = {
                    metodo: 'obtener_horarios',
                    fecha_inicio: hoy,
                    fecha_fin: en7Dias
                };

                const respuesta = await HttpService.obtenerConDatos(payload, 'clases.php');
                this.clasesProgramadas = respuesta;

            } catch (error) {
                console.error('Error cargando clases programadas:', error);
                this.$store.commit('mostrarMensaje', {
                    texto: 'Error al cargar clases programadas',
                    color: 'error'
                });
            } finally {
                this.cargando = false;
            }
        },

        formatearFecha(fechaHora) {
            if (!fechaHora) return '';
            const fecha = new Date(fechaHora);
            return fecha.toLocaleDateString('es-ES', {
                weekday: 'short',
                year: 'numeric',
                month: 'short',
                day: 'numeric'
            });
        },

        formatearHora(fechaHora) {
            if (!fechaHora) return '';
            const fecha = new Date(fechaHora);
            return fecha.toLocaleTimeString('es-ES', {
                hour: '2-digit',
                minute: '2-digit'
            });
        },

        getColorCupos(cuposDisponibles) {
            if (cuposDisponibles === 0) return 'error';
            if (cuposDisponibles < 5) return 'warning';
            return 'success';
        },

        verDetalles(clase) {
            // Emitir evento para que el componente padre muestre los detalles
            this.$emit('ver-detalle', clase);
        }
    }
};
</script>