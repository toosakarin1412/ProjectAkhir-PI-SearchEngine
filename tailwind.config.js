/** @type {import('tailwindcss').Config} */
module.exports = {
    content: [
      "./templates/**/*.html",
      "./static/src/**/*.js"
    ],
    theme: {
      extend: {
        colors: {
          googleBlue: '#4285F4',
          googleRed: '#EA4335',
          googleYellow: '#FBBC05',
          googleGreen: '#34A853',
        },
      },
    },
    plugins: [],
  }