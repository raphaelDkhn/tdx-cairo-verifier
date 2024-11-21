use starknet::ContractAddress;

use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};

use tdx_verifier::ITdxVerifierDispatcher;
use tdx_verifier::ITdxVerifierDispatcherTrait;
use dcap_cairo::types::{
    QuoteHeader, TD10ReportBody, AttestationPubKey, TdxModule, TdxModuleIdentityTcbLevel,
    TdxModuleTcb
};
use core::starknet::secp256_trait::Signature;

fn deploy_contract(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    contract_address
}

#[test]
fn test_verify_tdx() {
    let contract_address = deploy_contract("TdxVerifier");
    let dispatcher = ITdxVerifierDispatcher { contract_address };


    let quote_header = QuoteHeader {
        version: 4,
        att_key_type: 2,
        tee_type: 129,
        qe_svn: [0, 0].span(),
        pce_svn: [0, 0].span(),
        qe_vendor_id: [147, 154, 114, 51, 247, 156, 76, 169, 148, 10, 13, 179, 149, 127, 6, 7].span(),
        user_data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].span()
    };
    let quote_body = TD10ReportBody {
        tee_tcb_svn: [4, 1, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].span(),
        mrseam: [255, 201, 122, 136, 88, 118, 96, 251, 4, 225, 247, 200, 81, 48, 12, 150, 174, 11, 90, 70, 58, 196, 109, 3, 93, 22, 194, 217, 243, 109, 14, 209, 210, 55, 117, 188, 189, 39, 222, 178, 25, 227, 163, 204, 40, 2, 56, 149].span(),
        mrsignerseam: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].span(),
        seam_attributes: 0,
        td_attributes: 268435456,
        xfam: 393447,
        mrtd: [147, 91, 231, 116, 45, 216, 156, 106, 77, 246, 219, 168, 53, 61, 137, 4, 26, 224, 240, 82, 190, 239, 153, 59, 30, 127, 69, 36, 211, 188, 87, 101, 13, 242, 14, 85, 130, 21, 131, 82, 225, 36, 11, 63, 31, 237, 85, 216].span(),
        mrconfigid: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].span(),
        mrowner: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].span(),
        mrownerconfig: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].span(),
        rtmr0: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].span(),
        rtmr1: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].span(),
        rtmr2: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].span(),
        rtmr3: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].span(),
        report_data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].span(),
    };
    let attestation_signature = Signature { 
        r: 25733343413519117818364551539392220033852927735470667425752255000277207509710, 
        s: 72674971023089189047068507351200803062440645804094665029593294585098605772891, 
        y_parity: false 
    };
    let attestation_pubkey = AttestationPubKey { 
        x: 26453215742624095465431109809211961106411777909052654475810087310567755410373, 
        y: 57984426202587454214512483120226050197502430206168337009185092847479047645354 
    };
    let tdx_module = TdxModule {
        mrsigner: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].span(),
        attributes: 0,
        attributes_mask: 18446744073709551615,
        identity_id: 'TDX_01',
        expected_id: 'TDX_01',
        tcb_levels: [TdxModuleIdentityTcbLevel { tcb: TdxModuleTcb { isvsvn: 2 }, tcb_status: 0 }].span()
    };
    let tcb_info_svn = [3, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].span();

    

    let is_valid = dispatcher.verify_tdx(
        quote_header,
        quote_body,
        attestation_signature,
        attestation_pubkey,
        tdx_module,
        tcb_info_svn
    );
    assert(is_valid == true, 'quote not valid');
}
