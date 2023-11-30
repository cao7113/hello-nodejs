// main.js
import { mod1Function, mod1Function2 } from './mod1.js'
// import { mod1Function as funct1, mod1Function2 as funct2 } from './mod1.js'
// import * as mod1 from './mod1.js'

const testFunction = () => {
    console.log('Im the main function')
    mod1Function()
    mod1Function2()
}

testFunction()