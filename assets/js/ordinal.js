// modified from https://stackoverflow.com/a/31615643, assumes n < 100
export default function getOrdinal(n) {
  const suffixes = ["th","st","nd","rd"];
  return n + (suffixes[(n-20) % 10] || suffixes[n] || suffixes[0]);
}
