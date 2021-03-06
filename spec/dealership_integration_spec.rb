require('capybara/rspec')
require('./app')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

def create_a_dealership(name)
  visit('/')
  click_link('Add New Dealership')
  fill_in('name', :with => name)
  click_button('Add Dealership')
  click_link('view all dealerships')
end

def create_a_dealership_loop (name)
  visit('/dealerships/new')
  fill_in('name', :with => name)
  click_button('Add Dealership')
end

def create_a_car_in_dealership_loop(name, make, model, year, color, engine_size, number_of_doors)
  visit("/dealerships")
  click_link(name)
  click_link("Add a new vehicle")
  create_car(make, model, year, color, engine_size, number_of_doors)
  click_button("Add Vehicle")
end

def create_car(make, model, year, color, engine_size, number_of_doors)
  fill_in('make', :with => make)
  fill_in('model', :with => model)
  fill_in('year', :with => year)
  fill_in('color', :with => color)
  fill_in('engine_size', :with => engine_size)
  fill_in('number_of_doors', :with => number_of_doors)
end

def expect_page(arr)
  arr.each() do |element|
    expect(page).to have_content(element)
  end
end

describe("viewing the root path", {:type => :feature}) do
  it('renders the index view') do
    visit('/')
    expect(page).to have_content('Welcome to the Dealership Central')
  end

  it('goes to add a new dealership') do
    visit('/')
    click_link('Add New Dealership')
    expect(page).to have_content('Add dealerships')
  end

  it('looks at all the dealerships') do
    visit('/')
    click_link('See Dealership List')
    expect(page).to have_content('Dealerships')
  end

  it('creates a dealership') do
    visit('/')
    click_link('Add New Dealership')
    fill_in('name', :with => "Bob's Dealership")
    click_button('Add Dealership')
    expect_page(["Success!", "go home", "view all dealerships"])
  end

  it('creates a dealership and looks at it') do
    visit('/')
    click_link('Add New Dealership')
    fill_in('name', :with => "Bob's Dealership")
    click_button('Add Dealership')
    click_link('view all dealerships')
    expect(page).to have_content("Bob's Dealership")
  end

  it('looks at a dealership') do
    create_a_dealership("Bob")
    click_link("Bob")
    expect(page).to have_content("Here are all the cars in this dealership:")
  end

  it('views the new car form') do
    create_a_dealership("Mike")
    click_link("Mike")
    click_link("Add a new vehicle")
    expect(page).to have_content("Add a vehicle to Mike")
  end

  it('adds a car to a dealership') do
    create_a_dealership("Bucky")
    click_link("Bucky")
    click_link("Add a new vehicle")
    create_car('volvo', '244', '1979', 'red', '1.5L', '4')
    click_button('Add Vehicle')
    expect_page(["Success!", "go home", "view all dealerships"])
  end

  it("add a dealership and then add a car to that dealership") do
    create_a_dealership_loop("Matt's Dealership")
    create_a_car_in_dealership_loop("Matt's Dealership", "Audi", "A3", "2013", "silver", "2.0L", "4")
    create_a_car_in_dealership_loop("Matt's Dealership", "volkswagon", "jetta TDI", "2002", "blue", "2.0L", "4")
    visit("/dealerships")
    click_link("Matt's Dealership")
    expect_page(["Here are all the cars in this dealership:", "Audi A3 2013", "volkswagon jetta TDI 2002"])
  end


end
