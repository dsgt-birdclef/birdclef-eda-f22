module.exports = function (eleventyConfig) {
  return {
    dir: {
      input: "../users",
      output: "dist",
      includes: "../site/_includes",
      data: "../site/_data",
    },
  };
};
