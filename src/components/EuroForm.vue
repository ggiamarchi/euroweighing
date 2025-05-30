<script setup></script>

<template>
  <div style="padding-top: 20px; padding-left: 50px; padding-right: 50px">
    <table width="100%">
      <thead>
        <tr>
          <th><div>Pièce</div></th>
          <th><div>Poids (g)</div></th>
          <th><div>Nombre</div></th>
          <th><div>Montant</div></th>
        </tr>
        <tr>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="value">0,10 €</td>
          <td class="button-container">
            <input
              class="input-weight"
              type="text"
              inputmode="numeric"
              pattern="\d*"
              v-model="weightRaw10"
              @input="update10"
            />
            <input class="clear-button" type="button" value="X" @click="erase10" />
          </td>
          <td class="value">{{ coinCount10 }}</td>
          <td class="value">{{ amount10 }} €</td>
        </tr>
        <tr>
          <td></td>
          <td colspan="3" class="error">{{ message10 }}</td>
        </tr>
        <tr>
          <td class="value">0,20 €</td>
          <td class="button-container">
            <input
              class="input-weight"
              type="text"
              inputmode="numeric"
              pattern="\d*"
              v-model="weightRaw20"
              @input="update20"
            />
            <input class="clear-button" type="button" value="X" @click="erase20" />
          </td>
          <td class="value">{{ coinCount20 }}</td>
          <td class="value">{{ amount20 }} €</td>
        </tr>
        <tr>
          <td></td>
          <td colspan="3" class="error">{{ message20 }}</td>
        </tr>
        <tr>
          <td class="value">0,50 €</td>
          <td class="button-container">
            <input
              class="input-weight"
              type="text"
              inputmode="numeric"
              pattern="\d*"
              v-model="weightRaw50"
              @input="update50"
            />
            <input class="clear-button" type="button" value="X" @click="erase50" />
          </td>
          <td class="value">{{ coinCount50 }}</td>
          <td class="value">{{ amount50 }} €</td>
        </tr>
        <tr>
          <td></td>
          <td colspan="3" class="error">{{ message50 }}</td>
        </tr>
        <tr>
          <td class="value">1 €</td>
          <td class="button-container">
            <input
              class="input-weight"
              type="text"
              inputmode="numeric"
              pattern="\d*"
              v-model="weightRaw1"
              @input="update1"
            />
            <input class="clear-button" type="button" value="X" @click="erase1" />
          </td>
          <td class="value">{{ coinCount1 }}</td>
          <td class="value">{{ amount1 }} €</td>
        </tr>
        <tr>
          <td></td>
          <td colspan="3" class="error">{{ message1 }}</td>
        </tr>
        <tr>
          <td class="value">2 €</td>
          <td class="button-container">
            <input
              class="input-weight"
              type="text"
              inputmode="numeric"
              pattern="\d*"
              v-model="weightRaw2"
              @input="update2"
            />
            <input class="clear-button" type="button" value="X" @click="erase2" />
          </td>
          <td class="value">{{ coinCount2 }}</td>
          <td class="value">{{ amount2 }} €</td>
        </tr>
        <tr>
          <td></td>
          <td colspan="3" class="error">{{ message2 }}</td>
        </tr>
        <tr>
          <td></td>
          <td colspan="2" class="total total-left">Montant total</td>
          <td class="numeric total total-right">{{ totalAmount }} €</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
const WEIGTHS = { 0.1: 4.1, 0.2: 5.74, 0.5: 7.8, 1: 7.5, 2: 8.5 }

var roundToTwoDecimals = function (num) {
  return Math.round((num + Number.EPSILON) * 100) / 100
}

var parseDecimal = function (str) {
  let cleaned = str.replace(/\s+/g, '')
  cleaned = cleaned.replace(',', '.')
  if (!/^[-+]?\d*\.?\d+$/.test(cleaned)) {
    return NaN
  }
  return parseFloat(cleaned)
}

var updateTotal = function (
  ctx,
  coinValue,
  coinCountVariable,
  amountVariable,
  messageVariable,
  weightRaw,
) {
  console.log(coinValue + ' | ' + coinCountVariable + ' | ' + 'weight = ', weightRaw)

  var weight = parseDecimal(weightRaw)

  if (isNaN(weight)) {
    console.log('Invalid weight input:', weightRaw)
    ctx[coinCountVariable] = -1
    ctx[amountVariable] = 0
    ctx[messageVariable] = 'Erreur de saisie : le poids doit être un nombre.'
    return
  }

  var coinCount = weight / WEIGTHS[coinValue]

  console.log('coinCount = ' + coinCount)

  // Partie entière
  let partieEntiere = Math.trunc(coinCount)

  // Partie décimale
  let partieDecimale = Math.abs(coinCount - partieEntiere)

  if (partieDecimale > 0.7) {
    ctx[coinCountVariable] = partieEntiere + 1
    ctx[messageVariable] = ''
  } else if (partieDecimale < 0.3) {
    ctx[coinCountVariable] = partieEntiere
    ctx[messageVariable] = ''
  } else {
    // TODO Measure not precise enough : DO SOMETHING
    console.log('ERROR')
    ctx[coinCountVariable] = -1
    ctx[messageVariable] = 'Erreur de mesure : vérifiez votre balance et le type de pièce.'
    ctx.totalAmount = 0
  }

  console.log('coinCount = ' + ctx[coinCountVariable])

  if (ctx[coinCountVariable] < 0) {
    ctx[amountVariable] = 0
    return
  }

  ctx[amountVariable] = roundToTwoDecimals(ctx[coinCountVariable] * coinValue)

  // sum ctx.amount10 + ctx.amount20 + ctx.amount50 + ctx.amount1 + ctx.amount2
  let totalAmount = roundToTwoDecimals(
    ctx.amount10 + ctx.amount20 + ctx.amount50 + ctx.amount1 + ctx.amount2,
  )

  ctx.totalAmount = totalAmount
}

