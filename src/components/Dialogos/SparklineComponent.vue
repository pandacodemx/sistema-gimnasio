<template>
  <v-card>
    <v-sheet class="v-sheet--offset mx-auto" color="gray" elevation="6" max-width="calc(100% - 32px)">
      <v-sparkline :labels="etiquetas" :value="valores" :color="color" line-width="3" padding="16" :gradient="gradient"
        :smooth="radius || false" :stroke-linecap="lineCap" :gradient-direction="gradientDirection" :fill="fill"
        :type="type" :auto-line-width="autoLineWidth" auto-draw></v-sparkline>
    </v-sheet>

    <v-card-text class="pt-0">
      <div class="text-h6 font-weight-light  white--text mb-2 mt-4">{{ titulo }}</div>
      <v-divider class="my-2"></v-divider>
      <span class="text-caption white--text font-weight-light">{{
        subtitulo
      }}</span>
      <v-simple-table>
        <template v-slot:default>
          <thead>
            <tr>
              <th v-for="(etiqueta, index) in etiquetas" :key="index">{{ etiqueta }}</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td v-for="(valor, index) in valores" :key="index">{{ valor }}</td>
            </tr>
          </tbody>
        </template>
      </v-simple-table>
    </v-card-text>
  </v-card>
</template>
<script>

const gradients = [
  ['#222'],
  ['#42b3f4'],
  ['red', 'orange', 'yellow'],
  ['purple', 'violet'],
  ['#00c6ff', '#F0F', '#FF0'],
  ['#f72047', '#ffd200', '#1feaea'],
]
export default {
  name: "SparklineComponent",
  props: ["etiquetas", "valores", "color", "titulo", "subtitulo"],
  data: () => ({
    width: 2,
    radius: 10,
    padding: 8,
    lineCap: 'round',
    value: [0, 2, 5, 9, 5, 10, 3, 5, 0, 0, 1, 8, 2, 9, 0],
    fill: false,
    type: 'trend',
    autoLineWidth: false,
    gradientDirection: 'to right',
  }),
};
</script>