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
    :math.sqrt(x1*x1 + x2*x2 + x3*x3)
  end

  #scalar product (dot product) scalar value
  def dot({x1, x2, x3}, {y1, y2, y3}) do
    dot_prod = x1*y1 + x2*y2 + x3*y3
  end

  #normalize vector one, i.e length/norm of vector = 1
  def normalize(x) do
    norm = norm(x)
    smul(x, 1/norm)
  end

end

#ray has an origin represented by normalized vector and direction vecot
defmodule Ray do
  #default value struct
  defstruct pos: {0,0,0}, dir: {1,1,1}
end

#protocol: interface all objects of different types implements.
#protocol achieves polymorhpism, behaviour varies depending on datatype
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
    k = Vector.sub(sphere.center - ray.pos)

    #get dotproduct of k and l
    #i.e projecton of k on directional vector of ray (l)
    a = Vector.dot(k,ray.dir)

    #get h, as h^2 + a^2 = k
    h = :math.sqrt(:math.pow(Vector.norm(k), 2) - :math.pow(a,2))

    #get t, 1/2 length of intersecting portion of ray
    # h^2 + t^2 = r^2
     t_pow = :math.pow(sphere.radius, 2) - :math.pow(h,2)

    #check min distance
    #if t<0, ray does not intersect, else calculate distance
    #if t = 0, our ray touches one point
    #minimum distance is first point of intersection
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
  end
end

#properties of camera: a position in space, direction (unit vector) and size of pic,
#focal length (distance to canvas), resolution (pizles per distance)

#when calculating rays, represent camera by position and vector to upper left corner
#of canvas c. Two vectors represents pixels moving to right (r) and moving down(d)
#normalised vektor to any pixel in canvas: pixel(x,y)= c + xr + yd


#camera struct
defmodule Camera do
  defstruct pos: nil, corner: nil, right: nil, down: nil, size: nil


  #default camera values
  def normal(size) do
    {width, height} = size
    #arbitrary d?
    d = width * 1.2
    h = width / 2
    v = height / 2
    #left horisontal, v up, d depth in;
    #corner is top left corner on canvas
    corner = {-h, v, d}
    #right is postive x-axis
    #down is negative y-axis directiong
    right = {1, 0 ,0}
    down = {0, -1, 0}
    %Camera{pos: {0, 0, 0}, corner: corner, right: right, down: down, size: size}
  end

    #given a camera, calculate a ray that passes through given coordinate/pixel
  def ray(camera, col, row) do
    origin = {0,0,0}   # the origin of the ray
    x_pos = Vector.smul(camera.right, col)    # a vector from the corner to the x column
    y_pos = Vector.smul(camera.down, row)     # a vector from the corner to the y row
        v = Vector.add(x_pos, y_pos)           #vector going from topleft corner to pixel
        p = Vector.add(camera.corner,y_pos)    # a vector from origin to the pixle
      dir = Vector.normalize(p)      # the normalized vector (from origin poting towards pixel)
      %Ray{pos: origin, dir: dir}
  end
end
