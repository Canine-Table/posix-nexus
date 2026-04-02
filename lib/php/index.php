<?php

	class NxRandom
	{
		private $min;
		private $max;
		private $force;
		private $value;

		function __construct(
			int $max,
			int $min = 1,
			bool $force = false
		) {
			$this->max = $max;
			$this->min = $min;
			$this->force = $force;
			$this->roll();
		}

		function roll() {
			$this->value = ($this->force == true)
				? rand($this->min, $this->max)
				: random_int($this->min, $this->max);
			return $this->value;
		}

		function dec() {
			return $this->value;
		}

		function hex() {
			return dechex($this->value);
		}
	}

class NxDate
{
	public static function formatFullDateAndTime() {
		return self::getCurrentDateTime('Y-m-d H:i:s T (l)');
	}

	public static function formatFullDateTimeWithMicroseconds() {
		return self::getCurrentDateTime('Y-m-d H:i:s.u');
	}

	public static function formatUTC() {
		return self::getCurrentDateTime('Y-m-d\TH:i:s\Z', true);
	}

	public static function formatLocalWithTimezone() {
		return self::getCurrentDateTime('Y-m-d\TH:i:sP');
	}

	public static function formatShortDateTime() {
		return self::getCurrentDateTime('M d H:i:s');
	}

	public static function getUnixTimestamp() {
		return time();
	}

	public static function formatCompactDateTime() {
		return self::getCurrentDateTime('Ymd_His');
	}

	public static function formatWeekdayAndCompactDate() {
		return self::getCurrentDateTime('D_Ymd_Hi');
	}

	public static function formatDateAndTimeWithTimezone() {
		return self::getCurrentDateTime('Y-m-d H:i:s T');
	}
	
	public static function formatLongReadableDate() {
		return self::getCurrentDateTime('l, F j, Y');
	}

	private static function getCurrentDateTime($format, $isUtc = false) {
		$tz = $isUtc ? new DateTimeZone('UTC') : null;
		$dt = new DateTime('now', $tz);
		return $dt->format($format);
	}
}

	include './.env/a6/index.php';  // Include an HTML file
?>
