//CH2_2MUX.V

module CH2_2MUX(
	I0, I1, S,
	Z
);

input I0, I1;
input S;
output Z;

reg Z;

always @(I0, I1, S)
begin
	if(S==0)Z = I0;
	else Z = I1;
end

endmodule