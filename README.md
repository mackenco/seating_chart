# seating_chart

A teacher friend asked me for a script that could generate a seating chart for her classroom. Given a roster of <= 35 students, a 5x7 dimension room, and rules regarding who cannot sit within a two desk radius of whom, return a seating chart.

This is the quickest and dirtiest implementation possible - generates a random seating chart, checks the validity student by student, if invalid, generates a new random seating chart. 
