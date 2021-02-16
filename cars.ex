#demo of tuples to structs
defmodule Cars do
  #Metod 1: representera bil med dess egenskaper som tupel
  #otympligt om egenskaper behövs läggas till
  def a1() do
    {:car, "Volvo",
      {:model, "XC60", 2018},
      {:engine, "A4", 4, 2000, 140},
      {:perf, 4.6, 8.8}
    }
  end

  #en sådan funktion för varje egenskap
  def car_brand_model_1({:car, brand, {:model, model, _}, _,_}) do
    "#{brand} #{model}"
  end

  #Metod 2: representera bil som en tupel, med egenskaperna i en lista (i tupel)
  #enklare att lägga till egenskaper
  def a2() do
    {:car, "Volvo",
      [{:model, "Typ-1"}, {:year, 1964},{:engine, "1300"},
      {:cyl, 4}, {:vol, 1300}, {:power, 40},
      {:fuel, 4.6}, {:acc, 12.8}]
    }
  end

  #hitta egenskaper genom property listan
  #keyfind, matcha till tupeln med model-proprty (in first slot), returnera modellen i tupeln
  #trots ändringar i propertieslistan behövs denna funktion inte förndras.
  #linjär sökning
  def car_brand_model_2({:car, brand, prop}) do
    case List.keyfind(prop, :model, 0) do
      nil ->
        brand
      {:model, model} ->
        "#{brand} #{model}"
      end
  end

  #Metod 3: NY datastruktur, maps
  # %{ x => y}, ordnas på ett effektivt sätt (trädliknande struktur i underthehood impl.) däremed snabb uppslag
  def a3() do
    {:car, "VW",
      %{:model => "Type-1", :year => 1964, :engine => "1300",
       :cyl => 4, :vol => 1300, :power => 40,
       :fuel => 4.6, :acc => 12.8}}
  end

  #mha maps struktur kan mönstermatchning göras
  def car_brand_model_3({:car, brand, prop}) do
    case prop do
      %{:mode => model} ->
        "#{brand} #{model}"
      _ ->
        brand
    end
  end

  #kan förenklas ner till denna funktion (förutsatt at model/angivet egenskap verkligen finns)
  def car_brand_model_3({:car, brand, %{:model =>model}}) do
    "#{brand} #{model}"
  end

  #Metod 4: Structs, en carstruct med dessa egenskaper (ange default värden)
  # mycket nära statiska språk
  defstruct brand: "", year: :na, model: "unknown", cyl: :na, power: :na

  def a4() do
    %Cars{:brand => "SAAB", :model => "96 V4", :year => 1974, :power => 65, :cyl => 4}
  end

  #annorlunda struktur i argumentet
  #om carstruct, plocka ut brand och model
  def car_brand_model_4(%Cars{brand: brand, model: model}) do
    "#{brand}, #{model}"
  end

  #vi kan använda strukt.egenskap för att slå upp properties
  def year(car = %Cars{}) do
    car.year
  end
end
