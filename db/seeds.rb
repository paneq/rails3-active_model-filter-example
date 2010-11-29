Car.create!(:producent => "Volkswagen", :brand => "Golf", :color => "ffffff", :max_speed => BigDecimal.new("170.10"), :valid_from => "2010-01-01", :valid_to => "2010-12-31")
Car.create!(:producent => "Volkswagen", :brand => "Golf", :color => "000000", :max_speed => BigDecimal.new("189.10"), :valid_from => "2010-02-01", :valid_to => "2010-11-30")

Car.create!(:producent => "Volkswagen", :brand => "Polo", :color => "ff0000", :max_speed => BigDecimal.new("140.60"), :valid_from => "2010-03-01", :valid_to => "2010-10-31")
Car.create!(:producent => "Volkswagen", :brand => "Polo", :color => "00ff00", :max_speed => BigDecimal.new("101.10"), :valid_from => "2008-05-01", :valid_to => "2012-12-31")
Car.create!(:producent => "Volkswagen", :brand => "Polo", :color => "0000ff", :max_speed => BigDecimal.new("111.30"), :valid_from => "2010-04-01", :valid_to => "2010-09-30")

Car.create!(:producent => "Volkswagen", :brand => "Jetta", :color => "223344", :max_speed => BigDecimal.new("123.10"), :valid_from => "2010-07-01", :valid_to => "2011-03-31")