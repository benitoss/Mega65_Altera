TwoPortRam_inst : TwoPortRam PORT MAP (
		address_a	 => address_a_sig,
		address_b	 => address_b_sig,
		byteena_a	 => byteena_a_sig,
		clock_a	 => clock_a_sig,
		clock_b	 => clock_b_sig,
		data_a	 => data_a_sig,
		data_b	 => data_b_sig,
		wren_a	 => wren_a_sig,
		wren_b	 => wren_b_sig,
		q_a	 => q_a_sig,
		q_b	 => q_b_sig
	);
