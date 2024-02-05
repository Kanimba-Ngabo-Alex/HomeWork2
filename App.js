import React, { useState } from 'react';
import { StyleSheet, Text, View, TouchableOpacity } from 'react-native';
import { evaluate } from 'mathjs';

const Button = ({ onPress, text, buttonStyle, isOperationButton }) => (
  <TouchableOpacity style={[styles.button, buttonStyle]} onPress={onPress}>
    <Text style={[styles.buttonText, isOperationButton && styles.operationButtonText]}>{text}</Text>
  </TouchableOpacity>
);

const ButtonRow = ({ buttons }) => (
  <View style={styles.buttonRow}>
    {buttons.map(({ text, onPress, buttonStyle, isOperationButton }) => (
      <Button key={text} onPress={onPress} text={text} buttonStyle={buttonStyle} isOperationButton={isOperationButton} />
    ))}
  </View>
);

const App = () => {
  const [expression, setExpression] = useState('');
  const [result, setResult] = useState('');

  const handlePress = (value) => {
    if (value === '=') {
      try {
        const res = evaluate(expression);
        setResult(res.toString());
      } catch (error) {
        setResult('Error');
      }
    } else if (value === 'C') {
      setExpression('');
      setResult('');
    } else {
      setExpression(prevExpression => prevExpression + value);
    }
  };

  const buttons = [
    [{ text: 'C', buttonStyle: styles.clearButton, isOperationButton: false }],
    [{ text: '7' }, { text: '8' }, { text: '9' }, { text: '/', buttonStyle: styles.operationButton, isOperationButton: true }],
    [{ text: '4' }, { text: '5' }, { text: '6' }, { text: '*', buttonStyle: styles.operationButton, isOperationButton: true }],
    [{ text: '1' }, { text: '2' }, { text: '3' }, { text: '-', buttonStyle: styles.operationButton, isOperationButton: true }],
    [{ text: '0' }, { text: '.' }, { text: '=', buttonStyle: styles.equalButton }, { text: '+', buttonStyle: styles.operationButton, isOperationButton: true }],    
  ];

  return (
    <View style={styles.container}>
      <Text style={styles.expression}>{expression}</Text>
      <Text style={styles.result}>{result}</Text>
      {buttons.map((row, index) => (
        <ButtonRow key={index} buttons={row.map(button => ({ ...button, onPress: () => handlePress(button.text) }))} />
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#fff',
  },
  buttonRow: {
    flexDirection: 'row',
  },
  button: {
    flex: 1,
    padding: 20,
    justifyContent: 'center',
    alignItems: 'center',
    margin: 5,
    borderRadius: 5,
    backgroundColor: '#242424',
  },
  buttonText: {
    color: '#fff',
    fontSize: 20,
  },
  operationButtonText: {
    color: '#000',
  },
  clearButton: {
    backgroundColor: '#055584',
  },
  operationButton: {
    backgroundColor: '#AAAAAA',
  },
  equalButton: {
    backgroundColor: '#732A21',
  },
  expression: {
    fontSize: 24,
    marginBottom: 10,
  },
  result: {
    fontSize: 36,
    fontWeight: 'bold',
  },
});

export default App;
