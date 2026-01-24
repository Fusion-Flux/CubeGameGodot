extends Node

static func easeInSine(x: float) -> float :
	return 1 - cos((x * PI) / 2);

static func easeOutSine(x: float) -> float :
	return sin((x * PI) / 2);

static func easeInOutSine(x: float) -> float :
	return -(cos(PI * x) - 1) / 2;

static func easeInCubic(x: float) -> float :
	return x * x * x;

static func easeOutCubic(x: float) -> float :
	return 1 - (1 - x)** 3;

static func easeInOutCubic(x: float) -> float :
	return 4 * x * x * x  if x < 0.5 else 1 - (-2 * x + 2) ** 3 / 2;

static func easeInQuint(x: float) -> float :
	return x * x * x * x * x;

static func easeOutQuint(x: float) -> float :
	return 1 - (1 - x) ** 5;

static func easeInOutQuint(x: float) -> float :
	return 16 * x * x * x * x * x if x < 0.5 else 1 - (-2 * x + 2) ** 5 / 2;

static func easeInCirc(x: float) -> float :
	return 1 - sqrt(1 - pow(x, 2));

static func easeOutCirc(x: float) -> float :
	return sqrt(1 - pow(x - 1, 2));

static func easeInOutCirc(x: float) -> float :
	return (1 - sqrt(1 - pow(2 * x, 2))) / 2 if x < 0.5 else (sqrt(1 - pow(-2 * x + 2, 2)) + 1) / 2;

static func easeInElastic(x: float) -> float :
	const c4 = (2 * PI) / 3;

	return 0.0 if x == 0 else (1.0 if x == 1 else -pow(2, 10 * x - 10) * sin((x * 10 - 10.75) * c4))

static func easeOutElastic(x: float) -> float :
	const c4 = (2 * PI) / 3;

	return 0.0 if x == 0 else (1.0 if x == 1 else pow(2, -10 * x) * sin((x * 10 - 0.75) * c4) + 1)

static func easeInOutElastic(x: float) -> float :
	const c5 = (2 * PI) / 4.5;

	return 0.0 if x == 0 else 1.0 if x == 1 else -(pow(2, 20 * x - 10) * sin((20 * x - 11.125) * c5)) / 2 if x < 0.5 else (pow(2, -20 * x + 10) * sin((20 * x - 11.125) * c5)) / 2 + 1;

static func easeInQuad(x: float) -> float :
	return x * x;

static func easeOutQuadeaseInQuad(x: float) -> float :
	return 1 - (1 - x) * (1 - x);

static func easeInOutQuad(x: float) -> float :
	return 2 * x * x if  x < 0.5  else 1 - (-2 * x + 2)**2 / 2

static func easeInQuart(x: float) -> float :
	return x * x * x * x;

static func easeOutQuart(x: float) -> float :
	return 1 - pow(1 - x, 4);

static func easeInOutQuart(x: float) -> float :
	return 8 * x * x * x * x if x < 0.5 else 1 - pow(-2 * x + 2, 4) / 2;

static func easeInExpo(x: float) -> float :
	return 0.0 if x == 0 else pow(2, 10 * x - 10);

static func easeOutExpo(x: float) -> float :
	return 1.0 if x == 1 else 1 - pow(2, -10 * x);

static func easeInOutExpo(x: float) -> float :
	return 0.0 if x == 0 else 1.0 if x == 1 else pow(2, 20 * x - 10) / 2 if x < 0.5  else (2 - pow(2, -20 * x + 10)) / 2;

static func easeInBack(x: float) -> float :
	const c1 = 1.70158;
	const c3 = c1 + 1;

	return c3 * x * x * x - c1 * x * x;

static func easeOutBack(x: float) -> float :
	const c1 = 1.70158;
	const c3 = c1 + 1;

	return 1 + c3 * (x - 1) ** 3 + c1 * (x - 1) ** 2;

static func easeInOutBack(x: float) -> float :
	const c1 = 1.70158;
	const c2 = c1 * 1.525;

	return ((2 * x) ** 2 * ((c2 + 1) * 2 * x - c2)) / 2 if x < 0.5 else ((2 * x - 2) ** 2 * ((c2 + 1) * (x * 2 - 2) + c2) + 2) / 2

static func easeOutBounce(t: float) -> float :
	const n1 = 7.5625;
	const d1 = 2.75;

	if t < 1 / d1:
		return n1 * t * t
	elif t < 2 / d1:
		t -= 1.5 / d1
		return n1 * t * t + 0.75
	elif t < 2.5 / d1:
		t -= 2.25 / d1
		return n1 * t * t + 0.9375
	else:
		t -= 2.625 / d1
		return n1 * t * t + 0.984375

static func easeInBounce(x: float) -> float :
	return 1 - easeOutBounce(1 - x);

static func easeInOutBounce(x: float) -> float :
	return (1 - easeOutBounce(1 - 2 * x)) / 2 if x < 0.5 else (1 + easeOutBounce(2 * x - 1)) / 2