export default {
  data() {
    return {
      totalAmount: 0,
      weightRaw10: '',
      weightRaw20: '',
      weightRaw50: '',
      weightRaw1: '',
      weightRaw2: '',
      amount10: 0,
      amount20: 0,
      amount50: 0,
      amount1: 0,
      amount2: 0,
      coinCount10: 0,
      coinCount20: 0,
      coinCount50: 0,
      coinCount1: 0,
      coinCount2: 0,
      message10: '',
      message20: '',
      message50: '',
      message1: '',
      message2: '',
    }
  },
  methods: {
    update10() {
      updateTotal(this, 0.1, 'coinCount10', 'amount10', 'message10', this.weightRaw10)
    },
    update20() {
      updateTotal(this, 0.2, 'coinCount20', 'amount20', 'message20', this.weightRaw20)
    },
    update50() {
      updateTotal(this, 0.5, 'coinCount50', 'amount50', 'message50', this.weightRaw50)
    },
    update1() {
      updateTotal(this, 1, 'coinCount1', 'amount1', 'message1', this.weightRaw1)
    },
    update2() {
      updateTotal(this, 2, 'coinCount2', 'amount2', 'message2', this.weightRaw2)
    },
    erase10() {
      this.weightRaw10 = ''
      this.message10 = ''
      this.coinCount10 = 0
      this.amount10 = 0
      this.totalAmount = roundToTwoDecimals(
        this.amount20 + this.amount50 + this.amount1 + this.amount2,
      )
    },
    erase20() {
      this.weightRaw20 = ''
      this.message20 = ''
      this.coinCount20 = 0
      this.amount20 = 0
      this.totalAmount = roundToTwoDecimals(
        this.amount10 + this.amount50 + this.amount1 + this.amount2,
      )
    },
    erase50() {
      this.weightRaw50 = ''
      this.message50 = ''
      this.coinCount50 = 0
      this.amount50 = 0
      this.totalAmount = roundToTwoDecimals(
        this.amount10 + this.amount20 + this.amount1 + this.amount2,
      )
    },
    erase1() {
      this.weightRaw1 = ''
      this.message1 = ''
      this.coinCount1 = 0
      this.amount1 = 0
      this.totalAmount = roundToTwoDecimals(
        this.amount10 + this.amount20 + this.amount50 + this.amount2,
      )
    },
    erase2() {
      this.weightRaw2 = ''
      this.message2 = ''
      this.coinCount2 = 0
      this.amount2 = 0
      this.totalAmount = roundToTwoDecimals(
        this.amount10 + this.amount20 + this.amount50 + this.amount1,
      )
    },
    eraseAll() {
      this.weightRaw10 = ''
      this.weightRaw20 = ''
      this.weightRaw50 = ''
      this.weightRaw1 = ''
      this.weightRaw2 = ''
      this.message10 = ''
      this.message20 = ''
      this.message50 = ''
      this.message1 = ''
      this.message2 = ''
      this.coinCount10 = 0
      this.coinCount20 = 0
      this.coinCount50 = 0
      this.coinCount1 = 0
      this.coinCount2 = 0
      this.amount10 = 0
      this.amount20 = 0
      this.amount50 = 0
      this.amount1 = 0
      this.amount2 = 0
      this.totalAmount = 0
    },
  },
}
</script>

<style scoped>
table {
  font-size: 2em;
  margin-top: 10px;
}

table th {
  text-align: center;
  padding-left: 10px;
  padding-right: 10px;
  padding-bottom: 20px;
  color: white;
  font-weight: bold;
}

table div {
  text-align: center;
  padding-left: 30px;
  padding-right: 30px;
  padding-top: 10px;
  padding-bottom: 10px;
  font-weight: bold;
  border-radius: 40px;
  background-color: #999;
}

.input-weight {
  font-size: 1.5em;
  /* width: 100%; */
  background-color: rgb(246, 255, 152);
  border: 0;
  border-radius: 20px 0 0 20px;

  /* border-radius: 20px; */
  padding-left: 10px;
  padding-right: 10px;
  flex: 1; /* occupe tout l'espace restant */
}

.button-container {
  display: flex;
  width: 100%; /* occupe toute la largeur du parent */
  padding-left: 10px;
  padding-right: 10px;
}

.fixed-width {
  width: 150px; /* largeur fixe */
}

.flexible-width {
  flex: 1; /* occupe tout l'espace restant */
}

.clear-button {
  cursor: pointer;
  color: white;
  font-weight: bold;
  font-family: monospace;
  text-align: center;
  font-size: 1.5em;
  background-color: rgb(255, 112, 112);
  border: 0;
  border-radius: 10px;
  padding-left: 10px;
  padding-right: 10px;
  border-radius: 0 20px 20px 0;
}

.value {
  text-align: right;
  padding-right: 30px;
}

.total {
  background-color: #ffae22;
  color: white;
  font-weight: bold;
  font-size: 1.2em;
  text-align: right;
  padding-right: 20px;
}

.total-left {
  border-radius: 20px 0 0 20px;
}

.total-right {
  border-radius: 0 20px 20px 0;
}

.error {
  color: red;
  height: 40px;
  font-size: 0.6em;
  padding-left: 10px;
}
</style>
