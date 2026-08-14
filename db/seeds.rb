products = [
  { name: "chokochipcookie", price: 3000, image_url: "products/chokochipcookie.jpg" },
  { name: "chocopie", price: 5000, image_url: "products/chocopie.jpg" },
  { name: "chocohaim", price: 4000, image_url: "products/chocohaim.jpg" }
]

products.each do |attributes|
  product = Product.find_or_initialize_by(name: attributes[:name])
  product.update!(attributes)
end
