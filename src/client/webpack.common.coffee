
WebpackBar=require "webpackbar"
HtmlWebpackPlugin = require "html-webpack-plugin"
CopyPlugin = require "copy-webpack-plugin"
webpack=require "webpack"
LodashModuleReplacementPlugin = require 'lodash-webpack-plugin'

module.exports=
	performance:
		hints: false
	entry: [
		"#{__dirname}/scripts/index.coffee"
		"#{__dirname}/styles/style.scss"
		"bootstrap"
	]
	output:
		path: "#{__dirname}/dist"
		filename: '[contenthash].js'
	performance:
		maxEntrypointSize: 1.5e6
		maxAssetSize: 1.5e6
	module:
		rules: [
			{
				loader: "worker-loader"
				test: /\.worker\.coffee$/
				options:
					filename: "[contenthash].js"
			}
			{
				test: /\.coffee$/
				loader: 'coffee-loader'
			}
			{
				test: /\.(scss)$/
				use: [
					{
						loader: 'style-loader'
					}
					{
						loader: 'css-loader'
					}
					{
						loader: 'postcss-loader'
						options: 
							plugins: ()->
								return [
									require 'autoprefixer'
								]
					}
					{
						loader: 'sass-loader'
					}
				]
			}
			{
				test: /\.css$/i
				use: ["style-loader", "css-loader"]
			}
			{
				test: /\.(png|jpe?g|gif)$/i
				use: [
					{
						loader: 'file-loader'
					}
				]
			}
		]
	plugins:[
		new webpack.ProvidePlugin({
			$: 'jquery'
			jQuery: 'jquery'
		})
		new HtmlWebpackPlugin({
			filename: "index.html"
			template: "#{__dirname}/html/index.html"
			inject: "head"
			favicon: "#{__dirname}/assets/images/favicon.png"
		})
		new LodashModuleReplacementPlugin()
		new WebpackBar()
		new CopyPlugin({
			patterns: [
				{ from: "#{__dirname}/assets", to: "assets" }
			]
		})
	]