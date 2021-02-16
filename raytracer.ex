#module for vectoroperations in R3
defmodule Vector do

  #scalar multiplication a*v
  def smul({x1, x2, x3}, s) do
    {s*x1, s*x2, s*x3}
  end

  #subtract y from x
  def sub({x1, x2, x3}, {y1, y2, y3}) do
    {x1 - y1 , x2 - y2 , x3 - y3}
  end

  #add two vectors
  def add({x1, x2, x3}, {y1, y2, y3}) do
    {x1 + y1 , x2 + y2 , x3 + y3}
  end

  #norm/length of vector
  def norm({x1, x2, x3}) do
    :math.sqrt(:math.pow(x1,2) + :math.pow(x2,2) + :math.pow(x3,2))
  end

  #scalar product (dot product) scalar value
  def dot({x1, x2, x3}, {y1, y2, y3}) do
    dot_prod = x1*y1 + x2*y2 + x3*y3
  end

  #normalize vector one, i.e length/norm of vector = 1
  def normalize({x1,x2,x3} = x) do
    norm = norm(x)
    normalized = {x1/norm, x2/norm, x3/norm}
  end

end

#ray has an origin represented by normalized vector and direction vecot
defmodule Ray do
  #default value struct
  defstruct pos: {0,0,0}, dir: {1,1,1}
end

#protocol: interface all objects of different types implements.
#protocol achieve polymorhpism, behaviour varies depending on datatype
#as a different object in defined the protocol is instantiated
defprotocol Object do
  #determines if ray intersects with an object
  def intersect(object, ray)
end

#sphere has center in origo, with a radius of 2 as default
defmodule Sphere do
  defstruct center: {0, 0, 0}, radius: 2
end

defimpl Object do

  #checks if ray instersects sphere, returns {:ok, d} where d is closest distance
  #else :no.
  #use defimpl construct to declare this as Obj protol implementation
  #function is reached using call Object.intersect/2
  def intersect(sphere = %Sphere{}, ray = %Ray{}) do
    #get vector k from origin to center of sphere
    k = sphere.center
    #directional vector of ray
    l = ray.dir

    #get dotproduct of k and l
    #i.e projecton of k on directional vector of ray (l)
    a = Vector.dot(k,l)

    #get h, as h^2 + a^2 = k
    h = :math.sqrt(:math.pow(Vector.norm(k), 2) - :math.pow(a,2))

    #get t, midpoint of intserction.
    #if t<0, ray does not intersect, else calculate distance
    # h^2 + t^2 = r^2
     t_pow = :math.pow(sphere.radius, 2) - :math.pow(h,2)

    if t_pow < 0 do
      :no
    else
      t = :math.sqrt(:math.pow(sphere.radius, 2) - :math.pow(h,2))
      d1 = a - t
      d2 = a + t

      cond do
        d1 > 0.0 and d2 > 0.0 ->
          {:ok, min(d1, d2)}
        d1 > 0.0 ->
          {:ok, d1}
        d2 > 0.0 ->
          {:ok, d2}
        true ->
          :no
    end
  end

  #when calculating rays, represent camera by position and vector to upper left corner
  #of canvas c. Two vectors represents pixels moving to right (r) and moving down(d)
  #normalised vektor to any pixel in canvas: pixel(x,y)= c + xr + yd
​
  #camera struct
  defmodule Camera do
    defstruct pos: nil, corner: nil, right: nil, down: nil, size: nil
  end

  #default camera
  def normal(size) do
    {width, height} = size
    d = width * 1.2
    h = width / 2
    v = height / 2
    corner = {-h, v, d}
      right = {1, 0 ,0}
      down = {0, -1, 0}
    %Camera{pos: {0, 0, 0}, corner: corner, right: right down: down size: size)
  end

end
