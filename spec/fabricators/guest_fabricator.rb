Fabricator(:guest) do
  name { sequence(:name) { |seq| "Guest-#{seq}" } }
  custom_attributes do
    {
      height: '100cm',
      foo: 'bar'
    }
  end
end
