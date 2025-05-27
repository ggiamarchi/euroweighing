<script setup></script>

<template>
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
        <td>
          <input type="text" @input="update10" />
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
        <td>
          <input type="text" @input="update20" />
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
        <td>
          <input type="text" @input="update50" />
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
        <td>
          <input type="text" @input="update1" />
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
        <td>
          <input type="text" @input="update2" />
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
    update10(event) {
      updateTotal(this, 0.1, 'coinCount10', 'amount10', 'message10', event.target.value)
    },
    update20(event) {
      updateTotal(this, 0.2, 'coinCount20', 'amount20', 'message20', event.target.value)
    },
    update50(event) {
      updateTotal(this, 0.5, 'coinCount50', 'amount50', 'message50', event.target.value)
    },
    update1(event) {
      updateTotal(this, 1, 'coinCount1', 'amount1', 'message1', event.target.value)
    },
    update2(event) {
      updateTotal(this, 2, 'coinCount2', 'amount2', 'message2', event.target.value)
    },
  },
}
</script>

<style scoped>
table {
  font-size: 2em;
  margin-top: 10px;
  margin-left: 10px;
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

input {
  font-size: 1.5em;
  width: 100%;
  background-color: rgb(246, 255, 152);
  border: 0;
  border-radius: 20px;
  padding-left: 10px;
  padding-right: 10px;
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
}
</style>
